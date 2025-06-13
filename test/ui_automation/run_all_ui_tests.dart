import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// 모든 UI 테스트 시나리오 import
import 'scenarios/new_user_journey_test.dart' as new_user;
import 'scenarios/critical_path_scenarios.dart' as critical;
import 'scenarios/happy_path_scenarios.dart' as happy;
import 'scenarios/edge_case_scenarios.dart' as edge;
import 'scenarios/negative_test_scenarios.dart' as negative;
import 'scenarios/accessibility_test_scenarios.dart' as accessibility;
import 'scenarios/responsive_design_test.dart' as responsive;
import 'scenarios/performance_test.dart' as performance;
import 'scenarios/platform_specific_test.dart' as platform;
import 'scenarios/visual_regression_test.dart' as visual;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('🎯 Trader App - 전체 UI 테스트 스위트', () {
    group('1️⃣ Critical Path Tests (필수 경로)', () {
      new_user.main();
      critical.main();
    });
    
    group('2️⃣ Happy Path Tests (정상 시나리오)', () {
      happy.main();
    });
    
    group('3️⃣ Edge Case Tests (경계값)', () {
      edge.main();
    });
    
    group('4️⃣ Negative Tests (오류 처리)', () {
      negative.main();
    });
    
    group('5️⃣ Accessibility Tests (접근성)', () {
      accessibility.main();
    });
    
    group('6️⃣ Responsive Design Tests (반응형)', () {
      responsive.main();
    });
    
    group('7️⃣ Performance Tests (성능)', () {
      performance.main();
    });
    
    group('8️⃣ Platform Specific Tests (플랫폼별)', () {
      platform.main();
    });
    
    group('9️⃣ Visual Regression Tests (시각적 회귀)', () {
      visual.main();
    });
  });
}