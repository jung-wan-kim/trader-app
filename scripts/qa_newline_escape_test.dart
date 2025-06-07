import 'dart:convert';
import 'dart:io';

void main() {
  print('=== 줄바꿈 이스케이프 QA 테스트 시작 ===\n');
  
  // 테스트할 언어 목록
  final languages = [
    'ko', 'en', 'ja', 'zh', 'es', 'fr', 'de', 'ar', 'hi', 'pt'
  ];

  // 줄바꿈이 포함되어야 하는 주요 텍스트 키들
  final multilineKeys = [
    // 온보딩 화면 설명 텍스트
    'onboardingDesc1',
    'onboardingDesc2', 
    'onboardingDesc3',
    'onboardingDesc4',
    // 구독 약관 텍스트
    'subscriptionTermsText',
    // 이용약관 섹션들
    'termsSection2Content',
    'termsSection3Content',
    'termsSection4Content',
    'termsFinancialDisclaimer',
    'termsSection5Content',
    'termsSection6Content',
    'termsSection7Content',
    'termsSection8Content',
    'termsSection10Content',
    // 개인정보처리방침 섹션들
    'privacySection1Content',
    'privacySection2Content',
    'privacySection3Content',
    'privacySection4Content',
    'privacySection5Content',
    'privacySection6Content',
    'privacySection7Content',
    'privacySection8Content',
  ];

  int totalErrors = 0;
  final Map<String, List<String>> errorsByLanguage = {};

  for (final lang in languages) {
    print('[$lang] 언어 파일 검증 중...');
    errorsByLanguage[lang] = [];
    
    final file = File('lib/l10n/app_$lang.arb');
    if (!file.existsSync()) {
      errorsByLanguage[lang]!.add('파일이 존재하지 않습니다');
      totalErrors++;
      continue;
    }

    try {
      final content = file.readAsStringSync();
      final Map<String, dynamic> jsonData = json.decode(content);
      
      // JSON 파일 전체에서 실제 줄바꿈 문자 검사
      if (content.contains('\n"')) {
        // JSON 값 내부의 실제 줄바꿈은 문제가 됨
        final lines = content.split('\n');
        for (int i = 0; i < lines.length; i++) {
          if (i > 0 && lines[i].trim().startsWith('"') && !lines[i-1].trim().endsWith(',') && !lines[i-1].trim().endsWith('{')) {
            errorsByLanguage[lang]!.add('라인 ${i+1}: JSON 문자열 내에 실제 줄바꿈이 있습니다');
            totalErrors++;
          }
        }
      }

      // 멀티라인 키들 검증
      for (final key in multilineKeys) {
        if (jsonData.containsKey(key)) {
          final value = jsonData[key] as String;
          
          // 온보딩 텍스트 특별 처리
          if (key.startsWith('onboarding')) {
            if (lang == 'ko' || lang == 'ja' || lang == 'zh') {
              // 한중일은 \\\\n 사용
              if (!value.contains('\\\\n')) {
                errorsByLanguage[lang]!.add('$key: 온보딩 텍스트에 \\\\\\\\n 줄바꿈이 없습니다');
                totalErrors++;
              }
            }
            // 다른 언어는 줄바꿈이 선택적
          } else {
            // 약관 등 다른 멀티라인 텍스트
            if (!value.contains('\\n')) {
              errorsByLanguage[lang]!.add('$key: 멀티라인 텍스트에 \\\\n 줄바꿈이 없습니다');
              totalErrors++;
            }
          }
        }
      }

      // 구독 약관 특별 검증
      if (jsonData.containsKey('subscriptionTermsText')) {
        final subscriptionTerms = jsonData['subscriptionTermsText'] as String;
        final lineBreakCount = '\\n'.allMatches(subscriptionTerms).length;
        if (lineBreakCount < 4) {
          errorsByLanguage[lang]!.add('subscriptionTermsText: 줄바꿈이 부족합니다 (현재: $lineBreakCount개, 최소: 4개)');
          totalErrors++;
        }
      }

      if (errorsByLanguage[lang]!.isEmpty) {
        print('  ✓ 모든 검증 통과');
      } else {
        print('  ✗ ${errorsByLanguage[lang]!.length}개 오류 발견');
        for (final error in errorsByLanguage[lang]!) {
          print('    - $error');
        }
      }

    } catch (e) {
      errorsByLanguage[lang]!.add('파일 파싱 오류: $e');
      totalErrors++;
    }
  }

  // 최종 보고서
  print('\n=== QA 테스트 요약 ===');
  print('총 검사 언어: ${languages.length}개');
  print('총 오류 수: $totalErrors개\n');

  if (totalErrors == 0) {
    print('✅ 모든 언어 파일의 줄바꿈 처리가 올바르게 되어 있습니다!');
  } else {
    print('❌ 줄바꿈 처리에 문제가 있는 언어:');
    for (final entry in errorsByLanguage.entries) {
      if (entry.value.isNotEmpty) {
        print('  - ${entry.key}: ${entry.value.length}개 오류');
      }
    }
  }

  // 상세 통계
  print('\n=== 줄바꿈 통계 ===');
  for (final lang in languages) {
    final file = File('lib/l10n/app_$lang.arb');
    if (!file.existsSync()) continue;

    try {
      final content = file.readAsStringSync();
      final Map<String, dynamic> jsonData = json.decode(content);
      
      int totalLineBreaks = 0;
      int keysWithLineBreaks = 0;
      
      for (final key in multilineKeys) {
        if (jsonData.containsKey(key)) {
          final value = jsonData[key] as String;
          final count = '\\n'.allMatches(value).length;
          if (count > 0) {
            keysWithLineBreaks++;
            totalLineBreaks += count;
          }
        }
      }
      
      print('[$lang] 총 줄바꿈: $totalLineBreaks개, 줄바꿈 있는 키: $keysWithLineBreaks/${multilineKeys.length}');
    } catch (e) {
      print('[$lang] 통계 생성 실패: $e');
    }
  }

  // 테스트 결과 반환
  exit(totalErrors > 0 ? 1 : 0);
}