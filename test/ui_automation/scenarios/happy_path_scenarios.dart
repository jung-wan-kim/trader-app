import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../base/base_test.dart';
import '../pages/home_page.dart';
import '../pages/position_page.dart';
import '../pages/performance_page.dart';
import '../helpers/mock_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Happy Path 시나리오 - 일반적인 성공 사용 경로', () {
    late BaseUITest baseTest;
    
    setUp(() {
      baseTest = BaseUITest();
    });
    
    testWidgets('추천 목록 확인 및 필터링', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 1. 추천 목록 로드 확인
      await baseTest.waitForLoadingToComplete();
      home.verifyRecommendationCount(10);
      
      // 2. 검색 기능 테스트
      await home.searchStock('AAPL');
      await tester.pumpAndSettle();
      home.verifyRecommendationVisible('AAPL');
      
      // 검색 초기화
      await home.searchStock('');
      await tester.pumpAndSettle();
      
      // 3. 필터 적용 - 매수 추천만
      await home.openFilters();
      await tester.tap(find.text('매수 추천만'));
      await tester.tap(find.text('적용'));
      await tester.pumpAndSettle();
      
      home.verifyFilterApplied('매수');
      
      // 4. 정렬 변경 - 수익률 높은 순
      await home.openSort();
      await tester.tap(find.text('예상 수익률 높은 순'));
      await tester.pumpAndSettle();
      
      home.verifySortApplied('수익률 높은 순');
      
      // 5. Pull to Refresh
      await home.pullToRefresh();
      home.verifyRecommendationCount(10);
      
      // 6. 무한 스크롤
      await home.scrollToBottom();
      await tester.pumpAndSettle();
      
      // 추가 로드된 항목 확인
      final totalCards = find.byWidgetPredicate(
        (widget) => widget.key?.toString().contains('recommendation_') ?? false,
      );
      expect(totalCards.evaluate().length, greaterThan(10));
      
      await baseTest.teardown();
    });
    
    testWidgets('포지션 생성 및 관리 플로우', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      final position = PositionPage(tester);
      
      // 1. 추천 종목 선택
      await home.selectRecommendation(0);
      await tester.pumpAndSettle();
      
      // 2. 상세 정보 확인
      expect(find.text('AI 분석 리포트'), findsOneWidget);
      expect(find.text('기술적 분석'), findsOneWidget);
      expect(find.text('목표가'), findsOneWidget);
      expect(find.text('손절가'), findsOneWidget);
      
      // 3. 포지션 생성
      await tester.tap(find.text('포지션 생성'));
      await tester.enterText(find.byKey(Key('quantity_input')), '10');
      await tester.tap(find.text('매수'));
      await tester.tap(find.text('확인'));
      await baseTest.waitForLoadingToComplete();
      
      // 성공 메시지 확인
      expect(find.text('포지션이 생성되었습니다'), findsOneWidget);
      
      // 4. 포지션 탭으로 이동
      await home.navigateToTab(2);
      await tester.pumpAndSettle();
      
      // 5. 생성된 포지션 확인
      position.verifyPositionExists('AAPL');
      position.verifyPositionQuantity('AAPL', 10);
      position.verifyPositionStatus('AAPL', '진행중');
      
      // 6. 손절가 수정
      await position.modifyStopLoss('AAPL', '145.00');
      expect(find.text('손절가가 수정되었습니다'), findsOneWidget);
      
      // 7. 실시간 가격 업데이트 확인 (시뮬레이션)
      await tester.pump(Duration(seconds: 3));
      
      // 8. 포지션 상세 보기
      await position.viewPositionDetails('AAPL');
      expect(find.text('거래 내역'), findsOneWidget);
      expect(find.text('가격 차트'), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('투자 성과 분석 플로우', (tester) async {
      await baseTest.setup(tester);
      
      // 과거 거래 데이터가 있는 상태로 시작
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          MockProviders.positionsWithHistory(30), // 30개의 과거 거래
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      final performance = PerformancePage(tester);
      
      // 1. 성과 탭으로 이동
      await home.navigateToTab(3);
      await tester.pumpAndSettle();
      
      // 2. 전체 수익률 확인
      performance.verifyTotalReturn('+24.5%');
      performance.verifyWinRate('68%');
      performance.verifyAverageReturn('+3.2%');
      
      // 3. 기간별 성과 확인
      await performance.selectPeriod('1개월');
      performance.verifyPeriodSelected('1개월');
      performance.verifyChartDisplayed();
      
      await performance.selectPeriod('3개월');
      performance.verifyPeriodSelected('3개월');
      
      // 4. 최고 수익 거래 확인
      performance.verifyBestTrade('TSLA', '+45.2%');
      
      // 5. 월별 분석 보기
      await performance.viewMonthlyBreakdown();
      expect(find.text('2025년 1월'), findsOneWidget);
      expect(find.text('수익률: +8.3%'), findsOneWidget);
      
      // 6. 트레이더별 성과 확인
      await tester.tap(find.byIcon(Icons.arrow_back));
      await performance.viewTraderPerformance();
      expect(find.text('트레이더별 수익률'), findsOneWidget);
      
      // 7. 벤치마크 비교
      await tester.tap(find.byIcon(Icons.arrow_back));
      await performance.compareWithBenchmark();
      expect(find.text('KOSPI 대비 +12.3%'), findsOneWidget);
      
      // 8. 리포트 내보내기
      await performance.exportReport();
      performance.verifyExportSuccess();
      
      await baseTest.teardown();
    });
    
    testWidgets('포지션 종료 및 수익 실현', (tester) async {
      await baseTest.setup(tester);
      
      // 수익이 발생한 포지션이 있는 상태
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          MockProviders.positionsWithProfit(),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      final position = PositionPage(tester);
      
      // 1. 포지션 탭으로 이동
      await home.navigateToTab(2);
      await tester.pumpAndSettle();
      
      // 2. 수익 발생 포지션 확인
      position.verifyPositionProfit('NVDA');
      
      // 3. 포지션 종료
      await position.closePosition('NVDA');
      
      // 4. 종료 확인 다이얼로그
      expect(find.text('포지션을 종료하시겠습니까?'), findsOneWidget);
      expect(find.text('예상 실현 수익: +₩125,000'), findsOneWidget);
      
      await tester.tap(find.text('확인'));
      await baseTest.waitForLoadingToComplete();
      
      // 5. 종료 완료 확인
      expect(find.text('포지션이 종료되었습니다'), findsOneWidget);
      expect(find.text('실현 수익: +₩125,000'), findsOneWidget);
      
      // 6. 종료된 포지션 탭 확인
      await position.switchToClosedPositions();
      position.verifyPositionExists('NVDA');
      position.verifyPositionStatus('NVDA', '수익 실현');
      
      await baseTest.teardown();
    });
  });
}