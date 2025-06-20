# 📱 iOS 실행 가이드

## 🔧 사전 요구사항

### 1. macOS 환경
- macOS 12.0 이상
- Xcode 14.0 이상 설치
- Command Line Tools 설치

### 2. Flutter 환경
```bash
flutter doctor -v
```

### 3. iOS 시뮬레이터 확인
```bash
# 사용 가능한 시뮬레이터 목록
xcrun simctl list devices

# 시뮬레이터 실행 (예: iPhone 15)
open -a Simulator --args -CurrentDeviceUDID [DEVICE_ID]
```

## 🚀 iOS 실행 단계

### 1. 프로젝트 준비
```bash
cd /Users/jung-wankim/Project/Claude/trader-app

# Flutter 의존성 설치
flutter pub get

# iOS CocoaPods 설치
cd ios
pod install
cd ..
```

### 2. 환경 변수 설정 확인
```bash
# 환경 파일 존재 확인
ls -la config/development.env

# 환경 변수 내용 확인
cat config/development.env
```

### 3. iOS 디바이스 확인
```bash
# 연결된 디바이스 및 시뮬레이터 확인
flutter devices
```

### 4. iOS 실행
```bash
# 기본 iOS 시뮬레이터에서 실행
flutter run -d ios

# 특정 시뮬레이터 지정
flutter run -d "iPhone 15 Simulator"

# 디버그 모드로 실행
flutter run --debug -d ios

# 프로파일 모드로 실행
flutter run --profile -d ios
```

### 5. 실제 iPhone에서 실행 (선택사항)
```bash
# 실제 디바이스 연결 후
flutter run -d [DEVICE_NAME]
```

## 📋 iOS 특화 설정

### Bundle Identifier
- 현재 설정: `com.example.trader_app`
- 필요시 `ios/Runner.xcodeproj`에서 변경

### 지원 iOS 버전
- 최소 버전: iOS 13.0
- 권장 버전: iOS 15.0 이상

### 권한 설정 (Info.plist)
```xml
<!-- 카메라 권한 -->
<key>NSCameraUsageDescription</key>
<string>프로필 사진 촬영을 위해 카메라 접근 권한이 필요합니다.</string>

<!-- 사진 라이브러리 권한 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>프로필 사진 선택을 위해 사진 라이브러리 접근 권한이 필요합니다.</string>
```

## 🔧 문제 해결

### CocoaPods 오류
```bash
cd ios
pod deintegrate
pod install
```

### Xcode 빌드 오류
```bash
# Flutter 클린 및 재빌드
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run -d ios
```

### 시뮬레이터 느린 문제
- Simulator > Device > Erase All Content and Settings
- 시뮬레이터 재시작

### Privacy 관련 오류
Podfile에 이미 수정사항 포함:
```ruby
# Skip privacy bundle targets
if target.name.end_with?('_privacy')
  config.build_settings.delete('INFOPLIST_FILE')
end
```

## 📱 테스트 시나리오 (iOS)

### 1. 기본 동작 확인
- [ ] 앱 아이콘 표시
- [ ] 스플래시 화면 표시
- [ ] 로그인 화면 전환

### 2. iOS 특화 기능
- [ ] Face ID / Touch ID (있는 경우)
- [ ] 홈 제스처 (iPhone X 이상)
- [ ] 다크 모드 지원
- [ ] 세이프 에어리어 처리

### 3. 권한 테스트
- [ ] 카메라 권한 요청
- [ ] 사진 라이브러리 권한
- [ ] 알림 권한 (구현된 경우)

### 4. 성능 테스트
- [ ] 앱 시작 시간 (<3초)
- [ ] 화면 전환 부드러움
- [ ] 메모리 사용량 (<150MB)

## 🎯 성공 기준

### 기본 동작
- ✅ 앱이 크래시 없이 실행
- ✅ 모든 화면이 iOS에서 정상 표시
- ✅ 터치 인터랙션 정상 동작

### iOS 특화
- ✅ 다양한 iPhone 화면 크기 지원
- ✅ 세이프 에어리어 적절히 처리
- ✅ iOS 디자인 가이드라인 준수

## 📊 예상 결과

### 앱 크기
- Debug IPA: ~80MB
- Release IPA: ~30MB

### 메모리 사용량
- iPhone 12 이상: ~120MB
- 구형 디바이스: ~100MB

### 성능
- 앱 시작: 2-3초
- 화면 전환: <0.5초
- 60fps 유지

---

**실행 명령어 요약:**
```bash
# 1. 의존성 설치
flutter pub get && cd ios && pod install && cd ..

# 2. iOS 실행
flutter run -d ios

# 3. 문제 발생시
flutter clean && flutter pub get && cd ios && pod install && cd .. && flutter run -d ios
```