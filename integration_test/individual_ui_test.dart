import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trader_app/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('언어 선택 화면 테스트', () {
    setUp(() async {
      // 초기화
      SharedPreferences.setMockInitialValues({});
      await Future.delayed(const Duration(seconds: 1));
    });

    testWidgets('언어 선택 및 Continue 버튼 테스트', (tester) async {
      print('\n========== 언어 선택 화면 테스트 시작 ==========\n');
      
      // 1. 앱 실행
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('✅ 1. 앱 실행 완료');

      // 2. 언어 선택 화면 확인
      expect(find.text('Choose Your Language'), findsOneWidget);
      expect(find.text('Select your preferred language for the app'), findsOneWidget);
      print('✅ 2. 언어 선택 화면 표시 확인');
      
      // 3. 모든 언어 옵션 확인
      final languages = ['English', '한국어', '中文简体', '日本語', 'Español', 'Deutsch'];
      for (final lang in languages) {
        expect(find.text(lang), findsOneWidget);
        print('  ✓ $lang 옵션 확인');
      }
      
      // 4. 한국어 선택
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      print('✅ 3. 한국어 선택 완료');
      
      // 5. Continue 버튼 활성화 확인
      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);
      
      // 버튼이 활성화되었는지 확인
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton).last);
      expect(button.onPressed, isNotNull, reason: 'Continue 버튼이 활성화되어야 합니다');
      print('✅ 4. Continue 버튼 활성화 확인');
      
      // 6. Continue 버튼 클릭
      await tester.tap(continueButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('✅ 5. Continue 버튼 클릭 완료');
      
      // 7. 다음 화면으로 이동했는지 확인
      expect(find.text('Choose Your Language'), findsNothing);
      print('✅ 6. 다음 화면으로 이동 확인');
      
      print('\n========== 언어 선택 화면 테스트 완료 ==========\n');
    });
  });
}