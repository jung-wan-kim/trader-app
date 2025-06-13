#!/usr/bin/env python3
"""
텔레그램 메시지 폴링 스크립트
5초마다 새로운 메시지를 확인하고 처리합니다.
"""

import time
import json
import subprocess
import sys
from datetime import datetime

def get_telegram_updates(offset=None):
    """텔레그램에서 새로운 업데이트를 가져옵니다."""
    cmd = ["claude", "mcp", "-s", "user", "call", "telegram-mcp-server", "get_updates"]
    
    if offset:
        params = {"offset": offset}
        cmd.extend(["--params", json.dumps(params)])
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0:
            return json.loads(result.stdout)
        else:
            print(f"오류 발생: {result.stderr}")
            return None
    except Exception as e:
        print(f"업데이트 가져오기 실패: {e}")
        return None

def process_message(message):
    """받은 메시지를 처리합니다."""
    chat_id = message.get("chat", {}).get("id")
    text = message.get("text", "")
    from_user = message.get("from", {}).get("username", "Unknown")
    
    print(f"\n[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] 새 메시지:")
    print(f"  보낸 사람: @{from_user}")
    print(f"  내용: {text}")
    
    # 메시지 내용에 따라 명령 실행
    if text.strip():
        print(f"  명령 실행 중: {text}")
        try:
            # Claude Code에 명령 전달
            result = subprocess.run(
                ["claude", "code", text],
                capture_output=True,
                text=True,
                cwd="/Users/jung-wankim/Project/trader-app"
            )
            
            response = "✅ 명령이 실행되었습니다."
            if result.stdout:
                response += f"\n\n출력:\n{result.stdout[:1000]}"  # 최대 1000자
            
            # 응답 메시지 전송
            send_response(chat_id, response)
            
        except Exception as e:
            error_msg = f"❌ 명령 실행 중 오류 발생: {str(e)}"
            print(f"  오류: {e}")
            send_response(chat_id, error_msg)

def send_response(chat_id, text):
    """텔레그램으로 응답을 보냅니다."""
    cmd = [
        "claude", "mcp", "-s", "user", "call", 
        "telegram-mcp-server", "send_message",
        "--params", json.dumps({
            "chatId": chat_id,
            "text": text
        })
    ]
    
    try:
        subprocess.run(cmd, capture_output=True, text=True)
    except Exception as e:
        print(f"응답 전송 실패: {e}")

def main():
    """메인 폴링 루프"""
    print("텔레그램 메시지 폴링을 시작합니다...")
    print("봇 이름: @hue05_bot")
    print("폴링 주기: 5초")
    print("종료하려면 Ctrl+C를 누르세요.\n")
    
    last_update_id = None
    
    try:
        while True:
            # 새로운 업데이트 가져오기
            updates = get_telegram_updates(last_update_id)
            
            if updates and "result" in updates:
                for update in updates["result"]:
                    update_id = update.get("update_id")
                    message = update.get("message")
                    
                    if message:
                        process_message(message)
                    
                    # 다음 폴링을 위해 update_id 저장
                    if update_id:
                        last_update_id = update_id + 1
            
            # 5초 대기
            time.sleep(5)
            
    except KeyboardInterrupt:
        print("\n\n폴링을 종료합니다.")
        sys.exit(0)

if __name__ == "__main__":
    main()