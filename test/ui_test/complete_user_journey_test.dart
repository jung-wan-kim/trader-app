import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/main.dart';
import 'package:trader_app/screens/splash_screen.dart';
import 'package:trader_app/screens/language_selection_screen.dart';
import 'package:trader_app/screens/onboarding_screen.dart';
import 'package:trader_app/screens/login_screen.dart';
import 'package:trader_app/screens/trader_selection_screen.dart';
import 'package:trader_app/screens/subscription_screen.dart';
import 'package:trader_app/screens/main_screen.dart';
import 'package:trader_app/screens/home_screen.dart';
import 'package:trader_app/screens/strategy_detail_screen.dart';
import 'package:trader_app/screens/position_screen.dart';
import 'package:trader_app/screens/investment_performance_screen.dart';
import 'package:trader_app/screens/profile_screen.dart';
import 'package:trader_app/models/trader_strategy.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// 완전한 사용자 여정 테스트
// 각 RP의 관점을 통합한 전체 시나리오 테스트

@GenerateMocks([SharedPreferences])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('완전한 사용자 여정 테스트', () {
    setUp(() async {
      // 테스트 환경 초기화
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('신규 사용자 - 첫 사용부터 매매까지의 전체 여정', (WidgetTester tester) async {
      // Product Manager 관점: 사용자가 앱의 핵심 가치를 경험하는 과정
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      // 1. 스플래시 화면
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('AI 주식 추천'), findsOneWidget);
      
      // 3초 대기
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // 2. 언어 선택 화면 (첫 실행)
      expect(find.byType(LanguageSelectionScreen), findsOneWidget);
      expect(find.text('언어를 선택하세요'), findsOneWidget);
      
      // UX/UI Designer 관점: 직관적인 언어 선택
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // 3. 온보딩 화면
      expect(find.byType(OnboardingScreen), findsOneWidget);
      
      // 온보딩 4단계 진행
      for (int i = 0; i < 4; i++) {
        // 각 온보딩 페이지 확인
        if (i == 0) {
          expect(find.textContaining('전설적인 트레이더'), findsOneWidget);
        } else if (i == 1) {
          expect(find.textContaining('AI 분석'), findsOneWidget);
        } else if (i == 2) {
          expect(find.textContaining('리스크 관리'), findsOneWidget);
        } else if (i == 3) {
          expect(find.textContaining('실시간 알림'), findsOneWidget);
        }
        
        if (i < 3) {
          // 다음 페이지로 스와이프
          await tester.drag(
            find.byType(PageView),
            const Offset(-400, 0),
          );
          await tester.pumpAndSettle();
        }
      }
      
      // 시작하기 버튼 클릭
      await tester.tap(find.text('시작하기'));
      await tester.pumpAndSettle();

      // 4. 약관 동의 화면
      expect(find.text('서비스 이용약관'), findsOneWidget);
      expect(find.text('개인정보 처리방침'), findsOneWidget);
      
      // 전체 동의
      await tester.tap(find.byKey(const Key('agree_all_checkbox')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // 5. 로그인 화면
      expect(find.byType(LoginScreen), findsOneWidget);
      
      // Frontend Developer 관점: 폼 검증 테스트
      // 잘못된 이메일 형식
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'invalid-email',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.text('로그인'));
      await tester.pumpAndSettle();
      
      expect(find.text('올바른 이메일 형식이 아닙니다'), findsOneWidget);
      
      // 올바른 로그인 정보 입력
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'Test123!@#',
      );
      await tester.tap(find.text('로그인'));
      await tester.pumpAndSettle();

      // 6. 전략가 선택 화면
      expect(find.byType(TraderSelectionScreen), findsOneWidget);
      expect(find.text('투자 전략을 선택하세요'), findsOneWidget);
      
      // 전략 정보 확인
      expect(find.text('제시 리버모어'), findsOneWidget);
      expect(find.text('래리 윌리엄스'), findsOneWidget);
      expect(find.text('스탠 와인스타인'), findsOneWidget);
      
      // 제시 리버모어 선택
      await tester.tap(find.byKey(const Key('strategy_jesse_livermore')));
      await tester.pumpAndSettle();
      
      // 선택 확인 (체크 표시)
      expect(
        find.byIcon(Icons.check_circle),
        findsNWidgets(1),
      );
      
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // 7. 구독 플랜 선택 화면
      expect(find.byType(SubscriptionScreen), findsOneWidget);
      expect(find.text('구독 플랜 선택'), findsOneWidget);
      
      // Backend Developer 관점: 구독 로직 처리
      // Basic 플랜 정보 확인
      expect(find.text('Basic'), findsOneWidget);
      expect(find.text('₩29,900/월'), findsOneWidget);
      expect(find.textContaining('주간 추천 5개'), findsOneWidget);
      
      // Premium 플랜 정보 확인
      expect(find.text('Premium'), findsOneWidget);
      expect(find.text('₩59,900/월'), findsOneWidget);
      expect(find.textContaining('일일 추천'), findsOneWidget);
      
      // 무료 체험 시작
      await tester.tap(find.text('7일 무료 체험 시작'));
      await tester.pumpAndSettle();

      // 8. 메인 화면 (홈)
      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);
      
      // QA Engineer 관점: 핵심 기능 동작 확인
      // 추천 종목 표시 확인
      expect(find.text('오늘의 추천'), findsOneWidget);
      
      // 추천 카드 확인 (최소 1개 이상)
      expect(
        find.byKey(const Key('recommendation_card')),
        findsWidgets,
      );
      
      // 첫 번째 추천 카드 탭
      await tester.tap(find.byKey(const Key('recommendation_card')).first);
      await tester.pumpAndSettle();

      // 9. 전략 상세 화면
      expect(find.byType(StrategyDetailScreen), findsOneWidget);
      
      // 주요 정보 표시 확인
      expect(find.text('매수 추천'), findsOneWidget);
      expect(find.textContaining('진입가'), findsOneWidget);
      expect(find.textContaining('목표가'), findsOneWidget);
      expect(find.textContaining('손절가'), findsOneWidget);
      
      // 차트 탭 확인
      await tester.tap(find.text('차트'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('price_chart')), findsOneWidget);
      
      // 분석 탭으로 돌아가기
      await tester.tap(find.text('분석'));
      await tester.pumpAndSettle();
      
      // 포지션 계산기 사용
      await tester.enterText(
        find.byKey(const Key('investment_amount_field')),
        '1000000',
      );
      await tester.tap(find.text('계산'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('추천 수량'), findsOneWidget);
      
      // 알림 설정
      await tester.tap(find.byKey(const Key('notification_toggle')));
      await tester.pumpAndSettle();
      
      // 뒤로 가기
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // 10. 포지션 탭 이동
      await tester.tap(find.byIcon(Icons.trending_up));
      await tester.pumpAndSettle();
      
      expect(find.byType(PositionScreen), findsOneWidget);
      expect(find.text('보유 포지션'), findsOneWidget);
      
      // 초기에는 포지션 없음
      expect(find.text('보유 중인 포지션이 없습니다'), findsOneWidget);

      // 11. 성과 탭 이동
      await tester.tap(find.byIcon(Icons.bar_chart));
      await tester.pumpAndSettle();
      
      expect(find.byType(InvestmentPerformanceScreen), findsOneWidget);
      expect(find.text('투자 성과'), findsOneWidget);
      
      // 기간 필터 확인
      expect(find.text('1M'), findsOneWidget);
      expect(find.text('3M'), findsOneWidget);
      expect(find.text('1Y'), findsOneWidget);
      expect(find.text('전체'), findsOneWidget);

      // 12. 프로필 탭 이동
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('내 프로필'), findsOneWidget);
      
      // 사용자 정보 확인
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('무료 체험 중'), findsOneWidget);
      
      // 언어 설정 확인
      expect(find.text('언어 설정'), findsOneWidget);
      expect(find.text('한국어'), findsOneWidget);
      
      // 로그아웃 테스트
      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();
      
      // 확인 다이얼로그
      expect(find.text('로그아웃 하시겠습니까?'), findsOneWidget);
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();
      
      // 로그인 화면으로 돌아감
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('기존 사용자 - 매매 신호 확인 및 포지션 관리', (WidgetTester tester) async {
      // 기존 사용자 설정 (이미 로그인된 상태)
      SharedPreferences.setMockInitialValues({
        'isFirstRun': false,
        'selectedLanguage': 'ko',
        'hasCompletedOnboarding': true,
        'isLoggedIn': true,
        'userEmail': 'existing@example.com',
        'subscriptionPlan': 'premium',
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      // 스플래시 후 바로 메인 화면
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      expect(find.byType(MainScreen), findsOneWidget);
      
      // 새로운 추천 알림 시뮬레이션
      // (실제로는 푸시 알림으로 도착)
      
      // 추천 목록에서 급등 예상 종목 찾기
      final urgentRecommendation = find.byWidgetPredicate(
        (widget) => widget is Card && 
                    widget.key == const Key('recommendation_card') &&
                    (widget.child as Container).child is Column,
      );
      
      expect(urgentRecommendation, findsWidgets);
      
      // 첫 번째 추천 탭
      await tester.tap(urgentRecommendation.first);
      await tester.pumpAndSettle();
      
      // 상세 분석 확인
      expect(find.text('긴급 매수 신호'), findsOneWidget);
      expect(find.textContaining('예상 상승률'), findsOneWidget);
      
      // 투자금 입력
      await tester.enterText(
        find.byKey(const Key('investment_amount_field')),
        '5000000',
      );
      await tester.tap(find.text('계산'));
      await tester.pumpAndSettle();
      
      // 매수 실행 시뮬레이션
      await tester.tap(find.text('매수하기'));
      await tester.pumpAndSettle();
      
      // 증권사 연동 팝업 (모의)
      expect(find.text('증권사 앱으로 이동'), findsOneWidget);
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();
      
      // 매수 완료 후 포지션 화면으로 이동
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.trending_up));
      await tester.pumpAndSettle();
      
      // 새로운 포지션 확인
      expect(find.text('보유 포지션'), findsOneWidget);
      expect(find.byKey(const Key('position_item')), findsWidgets);
      
      // 수익률 모니터링
      expect(find.textContaining('+'), findsWidgets); // 수익
      expect(find.textContaining('%'), findsWidgets); // 수익률
    });

    testWidgets('리스크 관리 - 손절가 알림 및 대응', (WidgetTester tester) async {
      // 손실 포지션이 있는 사용자 설정
      SharedPreferences.setMockInitialValues({
        'isFirstRun': false,
        'isLoggedIn': true,
        'hasLossPosition': true,
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      // 포지션 화면으로 바로 이동
      await tester.tap(find.byIcon(Icons.trending_up));
      await tester.pumpAndSettle();
      
      // 손실 포지션 찾기
      final lossPosition = find.byWidgetPredicate(
        (widget) => widget is Container &&
                    widget.decoration is BoxDecoration &&
                    (widget.decoration as BoxDecoration).color == Colors.red.withOpacity(0.1),
      );
      
      expect(lossPosition, findsWidgets);
      
      // 손실 포지션 탭
      await tester.tap(lossPosition.first);
      await tester.pumpAndSettle();
      
      // 손절 권고 메시지
      expect(find.text('손절가 도달'), findsOneWidget);
      expect(find.textContaining('손실을 최소화'), findsOneWidget);
      
      // 손절 실행
      await tester.tap(find.text('손절 실행'));
      await tester.pumpAndSettle();
      
      // 확인 다이얼로그
      expect(find.text('손절을 실행하시겠습니까?'), findsOneWidget);
      expect(find.textContaining('현재 손실'), findsOneWidget);
      
      await tester.tap(find.text('실행'));
      await tester.pumpAndSettle();
      
      // 포지션 종료 확인
      expect(find.text('포지션이 종료되었습니다'), findsOneWidget);
    });

    testWidgets('포트폴리오 성과 분석 - 전략별 비교', (WidgetTester tester) async {
      // 다양한 거래 이력이 있는 사용자
      SharedPreferences.setMockInitialValues({
        'isFirstRun': false,
        'isLoggedIn': true,
        'hasTradeHistory': true,
        'strategies': ['jesse_livermore', 'larry_williams'],
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      // 성과 화면으로 이동
      await tester.tap(find.byIcon(Icons.bar_chart));
      await tester.pumpAndSettle();
      
      // 전체 성과 확인
      expect(find.text('투자 성과'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets); // 차트
      
      // 기간 필터 테스트
      await tester.tap(find.text('1M'));
      await tester.pumpAndSettle();
      expect(find.text('최근 1개월'), findsOneWidget);
      
      await tester.tap(find.text('3M'));
      await tester.pumpAndSettle();
      expect(find.text('최근 3개월'), findsOneWidget);
      
      // 전략별 성과 탭
      await tester.tap(find.text('전략별 성과'));
      await tester.pumpAndSettle();
      
      // 각 전략 성과 표시
      expect(find.text('제시 리버모어'), findsOneWidget);
      expect(find.text('래리 윌리엄스'), findsOneWidget);
      
      // 상세 통계
      await tester.tap(find.text('상세 통계'));
      await tester.pumpAndSettle();
      
      expect(find.text('총 수익률'), findsOneWidget);
      expect(find.text('승률'), findsOneWidget);
      expect(find.text('평균 수익'), findsOneWidget);
      expect(find.text('최대 손실(MDD)'), findsOneWidget);
      expect(find.text('샤프 지수'), findsOneWidget);
    });

    testWidgets('오류 처리 - 네트워크 연결 끊김', (WidgetTester tester) async {
      // 네트워크 오류 시뮬레이션
      SharedPreferences.setMockInitialValues({
        'isFirstRun': false,
        'isLoggedIn': true,
        'networkError': true,
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      // 오프라인 배너 표시
      expect(find.text('인터넷 연결이 끊어졌습니다'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      
      // 새로고침 시도
      await tester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
      );
      await tester.pumpAndSettle();
      
      // 재시도 메시지
      expect(find.text('연결을 재시도하는 중...'), findsOneWidget);
    });

    testWidgets('접근성 테스트 - 시각 장애인 지원', (WidgetTester tester) async {
      // 접근성 모드 활성화
      SharedPreferences.setMockInitialValues({
        'isFirstRun': false,
        'isLoggedIn': true,
        'accessibilityMode': true,
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      // 모든 중요 요소에 Semantics 레이블 확인
      expect(
        find.bySemanticsLabel('홈 탭'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('포지션 탭'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('성과 탭'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('프로필 탭'),
        findsOneWidget,
      );
      
      // 추천 카드의 접근성 정보
      final recommendationSemantics = find.byWidgetPredicate(
        (widget) => widget is Semantics &&
                    widget.properties.label != null &&
                    widget.properties.label!.contains('추천'),
      );
      
      expect(recommendationSemantics, findsWidgets);
    });
  });
}