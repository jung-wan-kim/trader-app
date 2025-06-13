import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../base/base_test.dart';
import '../pages/home_page.dart';
import '../pages/position_page.dart';
import '../pages/performance_page.dart';
import '../helpers/mock_providers.dart';
import '../fixtures/test_data_factory.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Edge Case 시나리오 - 극단적 상황 처리', () {
    late BaseUITest baseTest;
    
    setUp(() {
      baseTest = BaseUITest();
    });
    
    testWidgets('빈 데이터 상태 처리', (tester) async {
      await baseTest.setup(tester);
      
      // 빈 데이터 상태로 설정
      baseTest.container = ProviderContainer(
        overrides: MockProviders.getEmptyDataOverrides(),
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      final position = PositionPage(tester);
      final performance = PerformancePage(tester);
      
      // 1. 홈 화면 - 추천 없음
      home.verifyNoRecommendations();
      expect(find.text('현재 추천 종목이 없습니다'), findsOneWidget);
      expect(find.text('잠시 후 다시 확인해주세요'), findsOneWidget);
      
      // Pull to refresh 동작 확인
      await home.pullToRefresh();
      home.verifyNoRecommendations();
      
      // 2. 포지션 탭 - 포지션 없음
      await home.navigateToTab(2);
      await tester.pumpAndSettle();
      
      position.verifyNoOpenPositions();
      await position.switchToClosedPositions();
      position.verifyNoClosedPositions();
      
      // 3. 성과 탭 - 거래 내역 없음
      await home.navigateToTab(3);
      await tester.pumpAndSettle();
      
      performance.verifyNoDataForPeriod();
      performance.verifyTotalReturn('0%');
      performance.verifyWinRate('0%');
      
      await baseTest.teardown();
    });
    
    testWidgets('대량 데이터 처리 및 성능', (tester) async {
      await baseTest.setup(tester);
      
      // 1000개의 추천 데이터
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          recommendationsProvider.overrideWith((ref) async {
            return TestDataFactory.createRecommendationList(count: 1000);
          }),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 초기 로딩 시간 측정
      final startTime = DateTime.now();
      await baseTest.waitForLoadingToComplete();
      final loadTime = DateTime.now().difference(startTime);
      
      // 3초 이내 로딩 완료 확인
      expect(loadTime.inSeconds, lessThan(3));
      
      // 리스트 스크롤 성능 테스트
      final scrollStartTime = DateTime.now();
      
      // 빠른 스크롤 10회
      for (int i = 0; i < 10; i++) {
        await tester.fling(
          home.recommendationList,
          const Offset(0, -500),
          1000,
        );
        await tester.pumpAndSettle();
      }
      
      final scrollTime = DateTime.now().difference(scrollStartTime);
      
      // 스크롤이 부드럽게 동작하는지 확인 (10초 이내)
      expect(scrollTime.inSeconds, lessThan(10));
      
      // 메모리 사용량 체크 (시뮬레이션)
      expect(find.byType(ListView), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('극값 가격 표시 처리', (tester) async {
      await baseTest.setup(tester);
      
      // 극값 데이터 설정
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          recommendationsProvider.overrideWith((ref) async {
            return [
              TestDataFactory.createEdgeCaseRecommendation(EdgeCaseType.veryHighPrice),
              TestDataFactory.createEdgeCaseRecommendation(EdgeCaseType.veryLowPrice),
              TestDataFactory.createRecommendation(currentPrice: 0.001),
              TestDataFactory.createRecommendation(currentPrice: 9999999.99),
            ];
          }),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 매우 높은 가격 표시 확인
      home.verifyPriceDisplay(0, '₩999,999.99');
      
      // 매우 낮은 가격 표시 확인
      home.verifyPriceDisplay(1, '₩0.01');
      
      // 소수점 많은 가격
      home.verifyPriceDisplay(2, '₩0.001');
      
      // 최대값 가격
      home.verifyPriceDisplay(3, '₩9,999,999.99');
      
      // 포지션 생성 시 극값 처리
      await home.selectRecommendation(0);
      await tester.tap(find.text('포지션 생성'));
      
      // 최대 수량 입력
      await tester.enterText(find.byKey(Key('quantity_input')), '999999');
      
      // 총 금액 계산 확인
      expect(find.textContaining('총 금액: '), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('긴 텍스트 및 특수문자 처리', (tester) async {
      await baseTest.setup(tester);
      
      // 긴 텍스트 데이터
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          recommendationsProvider.overrideWith((ref) async {
            return [
              TestDataFactory.createEdgeCaseRecommendation(EdgeCaseType.longSymbol),
              TestDataFactory.createEdgeCaseRecommendation(EdgeCaseType.longCompanyName),
              TestDataFactory.createRecommendation(
                symbol: 'A&B.C-D',
                companyName: '특수문자 @#\$% 회사명',
              ),
            ];
          }),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 긴 심볼 표시 확인 (잘림 처리)
      final longSymbolCard = home.recommendationCard(0);
      final symbolText = tester.widget<Text>(
        find.descendant(
          of: longSymbolCard,
          matching: find.byType(Text).first,
        ),
      );
      expect(symbolText.overflow, TextOverflow.ellipsis);
      
      // 긴 회사명 표시 확인
      final longNameCard = home.recommendationCard(1);
      final nameText = tester.widget<Text>(
        find.descendant(
          of: longNameCard,
          matching: find.byType(Text).at(1),
        ),
      );
      expect(nameText.overflow, TextOverflow.ellipsis);
      
      // 특수문자 정상 표시 확인
      expect(find.text('A&B.C-D'), findsOneWidget);
      expect(find.textContaining('@#\$%'), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('동시 다중 작업 처리', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 동시에 여러 작업 수행
      final futures = <Future>[];
      
      // 1. 추천 목록 새로고침
      futures.add(() async {
        await home.pullToRefresh();
      }());
      
      // 2. 검색
      futures.add(() async {
        await home.searchStock('AAPL');
      }());
      
      // 3. 필터 적용
      futures.add(() async {
        await home.openFilters();
        await tester.tap(find.text('매수 추천만'));
      }());
      
      // 모든 작업 완료 대기
      await Future.wait(futures);
      await tester.pumpAndSettle();
      
      // 앱이 정상 동작하는지 확인
      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.takeException(), isNull);
      
      await baseTest.teardown();
    });
    
    testWidgets('날짜/시간 경계값 처리', (tester) async {
      await baseTest.setup(tester);
      
      // 다양한 날짜 시나리오
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          recommendationsProvider.overrideWith((ref) async {
            return [
              // 1초 전 생성
              TestDataFactory.createRecommendation(
                createdAt: DateTime.now().subtract(Duration(seconds: 1)),
              ),
              // 1년 전 생성
              TestDataFactory.createRecommendation(
                createdAt: DateTime.now().subtract(Duration(days: 365)),
              ),
              // 미래 날짜 (오류 케이스)
              TestDataFactory.createRecommendation(
                createdAt: DateTime.now().add(Duration(days: 1)),
              ),
            ];
          }),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      // 시간 표시 확인
      expect(find.text('1초 전'), findsOneWidget);
      expect(find.text('1년 전'), findsOneWidget);
      
      // 미래 날짜는 현재로 표시
      expect(find.textContaining('방금'), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('소수점 및 반올림 처리', (tester) async {
      await baseTest.setup(tester);
      
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          recommendationsProvider.overrideWith((ref) async {
            return [
              TestDataFactory.createRecommendation(
                currentPrice: 123.456789,
                targetPrice: 145.999999,
              ),
              TestDataFactory.createRecommendation(
                currentPrice: 0.123456,
                targetPrice: 0.234567,
              ),
            ];
          }),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      // 소수점 2자리로 반올림 표시 확인
      expect(find.text('₩123.46'), findsOneWidget);
      expect(find.text('₩146.00'), findsOneWidget);
      
      // 1원 미만 가격 표시
      expect(find.text('₩0.12'), findsOneWidget);
      expect(find.text('₩0.23'), findsOneWidget);
      
      await baseTest.teardown();
    });
  });
}