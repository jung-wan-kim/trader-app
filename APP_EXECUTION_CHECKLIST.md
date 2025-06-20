# 📱 Trader App 실행 체크리스트

## ✅ 실행 전 필수 확인사항

### 1. 환경 설정
- [x] `config/development.env` 파일 존재 확인
- [x] SUPABASE_URL 설정 확인
- [x] SUPABASE_ANON_KEY 설정 확인
- [x] FINNHUB_API_KEY 설정 확인

### 2. 의존성 설치
```bash
flutter pub get
```

### 3. 환경 변수 검증
```bash
# 환경 파일이 올바르게 설정되었는지 확인
cat config/development.env
```

## 🚀 앱 실행 명령어

### 개발 모드 실행
```bash
# Android
flutter run

# iOS (macOS에서만)
flutter run -d ios

# Web
flutter run -d chrome
```

### 빌드 테스트
```bash
# Android APK
flutter build apk --debug

# iOS (macOS에서만)
flutter build ios --debug
```

## 🧪 기능 테스트 시나리오

### 1. 앱 시작 플로우
1. ✅ 스플래시 화면 표시 (3초)
2. ✅ 온보딩 화면 표시 (첫 실행 시)
3. ✅ 로그인 화면 표시

### 2. 로그인 테스트
#### Demo 모드
1. "Demo Mode" 버튼 클릭
2. ✅ 홈 화면으로 이동
3. ✅ Mock 데이터로 앱 기능 체험

#### 실제 로그인 (Supabase 연결 필요)
1. 이메일/비밀번호 입력
2. "로그인" 버튼 클릭
3. ✅ 인증 성공 시 홈 화면 이동

### 3. 홈 화면 데이터 로딩
1. ✅ TradingView 추천 데이터 로드
2. ✅ 에러 시 Mock 데이터 표시
3. ✅ 포트폴리오 요약 정보 표시

### 4. 주요 기능 테스트
#### Watchlist (관심종목)
1. ✅ 관심종목 목록 표시
2. ✅ 실시간 가격 업데이트 (60초 주기)
3. ✅ 종목 검색 및 추가

#### Position (포지션)
1. ✅ 보유 포지션 목록 표시
2. ✅ 포지션 편집 (수량, 손절가, 목표가)
3. ✅ 실시간 가격 업데이트 (30초 주기)
4. ✅ 손익 계산 및 표시

#### 투자 성과
1. ✅ 포트폴리오 총 가치 표시
2. ✅ 30일 성과 차트
3. ✅ 거래 통계 (승률, 평균 수익률 등)
4. ✅ 최근 거래 내역

#### 프로필
1. ✅ 사용자 정보 표시
2. ✅ 구독 상태 표시
3. ✅ 알림 설정
4. ✅ 언어 설정

## 🔧 문제 해결

### 환경 변수 오류
```
Error: SUPABASE_URL is not set in environment variables
```
**해결방법**: `config/development.env` 파일 생성 및 설정

### Supabase 연결 오류
```
Error: Failed to connect to Supabase
```
**해결방법**: 
1. SUPABASE_URL과 SUPABASE_ANON_KEY 확인
2. 인터넷 연결 확인
3. Demo 모드로 테스트

### 빌드 오류
```
Error: Package not found
```
**해결방법**: 
```bash
flutter clean
flutter pub get
flutter run
```

## 📊 예상 성능

### 앱 크기
- Debug APK: ~50MB
- Release APK: ~20MB

### 메모리 사용량
- 초기 실행: ~80MB
- 정상 사용: ~120MB

### 네트워크 사용량
- 초기 데이터 로드: ~2MB
- 실시간 업데이트: ~100KB/분

## ⚠️ 알려진 제한사항

1. **실시간 거래**: UI만 구현, 실제 거래 실행 불가
2. **결제 시스템**: 스토어 연동 미완성
3. **Push 알림**: 로컬 알림만 지원
4. **오프라인**: 인터넷 연결 필수

## 🎯 테스트 통과 기준

- [ ] 앱이 크래시 없이 실행됨
- [ ] 모든 화면이 정상 표시됨
- [ ] Demo 모드에서 모든 기능 접근 가능
- [ ] 실시간 가격 업데이트 동작
- [ ] 포지션 편집 기능 동작
- [ ] 언어 전환 기능 동작

---

**마지막 업데이트**: 2025-06-20  
**앱 버전**: 1.0.0+1  
**Flutter 버전**: 3.0.0+