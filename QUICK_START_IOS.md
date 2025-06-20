# 🚀 iOS 빠른 실행 가이드

## 📋 한 줄 요약
```bash
./scripts/run_ios.sh
```

## 🔧 사전 준비 (1회만)

### 1. Flutter 설치
```bash
# Homebrew로 설치 (권장)
brew install --cask flutter

# 또는 수동 설치
# https://docs.flutter.dev/get-started/install/macos
```

### 2. Xcode 설치
- App Store에서 "Xcode" 검색 및 설치
- 또는 터미널에서: `xcode-select --install`

### 3. 환경 변수 설정
```bash
# 환경 파일 생성
cp config/development.env.example config/development.env

# 실제 Supabase 키 입력 (필수)
nano config/development.env
```

## 🚀 실행 방법

### 방법 1: 자동 스크립트 (권장)
```bash
./scripts/run_ios.sh
```

### 방법 2: 수동 실행
```bash
# 1. 의존성 설치
flutter pub get
cd ios && pod install && cd ..

# 2. 시뮬레이터 실행
open -a Simulator

# 3. 앱 실행
flutter run -d ios
```

## 📱 예상 결과

### 성공 시
1. iOS 시뮬레이터가 자동으로 실행됩니다
2. "Trader App" 아이콘이 시뮬레이터에 설치됩니다
3. 스플래시 화면 → 로그인 화면이 나타납니다
4. "Demo Mode" 버튼으로 앱을 체험할 수 있습니다

### 앱 기능 테스트
- ✅ **홈**: 실시간 주식 추천
- ✅ **포트폴리오**: 보유 주식 관리
- ✅ **관심종목**: 관심 주식 추적
- ✅ **투자성과**: 수익률 분석
- ✅ **프로필**: 사용자 설정

## 🔧 문제 해결

### Flutter 명령어 오류
```bash
# Flutter PATH 추가 (.zshrc 또는 .bash_profile)
export PATH="$PATH:[Flutter 설치 경로]/bin"
source ~/.zshrc
```

### CocoaPods 오류
```bash
sudo gem install cocoapods
cd ios && pod deintegrate && pod install
```

### 시뮬레이터 느린 문제
```bash
# 시뮬레이터 재설정
xcrun simctl erase all
```

### 환경 변수 오류
```bash
# development.env 파일 확인
cat config/development.env

# 예제 파일과 비교
cat config/development.env.example
```

## 📊 시스템 요구사항

### 필수
- macOS 12.0 이상
- Xcode 14.0 이상
- 디스크 여유 공간 5GB 이상

### 권장
- macOS 13.0 이상
- 메모리 8GB 이상
- SSD 스토리지

## 🎯 성공 확인

앱이 정상적으로 실행되면:
- [ ] 스플래시 화면이 3초간 표시됨
- [ ] 로그인 화면이 나타남
- [ ] "Demo Mode" 버튼 동작
- [ ] 홈 화면에서 추천 주식 표시
- [ ] 하단 탭 네비게이션 동작

---

**문제 발생 시**: 
1. `flutter doctor` 실행하여 환경 확인
2. 터미널 에러 메시지 확인
3. [Flutter 공식 문서](https://docs.flutter.dev/get-started/install/macos) 참조