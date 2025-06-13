# UI 통합 테스트 결과

## 개요
Flutter 앱의 실제 UI 통합 테스트를 작성하고 실행 환경을 구성했습니다.

## 테스트 파일 위치
- `integration_test/ui_integration_test.dart`

## 테스트 항목
1. **전체 앱 플로우 테스트**
   - 로그인 → 전략 실행까지의 전체 흐름
   - Demo 계정으로 시작
   - 추천 전략 확인 및 상세 화면 이동
   - 프로필 화면 확인

2. **네비게이션 테스트**
   - 모든 메인 탭 간 이동
   - Home, Discover, Upload, Inbox, Profile

3. **리스크 계산기 상호작용**
   - 전략 상세 화면에서 리스크 계산기 사용
   - 계좌 잔액 입력 및 계산

4. **스크롤 성능 테스트**
   - 추천 목록에서의 스크롤 성능
   - 빠른 스크롤 시 앱 반응성 확인

5. **언어 변경 기능**
   - 프로필 → 설정 → 언어 변경
   - 한국어 → 영어 전환 테스트

6. **포트폴리오 표시 및 상호작용**
   - 포트폴리오 섹션 확인
   - 포지션 카드 상호작용

7. **비디오 플레이어 상호작용 (Discover)**
   - 비디오 콘텐츠 확인
   - 좋아요, 댓글, 공유 버튼 확인

8. **알림 탭 (Inbox)**
   - 활동/메시지 탭 전환

9. **거래 실행 플로우**
   - Execute Trade 버튼 테스트

10. **헤비 스크롤 시 앱 성능**
    - 연속적인 빠른 스크롤
    - 앱 반응성 유지 확인

## 실행 방법

### 자동 실행 스크립트
```bash
./scripts/run-ui-tests.sh
```

### 수동 실행

#### iOS 시뮬레이터
```bash
# 시뮬레이터 실행
open -a Simulator

# 테스트 실행
flutter test integration_test/ui_integration_test.dart -d <device_id>
```

#### Android 에뮬레이터
```bash
# 에뮬레이터 실행
emulator -avd <avd_name>

# 테스트 실행
flutter test integration_test/ui_integration_test.dart -d emulator-5554
```

#### 실제 디바이스
```bash
# 디바이스 목록 확인
flutter devices

# 테스트 실행
flutter test integration_test/ui_integration_test.dart -d <device_id>
```

## 주의사항
1. **디바이스 요구사항**
   - macOS에서는 기본적으로 iOS/Android 시뮬레이터가 필요
   - 실제 디바이스 사용 시 USB 디버깅 활성화 필요

2. **환경 설정**
   - SharedPreferences 초기값 설정
   - Demo 모드 활성화
   - 온보딩 스킵 설정

3. **테스트 시간**
   - 전체 UI 테스트 스위트 실행 시 약 5-10분 소요
   - 디바이스 성능에 따라 차이 있음

## 현재 상태
- 테스트 작성: ✅ 완료
- 실행 스크립트: ✅ 완료
- 실제 실행: ⚠️ 디바이스/시뮬레이터 필요

## 개선 사항
1. CI/CD 환경에서의 자동 실행 설정
2. 스크린샷 캡처 기능 추가
3. 성능 메트릭 수집 및 리포팅
4. 다양한 화면 크기에서의 테스트