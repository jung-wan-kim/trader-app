import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Localization Newline Escape QA Tests', () {
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

    for (final lang in languages) {
      test('$lang 언어 파일의 줄바꿈 이스케이프 검증', () {
        final file = File('lib/l10n/app_$lang.arb');
        expect(file.existsSync(), isTrue, 
            reason: '$lang 언어 파일이 존재해야 합니다');

        final content = file.readAsStringSync();
        final Map<String, dynamic> jsonData = json.decode(content);

        // 멀티라인 키들 검증
        for (final key in multilineKeys) {
          if (jsonData.containsKey(key)) {
            final value = jsonData[key] as String;
            
            // 실제 줄바꿈 문자(\n)가 없어야 함
            expect(value.contains('\n'), isFalse,
                reason: '$lang - $key: 실제 줄바꿈 문자(\\n)가 포함되어 있습니다. \\\\n으로 이스케이프되어야 합니다');
            
            // 이스케이프된 줄바꿈(\\n)이 있어야 함 (온보딩 텍스트는 선택적)
            if (key.startsWith('onboarding') && lang != 'ko' && lang != 'ja' && lang != 'zh') {
              // 영어 및 기타 언어는 온보딩에서 줄바꿈이 선택적
            } else if (key.startsWith('onboarding')) {
              // 한국어, 일본어, 중국어는 온보딩에서 \\\\n 사용
              expect(value.contains('\\\\n'), isTrue,
                  reason: '$lang - $key: 멀티라인 텍스트에 이스케이프된 줄바꿈(\\\\\\\\n)이 포함되어야 합니다');
            } else if (!key.startsWith('onboarding')) {
              // 약관 등 다른 멀티라인 텍스트는 모든 언어에서 필수
              expect(value.contains('\\n') || value.contains('\\\\n'), isTrue,
                  reason: '$lang - $key: 멀티라인 텍스트에 이스케이프된 줄바꿈(\\\\n)이 포함되어야 합니다');
            }
          }
        }

        // JSON 파싱이 성공적으로 되는지 확인 (문법 오류 검증)
        expect(() => json.decode(content), returnsNormally,
            reason: '$lang 언어 파일의 JSON 구조가 유효해야 합니다');
      });

      test('$lang 언어 파일의 특수 케이스 검증', () {
        final file = File('lib/l10n/app_$lang.arb');
        final content = file.readAsStringSync();
        final Map<String, dynamic> jsonData = json.decode(content);

        // 구독 약관 텍스트는 반드시 여러 줄이어야 함
        if (jsonData.containsKey('subscriptionTermsText')) {
          final subscriptionTerms = jsonData['subscriptionTermsText'] as String;
          final lineBreakCount = '\\n'.allMatches(subscriptionTerms).length;
          expect(lineBreakCount >= 4, isTrue,
              reason: '$lang - subscriptionTermsText: 최소 4개 이상의 줄바꿈이 있어야 합니다 (현재: $lineBreakCount개)');
        }

        // 약관 섹션 내용들은 적절한 줄바꿈을 포함해야 함
        final termsKeys = jsonData.keys.where((k) => k.startsWith('termsSection') && k.endsWith('Content'));
        for (final key in termsKeys) {
          final value = jsonData[key] as String;
          if (value.length > 200) { // 긴 텍스트는 줄바꿈이 있어야 함
            expect(value.contains('\\n'), isTrue,
                reason: '$lang - $key: 긴 텍스트에는 줄바꿈이 포함되어야 합니다');
          }
        }
      });

      test('$lang 언어 파일의 줄바꿈 일관성 검증', () {
        final file = File('lib/l10n/app_$lang.arb');
        final content = file.readAsStringSync();
        
        // 파일 전체에서 잘못된 줄바꿈 패턴 검색
        final lines = content.split('\n');
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];
          
          // JSON 문자열 값 내에서만 검사 (키-값 쌍에서 값 부분)
          if (line.contains('": "') && line.contains('",')) {
            // 단일 백슬래시 + n 패턴 검출 (올바른 이스케이프는 \\n)
            final valueMatch = RegExp(r'": "(.*)",?$').firstMatch(line);
            if (valueMatch != null) {
              final value = valueMatch.group(1)!;
              
              // 홀수 개의 백슬래시 뒤에 n이 오는 경우 검출
              final invalidEscapePattern = RegExp(r'(?<!\\)(\\\\)*\\n(?!\\)');
              expect(invalidEscapePattern.hasMatch(value), isFalse,
                  reason: '$lang - 라인 ${i+1}: 잘못된 줄바꿈 이스케이프가 발견되었습니다');
            }
          }
        }
      });
    }

    test('모든 언어 파일의 줄바꿈 처리 비교', () {
      final Map<String, Map<String, int>> lineBreakStats = {};
      
      for (final lang in languages) {
        final file = File('lib/l10n/app_$lang.arb');
        final content = file.readAsStringSync();
        final Map<String, dynamic> jsonData = json.decode(content);
        
        lineBreakStats[lang] = {};
        
        for (final key in multilineKeys) {
          if (jsonData.containsKey(key)) {
            final value = jsonData[key] as String;
            final count = '\\n'.allMatches(value).length;
            lineBreakStats[lang]![key] = count;
          }
        }
      }

      // 주요 키들의 줄바꿈 개수가 언어 간에 크게 차이나지 않아야 함
      for (final key in multilineKeys) {
        final counts = languages
            .where((lang) => lineBreakStats[lang]!.containsKey(key))
            .map((lang) => lineBreakStats[lang]![key]!)
            .toList();
        
        if (counts.isNotEmpty && !key.startsWith('onboarding')) {
          final maxCount = counts.reduce((a, b) => a > b ? a : b);
          final minCount = counts.reduce((a, b) => a < b ? a : b);
          
          // 약관 텍스트는 언어 간 줄바꿈 수가 비슷해야 함 (±3 정도 차이 허용)
          if (key.contains('terms') || key.contains('privacy')) {
            expect(maxCount - minCount <= 3, isTrue,
                reason: '$key: 언어 간 줄바꿈 개수 차이가 너무 큽니다 (최소: $minCount, 최대: $maxCount)');
          }
        }
      }
    });

    test('QA 최종 보고서 생성', () {
      final report = StringBuffer();
      report.writeln('=== 줄바꿈 이스케이프 QA 테스트 보고서 ===\n');
      
      for (final lang in languages) {
        final file = File('lib/l10n/app_$lang.arb');
        final content = file.readAsStringSync();
        final Map<String, dynamic> jsonData = json.decode(content);
        
        report.writeln('[$lang 언어]');
        
        int totalLineBreaks = 0;
        int keysWithLineBreaks = 0;
        
        for (final key in multilineKeys) {
          if (jsonData.containsKey(key)) {
            final value = jsonData[key] as String;
            final count = '\\n'.allMatches(value).length;
            if (count > 0) {
              keysWithLineBreaks++;
              totalLineBreaks += count;
              report.writeln('  - $key: $count개의 줄바꿈');
            }
          }
        }
        
        report.writeln('  총 줄바꿈 수: $totalLineBreaks');
        report.writeln('  줄바꿈이 있는 키: $keysWithLineBreaks/${multilineKeys.length}\n');
      }
      
      // 보고서를 파일로 저장
      File('test_results/newline_escape_qa_report.txt').writeAsStringSync(report.toString());
      
      // 테스트는 항상 통과
      expect(true, isTrue);
    });
  });
}