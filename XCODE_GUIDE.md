# 🍎 Xcode에서 Trader App 실행하기

## 📋 Xcode 직접 실행 방법

Flutter 없이 Xcode에서 직접 빌드하고 실행할 수 있습니다.

### 1. 프로젝트 열기
```bash
# 워크스페이스 파일로 열기 (권장)
open ios/Runner.xcworkspace

# 또는 Finder에서
# ios/Runner.xcworkspace 더블클릭
```

### 2. 빌드 설정 확인

#### Target 설정
- **Project**: Runner
- **Target**: Runner
- **Bundle Identifier**: com.example.trader_app
- **Deployment Target**: iOS 13.0

#### Signing & Capabilities
- **Team**: 개발자 계정 선택
- **Bundle Identifier**: 고유 ID로 변경 (필요시)

### 3. 시뮬레이터 선택
- Xcode 상단에서 시뮬레이터 선택
- 권장: iPhone 15 (iOS 17.0)

### 4. 빌드 및 실행
- **빌드**: ⌘+B
- **실행**: ⌘+R
- 또는 재생 버튼(▶️) 클릭

## 🔧 Flutter 의존성 문제 해결

### 문제: Generated.xcconfig 없음
```bash
# 터미널에서 실행
cd /path/to/trader-app
flutter pub get
```

### 문제: Pod 의존성 없음
```bash
# iOS 디렉토리에서
cd ios
pod install
```

### 문제: Flutter 엔진 없음
- Flutter 프로젝트는 Flutter SDK가 필요합니다
- Flutter 설치 후 `flutter pub get` 필수

## 📱 빌드 타겟 설정

### Debug 빌드
- **속도**: 빠름
- **크기**: 큼 (~80MB)
- **디버깅**: 가능
- **Hot Reload**: 지원

### Release 빌드
- **속도**: 느림
- **크기**: 작음 (~30MB)
- **성능**: 최적화됨
- **디버깅**: 제한적

## 🎯 Xcode 전용 설정

### 1. 스킴 설정
- **Product > Scheme > Edit Scheme**
- **Run > Build Configuration**: Debug/Release 선택

### 2. 코드 서명
```
Signing & Capabilities 탭에서:
- Automatically manage signing ✅
- Team: 개발자 계정 선택
- Bundle Identifier: 고유 ID 입력
```

### 3. 디바이스 대상
```
Deployment Info:
- iPhone ✅
- iPad ✅ (선택사항)
- Minimum iOS: 13.0
```

## 📋 Xcode 빌드 로그 확인

### 성공적인 빌드
```
Build Succeeded
CompileSwift: AppDelegate.swift
LinkStoryboards: LaunchScreen.storyboard
ProcessInfoPlistFile: Info.plist
```

### 일반적인 오류

#### 1. CocoaPods 의존성 오류
```
error: module map file '/path/to/Pods/...' not found
```
**해결**: `cd ios && pod install`

#### 2. Flutter 엔진 오류
```
error: Flutter.h file not found
```
**해결**: `flutter pub get` 실행

#### 3. 서명 오류
```
error: No profiles for 'com.example.trader_app' were found
```
**해결**: Bundle ID 변경 또는 개발자 계정 설정

## 🚀 실행 가능한 시나리오

### 시나리오 1: Flutter 완전 설치됨
- ✅ 모든 기능 정상 동작
- ✅ Hot Reload 지원
- ✅ 디버깅 가능

### 시나리오 2: Flutter 미설치 (Xcode만)
- ❌ 빌드 실패 (Generated.xcconfig 없음)
- ❌ Pod 의존성 없음
- ⚠️ 네이티브 부분만 빌드 가능

### 시나리오 3: 부분 설치
- ⚠️ 빌드 가능하지만 런타임 오류
- ⚠️ Dart 코드 실행 안 됨
- 🔧 추가 설정 필요

## 📊 Xcode 프로젝트 구조

```
Runner.xcworkspace/
├── Runner.xcodeproj/          # 메인 프로젝트
├── Pods/                      # CocoaPods 의존성
└── Flutter/                   # Flutter 관련 파일

Runner/
├── AppDelegate.swift          # 앱 진입점
├── Info.plist                # 앱 설정
├── Assets.xcassets/           # 이미지 리소스
└── Base.lproj/               # 스토리보드
```

## 🎯 성공 기준

### Xcode 빌드 성공
- [ ] 빌드 오류 없음
- [ ] 시뮬레이터에 설치 완료
- [ ] 앱 아이콘 표시됨

### 앱 실행 성공
- [ ] 스플래시 화면 표시
- [ ] 크래시 없이 실행
- [ ] 기본 UI 표시

---

**주의사항**: 
- Flutter 프로젝트는 Flutter SDK 없이는 완전한 기능을 제공할 수 없습니다
- 가장 좋은 개발 경험을 위해서는 Flutter 설치를 권장합니다