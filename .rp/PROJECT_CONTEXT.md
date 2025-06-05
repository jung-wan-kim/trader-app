# 프로젝트 컨텍스트

## 프로젝트 정보
- **프로젝트명**: trader-app
- **설명**: Flutter 기반의 트레이딩 애플리케이션
- **타입**: 모바일 앱
- **생성일**: 2025-06-06

## 프로젝트 구조
```
- App.js
- android/
- ios/
- lib/
  - main.dart
  - models/
  - screens/
  - widgets/
- src/
  - components/
  - config/
  - screens/
- scripts/
- supabase/
- tests/
```

## 기술 스택
- Frontend: Flutter (Dart), React Native
- Backend: Supabase
- Database: PostgreSQL (Supabase)
- Infrastructure: iOS/Android native

## 주요 기능
1. 비디오 피드 보기 (TikTok 스타일)
2. 사용자 프로필 관리
3. 비디오 업로드 및 공유
4. 검색 기능
5. 메시지/인박스 기능

## 개발 가이드라인
- 코딩 스타일: Flutter/Dart 표준 가이드라인
- 브랜치 전략: Git Flow
- 커밋 규칙: Conventional Commits

## RP 활용 가이드
이 프로젝트에서는 다음과 같이 RP를 활용합니다:

### 프로젝트 특화 지시사항
각 RP는 이 프로젝트의 컨텍스트를 이해하고 작업을 수행합니다.
- 모든 코드는 프로젝트의 기존 스타일을 따릅니다
- 기술 스택은 위에 명시된 것을 사용합니다
- 프로젝트의 주요 기능을 고려하여 작업합니다

### Claude Code 사용 예시
```bash
# 프로젝트 컨텍스트와 함께 특정 RP 활용
claude-code ".rp/PROJECT_CONTEXT.md와 .rp/backend-developer.md를 참고해서 
            새로운 API 엔드포인트를 추가해줘"

# 전체 팀 시뮬레이션
claude-code ".rp/PROJECT_CONTEXT.md를 기반으로 모든 RP를 활용해서 
            새로운 기능을 개발해줘"
```