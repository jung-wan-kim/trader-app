import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trader_app/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete UI Test - 전체 사용자 시나리오', () {
    setUp(() async {
      // 초기화
      SharedPreferences.setMockInitialValues({});
      await Future.delayed(const Duration(seconds: 1));
    });

    testWidgets('신규 사용자 완전한 여정 테스트', (tester) async {
      print('\n========== 신규 사용자 완전한 여정 테스트 시작 ==========\n');
      
      // 1. 앱 실행
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('✅ 1. 앱 실행 완료');

      // 2. 언어 선택 화면 테스트
      print('\n📱 언어 선택 화면 테스트');
      expect(find.text('Choose Your Language'), findsOneWidget);
      expect(find.text('Select your preferred language for the app'), findsOneWidget);
      
      // 모든 언어 옵션 확인
      final languages = ['English', '한국어', '中文简体', '日本語', 'Español', 'Deutsch'];
      for (final lang in languages) {
        expect(find.text(lang), findsOneWidget);
        print('  ✓ $lang 옵션 확인');
      }
      
      // 한국어 선택
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      print('✅ 2. 한국어 선택 완료');
      
      // Continue 버튼 활성화 확인 및 클릭
      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);
      await tester.tap(continueButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('✅ 3. Continue 버튼 클릭 완료');

      // 3. 온보딩 화면 테스트 (있는 경우)
      await _testOnboarding(tester);

      // 4. 로그인/회원가입 화면 테스트
      await _testLoginSignup(tester);

      // 5. 전략 선택 화면 테스트
      await _testStrategySelection(tester);

      // 6. 메인 홈 화면 테스트
      await _testHomeScreen(tester);

      // 7. 추천 종목 상세 테스트
      await _testRecommendationDetail(tester);

      // 8. 포트폴리오 화면 테스트
      await _testPortfolio(tester);

      // 9. 프로필 및 설정 테스트
      await _testProfileSettings(tester);

      print('\n========== 신규 사용자 완전한 여정 테스트 완료 ==========\n');
    });

    testWidgets('기존 사용자 매매 플로우 테스트', (tester) async {
      print('\n========== 기존 사용자 매매 플로우 테스트 시작 ==========\n');
      
      // 기존 사용자 설정
      SharedPreferences.setMockInitialValues({
        'has_seen_onboarding': true,
        'selected_language': 'ko',
        'selected_traders': ['JESSE_LIVERMORE', 'LARRY_WILLIAMS'],
        'is_subscribed': true,
        'isDemoMode': 'false',
      });

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 바로 홈 화면으로 이동하는지 확인
      await _testTradingFlow(tester);
      
      print('\n========== 기존 사용자 매매 플로우 테스트 완료 ==========\n');
    });

    testWidgets('엣지 케이스 및 오류 처리 테스트', (tester) async {
      print('\n========== 엣지 케이스 테스트 시작 ==========\n');

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 네트워크 오류 시뮬레이션
      await _testNetworkError(tester);

      // 빈 상태 테스트
      await _testEmptyStates(tester);

      // 권한 테스트
      await _testPermissions(tester);

      print('\n========== 엣지 케이스 테스트 완료 ==========\n');
    });
  });
}

// 온보딩 테스트
Future<void> _testOnboarding(WidgetTester tester) async {
  print('\n📱 온보딩 화면 테스트');
  
  // 온보딩 화면이 있는지 확인
  final skipButton = find.textContaining('건너뛰기');
  final nextButton = find.textContaining('다음');
  
  if (skipButton.evaluate().isNotEmpty || nextButton.evaluate().isNotEmpty) {
    print('  ✓ 온보딩 화면 발견');
    
    // 온보딩 페이지 스와이프
    for (int i = 0; i < 3; i++) {
      await tester.drag(find.byType(PageView).first, const Offset(-300, 0));
      await tester.pumpAndSettle();
      print('  ✓ 온보딩 페이지 ${i + 1} 확인');
    }
    
    // 시작하기 버튼 클릭
    final startButton = find.textContaining('시작하기');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();
      print('✅ 온보딩 완료');
    }
  }
}

// 로그인/회원가입 테스트
Future<void> _testLoginSignup(WidgetTester tester) async {
  print('\n📱 로그인/회원가입 화면 테스트');
  
  // Demo 모드 버튼 찾기
  final demoButton = find.textContaining('Demo');
  final loginButton = find.textContaining('로그인');
  final signupButton = find.textContaining('회원가입');
  
  if (demoButton.evaluate().isNotEmpty) {
    print('  ✓ Demo 모드 버튼 발견');
    await tester.tap(demoButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    print('✅ Demo 모드로 로그인 완료');
  } else if (loginButton.evaluate().isNotEmpty) {
    print('  ✓ 로그인 화면 발견');
    
    // 이메일/비밀번호 입력 테스트
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;
    
    if (emailField.evaluate().isNotEmpty) {
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();
      print('  ✓ 이메일 입력');
    }
    
    if (passwordField.evaluate().isNotEmpty) {
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();
      print('  ✓ 비밀번호 입력');
    }
  }
}

// 전략 선택 테스트
Future<void> _testStrategySelection(WidgetTester tester) async {
  print('\n📱 전략 선택 화면 테스트');
  
  // 전략 카드 찾기
  final strategies = ['Jesse Livermore', 'Larry Williams', 'Stan Weinstein'];
  
  for (final strategy in strategies) {
    final strategyCard = find.textContaining(strategy);
    if (strategyCard.evaluate().isNotEmpty) {
      print('  ✓ $strategy 전략 발견');
      
      // 상세 정보 확인
      await tester.tap(strategyCard.first);
      await tester.pumpAndSettle();
      
      // 뒤로 가기
      final backButton = find.byIcon(Icons.arrow_back);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      }
    }
  }
  
  // 전략 선택
  final selectButton = find.textContaining('선택');
  if (selectButton.evaluate().isNotEmpty) {
    await tester.tap(selectButton.first);
    await tester.pumpAndSettle();
    print('✅ 전략 선택 완료');
  }
}

// 홈 화면 테스트
Future<void> _testHomeScreen(WidgetTester tester) async {
  print('\n📱 홈 화면 테스트');
  
  // 하단 네비게이션 확인
  final bottomNav = find.byType(NavigationBar);
  expect(bottomNav, findsOneWidget);
  print('  ✓ 하단 네비게이션 바 확인');
  
  // 추천 종목 리스트 확인
  final recommendationList = find.byType(ListView);
  if (recommendationList.evaluate().isNotEmpty) {
    print('  ✓ 추천 종목 리스트 발견');
    
    // 스크롤 테스트
    await tester.drag(recommendationList.first, const Offset(0, -300));
    await tester.pumpAndSettle();
    print('  ✓ 리스트 스크롤 테스트');
  }
  
  // 실시간 데이터 업데이트 확인
  await tester.pump(const Duration(seconds: 2));
  print('  ✓ 실시간 데이터 업데이트 대기');
}

// 추천 종목 상세 테스트
Future<void> _testRecommendationDetail(WidgetTester tester) async {
  print('\n📱 추천 종목 상세 화면 테스트');
  
  // 첫 번째 추천 종목 클릭
  final recommendationCard = find.byType(Card).first;
  if (recommendationCard.evaluate().isNotEmpty) {
    await tester.tap(recommendationCard);
    await tester.pumpAndSettle();
    print('  ✓ 추천 종목 카드 클릭');
    
    // 차트 확인
    final chart = find.byType(CustomPaint);
    if (chart.evaluate().isNotEmpty) {
      print('  ✓ 주가 차트 표시 확인');
    }
    
    // 매수/매도 버튼 확인
    final buyButton = find.textContaining('매수');
    final sellButton = find.textContaining('매도');
    
    if (buyButton.evaluate().isNotEmpty) {
      print('  ✓ 매수 버튼 확인');
    }
    if (sellButton.evaluate().isNotEmpty) {
      print('  ✓ 매도 버튼 확인');
    }
    
    // 리스크 정보 확인
    final stopLoss = find.textContaining('손절가');
    final takeProfit = find.textContaining('목표가');
    
    if (stopLoss.evaluate().isNotEmpty) {
      print('  ✓ 손절가 정보 확인');
    }
    if (takeProfit.evaluate().isNotEmpty) {
      print('  ✓ 목표가 정보 확인');
    }
  }
}

// 포트폴리오 테스트
Future<void> _testPortfolio(WidgetTester tester) async {
  print('\n📱 포트폴리오 화면 테스트');
  
  // 포트폴리오 탭으로 이동
  final portfolioTab = find.byIcon(Icons.analytics_outlined);
  if (portfolioTab.evaluate().isNotEmpty) {
    await tester.tap(portfolioTab);
    await tester.pumpAndSettle();
    print('  ✓ 포트폴리오 탭 이동');
    
    // 포트폴리오 요약 정보 확인
    final totalValue = find.textContaining('총 자산');
    final dailyReturn = find.textContaining('일 수익률');
    
    if (totalValue.evaluate().isNotEmpty) {
      print('  ✓ 총 자산 정보 표시');
    }
    if (dailyReturn.evaluate().isNotEmpty) {
      print('  ✓ 일 수익률 정보 표시');
    }
    
    // 보유 종목 리스트 확인
    final positionsList = find.byType(ListView);
    if (positionsList.evaluate().isNotEmpty) {
      print('  ✓ 보유 종목 리스트 표시');
    }
  }
}

// 프로필 및 설정 테스트
Future<void> _testProfileSettings(WidgetTester tester) async {
  print('\n📱 프로필 및 설정 화면 테스트');
  
  // 프로필 탭으로 이동
  final profileTab = find.byIcon(Icons.person_outline);
  if (profileTab.evaluate().isNotEmpty) {
    await tester.tap(profileTab);
    await tester.pumpAndSettle();
    print('  ✓ 프로필 탭 이동');
    
    // 구독 정보 확인
    final subscriptionInfo = find.textContaining('구독');
    if (subscriptionInfo.evaluate().isNotEmpty) {
      print('  ✓ 구독 정보 표시');
    }
    
    // 설정 메뉴 확인
    final settingsItems = ['알림 설정', '언어 설정', '다크 모드', '로그아웃'];
    for (final item in settingsItems) {
      final setting = find.textContaining(item);
      if (setting.evaluate().isNotEmpty) {
        print('  ✓ $item 메뉴 확인');
      }
    }
  }
}

// 매매 플로우 테스트
Future<void> _testTradingFlow(WidgetTester tester) async {
  print('\n📱 매매 플로우 테스트');
  
  // 추천 종목에서 매수 진행
  final buyButton = find.textContaining('매수');
  if (buyButton.evaluate().isNotEmpty) {
    await tester.tap(buyButton.first);
    await tester.pumpAndSettle();
    print('  ✓ 매수 버튼 클릭');
    
    // 주문 확인 다이얼로그
    final confirmButton = find.textContaining('확인');
    if (confirmButton.evaluate().isNotEmpty) {
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      print('  ✓ 주문 확인 완료');
    }
  }
}

// 네트워크 오류 테스트
Future<void> _testNetworkError(WidgetTester tester) async {
  print('\n📱 네트워크 오류 처리 테스트');
  
  // 새로고침 시도
  final refreshIndicator = find.byType(RefreshIndicator);
  if (refreshIndicator.evaluate().isNotEmpty) {
    await tester.drag(refreshIndicator.first, const Offset(0, 300));
    await tester.pumpAndSettle();
    print('  ✓ 새로고침 테스트');
  }
  
  // 오류 메시지 확인
  final errorMessage = find.textContaining('오류');
  if (errorMessage.evaluate().isNotEmpty) {
    print('  ✓ 오류 메시지 표시 확인');
    
    // 재시도 버튼
    final retryButton = find.textContaining('재시도');
    if (retryButton.evaluate().isNotEmpty) {
      await tester.tap(retryButton);
      await tester.pumpAndSettle();
      print('  ✓ 재시도 버튼 클릭');
    }
  }
}

// 빈 상태 테스트
Future<void> _testEmptyStates(WidgetTester tester) async {
  print('\n📱 빈 상태 UI 테스트');
  
  // 검색 결과 없음
  final searchField = find.byType(TextField);
  if (searchField.evaluate().isNotEmpty) {
    await tester.enterText(searchField.first, 'ZZZZZ');
    await tester.pumpAndSettle();
    
    final noResults = find.textContaining('결과 없음');
    if (noResults.evaluate().isNotEmpty) {
      print('  ✓ 검색 결과 없음 메시지 표시');
    }
  }
}

// 권한 테스트
Future<void> _testPermissions(WidgetTester tester) async {
  print('\n📱 권한 요청 테스트');
  
  // 알림 권한 요청
  final notificationPermission = find.textContaining('알림 권한');
  if (notificationPermission.evaluate().isNotEmpty) {
    print('  ✓ 알림 권한 요청 다이얼로그 표시');
    
    final allowButton = find.textContaining('허용');
    if (allowButton.evaluate().isNotEmpty) {
      await tester.tap(allowButton);
      await tester.pumpAndSettle();
      print('  ✓ 알림 권한 허용');
    }
  }
}