# Trader App DevOps Guide

이 문서는 Trader App의 CI/CD 파이프라인, 빌드 자동화, 배포 프로세스 및 모니터링 설정에 대한 가이드입니다.

## 목차

1. [개요](#개요)
2. [CI/CD 파이프라인](#cicd-파이프라인)
3. [Fastlane 설정](#fastlane-설정)
4. [환경 설정](#환경-설정)
5. [모니터링](#모니터링)
6. [배포 프로세스](#배포-프로세스)
7. [문제 해결](#문제-해결)

## 개요

Trader App은 다음과 같은 DevOps 도구를 사용합니다:

- **CI/CD**: GitHub Actions
- **빌드 자동화**: Fastlane
- **에러 트래킹**: Sentry, Firebase Crashlytics
- **분석**: Firebase Analytics
- **성능 모니터링**: Firebase Performance
- **원격 설정**: Firebase Remote Config

## CI/CD 파이프라인

### GitHub Actions 워크플로우

#### 1. CI (Continuous Integration)
`.github/workflows/ci.yml`

- **트리거**: main, develop 브랜치에 push 또는 PR 생성 시
- **작업**:
  - 코드 분석 (Flutter Analyze)
  - 코드 포맷팅 검사
  - 단위 테스트 실행
  - 테스트 커버리지 리포트
  - Android APK/Bundle 빌드
  - iOS 빌드

#### 2. CD (Continuous Deployment)
`.github/workflows/cd.yml`

- **트리거**: 버전 태그 생성 또는 수동 실행
- **작업**:
  - 환경별 빌드 (development, staging, production)
  - Play Store 배포 (Android)
  - App Store 배포 (iOS)
  - GitHub Release 생성

#### 3. 코드 품질
`.github/workflows/code-quality.yml`

- **트리거**: PR 및 main/develop 브랜치 push
- **작업**:
  - 보안 취약점 스캔 (Trivy)
  - 의존성 검사
  - 코드 커버리지 분석
  - 린트 검사

#### 4. 릴리스 관리
`.github/workflows/release.yml`

- **트리거**: main 브랜치 push 또는 수동 실행
- **작업**:
  - 버전 자동 증가
  - 변경 로그 생성
  - 태그 생성
  - 릴리스 노트 작성

### 필요한 GitHub Secrets

```yaml
# Android
ANDROID_KEYSTORE_BASE64        # Base64로 인코딩된 keystore 파일
ANDROID_KEYSTORE_PASSWORD      # Keystore 비밀번호
ANDROID_KEY_ALIAS             # Key alias
ANDROID_KEY_PASSWORD          # Key 비밀번호
PLAY_STORE_SERVICE_ACCOUNT_JSON # Google Play 서비스 계정 JSON

# iOS
IOS_CERTIFICATE_BASE64        # Base64로 인코딩된 인증서
IOS_CERTIFICATE_PASSWORD      # 인증서 비밀번호
IOS_PROVISIONING_PROFILE_BASE64 # Base64로 인코딩된 프로비저닝 프로파일
KEYCHAIN_PASSWORD            # 임시 키체인 비밀번호
APP_STORE_CONNECT_API_KEY_ID # App Store Connect API 키 ID
APP_STORE_CONNECT_API_ISSUER_ID # API 발급자 ID
APP_STORE_CONNECT_API_KEY_BASE64 # Base64로 인코딩된 API 키

# 기타
SLACK_WEBHOOK_URL            # Slack 알림 URL (선택사항)
```

## Fastlane 설정

### Android Fastlane

위치: `/android/fastlane/`

#### 주요 레인:

1. **test**: 테스트 실행
2. **build_debug**: 디버그 APK 빌드
3. **build_release**: 릴리스 APK 빌드
4. **build_bundle**: 릴리스 번들 빌드
5. **deploy_development**: 내부 테스트 트랙 배포
6. **deploy_staging**: 알파 트랙 배포
7. **deploy_production**: 프로덕션 배포 (10% 롤아웃)

#### 설정 방법:

```bash
cd android
bundle install
bundle exec fastlane init
```

### iOS Fastlane

위치: `/ios/fastlane/`

#### 주요 레인:

1. **beta**: TestFlight 베타 빌드
2. **build_development**: 개발 빌드
3. **build_staging**: 스테이징 빌드
4. **deploy_development**: 내부 TestFlight 배포
5. **deploy_staging**: 외부 TestFlight 배포
6. **deploy_production**: App Store 배포
7. **setup_signing**: 인증서 및 프로비저닝 프로파일 설정

#### Match 설정:

```bash
cd ios
bundle install
bundle exec fastlane match init
```

## 환경 설정

### 환경 파일

`/config/` 디렉토리의 환경별 설정 파일:

- `development.env`: 개발 환경
- `staging.env`: 스테이징 환경
- `production.env`: 프로덕션 환경
- `.env.example`: 환경 변수 예제

### 환경 변수

```bash
# API 설정
API_BASE_URL
SUPABASE_URL
SUPABASE_ANON_KEY

# Firebase 설정
FIREBASE_PROJECT_ID
FIREBASE_APP_ID_IOS
FIREBASE_APP_ID_ANDROID
FIREBASE_API_KEY
FIREBASE_MESSAGING_SENDER_ID

# Sentry 설정
SENTRY_DSN
SENTRY_ENVIRONMENT
SENTRY_RELEASE_PREFIX

# 기능 플래그
ENABLE_ANALYTICS
ENABLE_CRASH_REPORTING
ENABLE_PERFORMANCE_MONITORING
ENABLE_REMOTE_CONFIG

# 디버그 설정
DEBUG_MODE
VERBOSE_LOGGING
MOCK_API_ENABLED
```

### Flutter에서 환경 설정 사용

```dart
// lib/config/env_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// main.dart에서 초기화
await EnvConfig.init();

// 환경별 빌드
flutter build apk --dart-define=ENVIRONMENT=production
```

## 모니터링

### Sentry 설정

1. **프로젝트 생성**: [sentry.io](https://sentry.io)에서 프로젝트 생성
2. **DSN 설정**: 환경 파일에 DSN 추가
3. **초기화**: `main.dart`에서 SentryService 초기화

```dart
await SentryService.init(
  appRunner: () async {
    runApp(MyApp());
  },
);
```

### Firebase 설정

1. **Firebase 프로젝트 생성**: [Firebase Console](https://console.firebase.google.com)
2. **앱 추가**: Android/iOS 앱 추가
3. **설정 파일 다운로드**:
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`
4. **초기화**: `main.dart`에서 FirebaseService 초기화

```dart
await FirebaseService.init();
```

### 모니터링 기능

- **에러 트래킹**: 자동/수동 에러 리포팅
- **성능 모니터링**: 네트워크 요청, 화면 렌더링 시간
- **사용자 분석**: 이벤트, 화면 조회, 사용자 속성
- **원격 설정**: 기능 플래그, 설정 값 원격 관리

## 배포 프로세스

### 1. 개발 환경 배포

```bash
# 수동 배포
cd android && bundle exec fastlane deploy_development
cd ios && bundle exec fastlane deploy_development

# GitHub Actions 트리거
git push origin develop
```

### 2. 스테이징 환경 배포

```bash
# GitHub Actions 수동 실행
# Actions 탭 > CD - Deploy > Run workflow
# Environment: staging 선택
```

### 3. 프로덕션 배포

```bash
# 버전 태그 생성
git tag v1.0.0
git push origin v1.0.0

# 또는 Release Management 워크플로우 실행
```

### 4. 버전 관리

- **Major**: 주요 기능 추가 또는 breaking changes
- **Minor**: 새로운 기능 추가
- **Patch**: 버그 수정

## 문제 해결

### 빌드 실패

1. **의존성 문제**
   ```bash
   flutter clean
   flutter pub get
   cd ios && pod install
   ```

2. **서명 문제 (iOS)**
   ```bash
   cd ios
   bundle exec fastlane match nuke development
   bundle exec fastlane match development
   ```

3. **서명 문제 (Android)**
   - keystore 파일 경로 확인
   - 비밀번호 확인
   - key alias 확인

### 배포 실패

1. **Play Store 배포 실패**
   - 서비스 계정 권한 확인
   - 버전 코드 중복 확인
   - 앱 번들 서명 확인

2. **App Store 배포 실패**
   - App Store Connect API 키 확인
   - 프로비저닝 프로파일 확인
   - 번들 ID 일치 확인

### 모니터링 이슈

1. **Sentry 이벤트 미수신**
   - DSN 확인
   - 네트워크 연결 확인
   - 환경 설정 확인

2. **Firebase 데이터 미표시**
   - 설정 파일 위치 확인
   - 번들 ID/패키지명 확인
   - 초기화 코드 확인

## 보안 가이드

1. **시크릿 관리**
   - 절대 코드에 직접 시크릿 하드코딩 금지
   - 환경 변수 또는 GitHub Secrets 사용
   - `.gitignore`에 민감한 파일 추가

2. **인증서 관리**
   - Match를 통한 iOS 인증서 중앙 관리
   - Android keystore 안전한 보관
   - 정기적인 인증서 갱신

3. **API 키 보안**
   - 환경별 다른 API 키 사용
   - 프로덕션 키는 제한된 권한만 부여
   - 정기적인 키 로테이션

## 추가 리소스

- [Flutter DevOps 문서](https://flutter.dev/docs/deployment/cd)
- [Fastlane 문서](https://docs.fastlane.tools)
- [GitHub Actions 문서](https://docs.github.com/en/actions)
- [Firebase 문서](https://firebase.google.com/docs)
- [Sentry Flutter 문서](https://docs.sentry.io/platforms/flutter/)