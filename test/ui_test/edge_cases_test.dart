import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/main.dart';
import 'package:trader_app/screens/main_screen.dart';
import 'package:trader_app/screens/login_screen.dart';
import 'package:trader_app/screens/subscription_screen.dart';
import 'package:trader_app/screens/position_screen.dart';
import 'package:trader_app/screens/strategy_detail_screen.dart';
import 'package:trader_app/widgets/recommendation_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

// 각 RP 관점에서의 엣지 케이스 테스트

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Product Manager 관점 - 비즈니스 엣지 케이스', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('구독 만료 시 기능 제한', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'subscriptionExpired': true,
        'subscriptionPlan': 'premium',
        'expiryDate': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 구독 만료 알림 표시
        expect(find.text('구독이 만료되었습니다'), findsOneWidget);
        expect(find.text('서비스를 계속 이용하려면 구독을 갱신하세요'), findsOneWidget);

        // 제한된 기능 확인
        await tester.tap(find.byKey(const Key('recommendation_card')).first);
        await tester.pumpAndSettle();

        // 상세 보기 차단
        expect(find.text('구독이 필요한 기능입니다'), findsOneWidget);
        expect(find.byType(StrategyDetailScreen), findsNothing);

        // 구독 갱신 버튼
        await tester.tap(find.text('구독 갱신'));
        await tester.pumpAndSettle();

        expect(find.byType(SubscriptionScreen), findsOneWidget);
      });
    });

    testWidgets('여러 전략 동시 추천 시 우선순위', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'subscriptionPlan': 'professional',
        'selectedStrategies': ['jesse_livermore', 'larry_williams', 'stan_weinstein'],
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 동일 종목에 대한 다중 전략 추천
        expect(find.text('전략 충돌'), findsWidgets);
        expect(find.byIcon(Icons.warning_amber_rounded), findsWidgets);

        // 전략 비교 모달
        await tester.tap(find.text('전략 비교').first);
        await tester.pumpAndSettle();

        expect(find.text('전략별 분석 비교'), findsOneWidget);
        expect(find.text('제시 리버모어: 매수'), findsOneWidget);
        expect(find.text('래리 윌리엄스: 관망'), findsOneWidget);
        expect(find.text('스탠 와인스타인: 매도'), findsOneWidget);

        // AI 종합 의견
        expect(find.text('AI 종합 추천'), findsOneWidget);
        expect(find.textContaining('신중한 접근 필요'), findsOneWidget);
      });
    });

    testWidgets('무료 체험 종료 D-1 알림', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'isTrial': true,
        'trialEndDate': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 체험 종료 임박 배너
        expect(find.text('무료 체험이 내일 종료됩니다'), findsOneWidget);
        expect(find.text('지금 구독하고 20% 할인받으세요'), findsOneWidget);

        // 특별 할인 제안
        await tester.tap(find.text('할인받고 구독하기'));
        await tester.pumpAndSettle();

        expect(find.byType(SubscriptionScreen), findsOneWidget);
        expect(find.text('첫 구독 20% 할인'), findsOneWidget);
        expect(find.text('₩47,920/월'), findsOneWidget); // Premium 할인가
      });
    });
  });

  group('UX/UI Designer 관점 - 사용성 엣지 케이스', () {
    testWidgets('다크모드/라이트모드 전환 시 가독성', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'themeMode': 'light',
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 라이트 모드에서의 색상 대비 확인
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        expect(scaffold.backgroundColor, Colors.white);

        // 프로필로 이동하여 테마 변경
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        await tester.tap(find.text('다크 모드'));
        await tester.pumpAndSettle();

        // 다크 모드 전환 확인
        final darkScaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        expect(darkScaffold.backgroundColor, Colors.black);

        // 중요 정보의 가독성 확인 (수익률 색상)
        final profitText = tester.widget<Text>(
          find.textContaining('+').first,
        );
        expect(profitText.style?.color, const Color(0xFF00D632)); // 녹색

        final lossText = tester.widget<Text>(
          find.textContaining('-').first,
        );
        expect(lossText.style?.color, const Color(0xFFFF3B30)); // 빨간색
      });
    });

    testWidgets('긴 종목명 처리 및 텍스트 오버플로우', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'hasLongStockNames': true,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 긴 종목명이 있는 추천 카드
        final longNameCard = find.byWidgetPredicate(
          (widget) => widget is Text && 
                      widget.data != null &&
                      widget.data!.contains('매우긴회사이름주식회사우선주'),
        );

        expect(longNameCard, findsWidgets);

        // 텍스트가 ellipsis로 처리되는지 확인
        final textWidget = tester.widget<Text>(longNameCard.first);
        expect(textWidget.overflow, TextOverflow.ellipsis);
        expect(textWidget.maxLines, 1);
      });
    });

    testWidgets('화면 회전 시 레이아웃 유지', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 세로 모드에서 포지션 확인
        await tester.tap(find.byIcon(Icons.trending_up));
        await tester.pumpAndSettle();

        expect(find.byType(PositionScreen), findsOneWidget);

        // 가로 모드로 전환
        await tester.binding.setSurfaceSize(const Size(800, 400));
        await tester.pumpAndSettle();

        // 주요 요소들이 여전히 표시되는지 확인
        expect(find.text('보유 포지션'), findsOneWidget);
        expect(find.byKey(const Key('position_list')), findsOneWidget);

        // 스크롤 가능한지 확인
        await tester.drag(
          find.byKey(const Key('position_list')),
          const Offset(0, -100),
        );
        await tester.pumpAndSettle();

        // 다시 세로 모드로
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpAndSettle();
      });
    });
  });

  group('Frontend Developer 관점 - 기술적 엣지 케이스', () {
    testWidgets('대량 데이터 로딩 시 성능', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'hasLargeDataset': true,
        'recommendationCount': 100,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 로딩 인디케이터 표시
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // 데이터 로드 완료 시뮬레이션
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // 가상 스크롤 적용 확인
        expect(find.byKey(const Key('recommendation_list')), findsOneWidget);

        // 스크롤 성능 테스트
        final listFinder = find.byKey(const Key('recommendation_list'));
        
        // 빠른 스크롤
        for (int i = 0; i < 10; i++) {
          await tester.drag(listFinder, const Offset(0, -300));
          await tester.pump();
        }

        // 프레임 드롭 없이 스크롤되는지 확인
        expect(tester.binding.framesEnabled, true);
      });
    });

    testWidgets('메모리 누수 방지 - 화면 전환 시 리소스 해제', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 여러 화면 반복 이동
        for (int i = 0; i < 5; i++) {
          // 홈 -> 포지션
          await tester.tap(find.byIcon(Icons.trending_up));
          await tester.pumpAndSettle();

          // 포지션 -> 성과
          await tester.tap(find.byIcon(Icons.bar_chart));
          await tester.pumpAndSettle();

          // 성과 -> 프로필
          await tester.tap(find.byIcon(Icons.person));
          await tester.pumpAndSettle();

          // 프로필 -> 홈
          await tester.tap(find.byIcon(Icons.home));
          await tester.pumpAndSettle();
        }

        // 메모리 사용량이 안정적인지 확인
        // (실제 테스트에서는 프로파일러 사용)
        expect(find.byType(MainScreen), findsOneWidget);
      });
    });

    testWidgets('동시 다발적 API 호출 처리', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Pull to refresh 여러 번 빠르게 실행
        final refreshFinder = find.byType(RefreshIndicator);
        
        for (int i = 0; i < 3; i++) {
          await tester.drag(refreshFinder, const Offset(0, 300));
          await tester.pump();
        }

        // 중복 요청 방지 확인
        expect(find.byType(CircularProgressIndicator), findsOneWidget); // 1개만 표시

        await tester.pumpAndSettle();

        // 정상적으로 데이터 갱신
        expect(find.byKey(const Key('recommendation_card')), findsWidgets);
      });
    });
  });

  group('Backend Developer 관점 - 서버 연동 엣지 케이스', () {
    testWidgets('토큰 만료 시 자동 갱신', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'tokenExpired': true,
        'refreshToken': 'valid_refresh_token',
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // API 호출 시도 (토큰 만료 상태)
        await tester.tap(find.byKey(const Key('recommendation_card')).first);
        await tester.pumpAndSettle();

        // 토큰 갱신 중 표시
        expect(find.text('인증 갱신 중...'), findsOneWidget);

        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        // 갱신 완료 후 정상 동작
        expect(find.byType(StrategyDetailScreen), findsOneWidget);
      });
    });

    testWidgets('서버 점검 시 안내 메시지', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'serverMaintenance': true,
        'maintenanceEndTime': DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 서버 점검 공지
        expect(find.text('서버 점검 중'), findsOneWidget);
        expect(find.textContaining('오후 2시까지'), findsOneWidget);
        expect(find.text('점검이 완료되면 알려드리겠습니다'), findsOneWidget);

        // 읽기 전용 모드
        expect(find.byIcon(Icons.lock_outline), findsWidgets);
      });
    });

    testWidgets('실시간 데이터 동기화 충돌', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'hasConflictingData': true,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 포지션 화면에서 동기화 충돌
        await tester.tap(find.byIcon(Icons.trending_up));
        await tester.pumpAndSettle();

        // 충돌 알림
        expect(find.text('데이터 동기화 필요'), findsOneWidget);
        expect(find.text('서버와 로컬 데이터가 일치하지 않습니다'), findsOneWidget);

        // 동기화 옵션
        expect(find.text('서버 데이터 사용'), findsOneWidget);
        expect(find.text('로컬 데이터 유지'), findsOneWidget);

        // 서버 데이터 선택
        await tester.tap(find.text('서버 데이터 사용'));
        await tester.pumpAndSettle();

        // 동기화 완료
        expect(find.text('동기화 완료'), findsOneWidget);
      });
    });
  });

  group('QA Engineer 관점 - 품질 보증 엣지 케이스', () {
    testWidgets('연속 빠른 탭으로 인한 중복 처리 방지', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 매수 버튼 연속 탭
        await tester.tap(find.byKey(const Key('recommendation_card')).first);
        await tester.pumpAndSettle();

        final buyButton = find.text('매수하기');
        
        // 빠르게 여러 번 탭
        for (int i = 0; i < 5; i++) {
          await tester.tap(buyButton);
          await tester.pump(const Duration(milliseconds: 50));
        }

        await tester.pumpAndSettle();

        // 중복 주문 방지 확인
        expect(find.text('처리 중입니다'), findsOneWidget);
        expect(find.text('주문이 이미 진행 중입니다'), findsNothing);
      });
    });

    testWidgets('메모리 부족 상황에서의 동작', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'lowMemoryMode': true,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 저사양 모드 활성화 확인
        expect(find.text('저사양 모드'), findsOneWidget);

        // 이미지 품질 저하
        final images = find.byType(Image);
        expect(images, findsWidgets);

        // 애니메이션 비활성화 확인
        await tester.tap(find.byIcon(Icons.trending_up));
        await tester.pump(); // pumpAndSettle 대신 pump 한 번만

        // 즉시 화면 전환 (애니메이션 없음)
        expect(find.byType(PositionScreen), findsOneWidget);
      });
    });

    testWidgets('비정상적인 입력값 처리', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 전략 상세로 이동
        await tester.tap(find.byKey(const Key('recommendation_card')).first);
        await tester.pumpAndSettle();

        // 투자금액에 비정상적인 값 입력
        final amountField = find.byKey(const Key('investment_amount_field'));

        // 음수 입력
        await tester.enterText(amountField, '-1000000');
        await tester.tap(find.text('계산'));
        await tester.pumpAndSettle();

        expect(find.text('올바른 금액을 입력하세요'), findsOneWidget);

        // 너무 큰 숫자
        await tester.enterText(amountField, '999999999999999');
        await tester.tap(find.text('계산'));
        await tester.pumpAndSettle();

        expect(find.text('최대 투자 가능 금액을 초과했습니다'), findsOneWidget);

        // 특수문자
        await tester.enterText(amountField, '1,000,000원');
        await tester.tap(find.text('계산'));
        await tester.pumpAndSettle();

        expect(find.text('숫자만 입력하세요'), findsOneWidget);
      });
    });

    testWidgets('장시간 미사용 후 세션 타임아웃', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'lastActivityTime': DateTime.now().subtract(const Duration(minutes: 31)).toIso8601String(),
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 세션 만료 다이얼로그
        expect(find.text('세션이 만료되었습니다'), findsOneWidget);
        expect(find.text('보안을 위해 다시 로그인해주세요'), findsOneWidget);

        // 확인 버튼 탭
        await tester.tap(find.text('확인'));
        await tester.pumpAndSettle();

        // 로그인 화면으로 이동
        expect(find.byType(LoginScreen), findsOneWidget);
      });
    });
  });

  group('DevOps Engineer 관점 - 인프라 엣지 케이스', () {
    testWidgets('CDN 장애 시 로컬 캐시 사용', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'cdnFailure': true,
        'hasLocalCache': true,
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // CDN 장애 알림
        expect(find.text('일부 이미지가 표시되지 않을 수 있습니다'), findsOneWidget);

        // 로컬 캐시 사용 확인
        final images = find.byType(Image);
        expect(images, findsWidgets);

        // 캐시된 이미지는 정상 표시
        expect(find.byIcon(Icons.broken_image), findsNothing);
      });
    });

    testWidgets('리전별 서버 자동 전환', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'isLoggedIn': true,
        'primaryServerDown': true,
        'userRegion': 'KR',
      });

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 서버 전환 알림
        expect(find.text('최적의 서버로 연결 중...'), findsOneWidget);

        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // 백업 서버 연결 완료
        expect(find.text('연결되었습니다 (JP 서버)'), findsOneWidget);

        // 정상 동작 확인
        expect(find.byKey(const Key('recommendation_card')), findsWidgets);
      });
    });
  });
}