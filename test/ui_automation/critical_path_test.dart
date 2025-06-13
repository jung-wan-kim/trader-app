import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'scenarios/critical_path_scenarios.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Critical Path Tests - 핵심 사용자 경로', () {
    final scenarios = CriticalPathScenarios();
    
    testWidgets('신규 사용자 완전 여정 - 온보딩부터 첫 구독까지', (tester) async {
      scenarios.tester = tester;
      await scenarios.newUserCompleteJourney();
    });
    
    testWidgets('기존 사용자 로그인 및 거래 플로우', (tester) async {
      scenarios.tester = tester;
      await scenarios.existingUserLoginAndTrade();
    });
    
    testWidgets('구독 갱신 플로우', (tester) async {
      scenarios.tester = tester;
      await scenarios.subscriptionRenewalFlow();
    });
    
    testWidgets('포지션 관리 전체 플로우', (tester) async {
      scenarios.tester = tester;
      await scenarios.positionManagementFlow();
    });
  });
}