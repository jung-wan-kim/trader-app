# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 텔레그램 메시지 처리

### 메시지 폴링 전략
- 5초마다 텔레그램 `get_updates`를 호출해서 새 메시지를 확인하고 새 메시지가 있으면 그 메시지대로 실행해

## 빌드 및 테스트 명령어

### 기본 명령어
```bash
# 의존성 설치
flutter pub get

# 개발 서버 실행
flutter run

# 빌드
flutter build apk --debug       # Android 디버그 빌드
flutter build ios --debug       # iOS 디버그 빌드
```

[... rest of the existing content remains unchanged ...]