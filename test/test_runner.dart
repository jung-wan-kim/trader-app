import 'dart:io';

/// Test runner script for Trader App
/// 
/// Usage:
/// dart test/test_runner.dart [options]
/// 
/// Options:
///   --unit        Run unit tests only
///   --widget      Run widget tests only
///   --integration Run integration tests only
///   --security    Run security tests only
///   --performance Run performance tests only
///   --all         Run all tests (default)
///   --coverage    Generate code coverage report
///   --verbose     Show detailed output
///   
void main(List<String> args) async {
  final options = _parseArgs(args);
  final testTypes = _getTestTypes(options);
  final results = <String, TestResult>{};
  
  print('🚀 Starting Trader App Test Suite');
  print('=' * 50);
  
  final stopwatch = Stopwatch()..start();
  
  for (final testType in testTypes) {
    results[testType] = await _runTests(testType, options);
  }
  
  stopwatch.stop();
  
  print('\n' + '=' * 50);
  print('📊 Test Summary');
  print('=' * 50);
  
  _printResults(results);
  
  print('\n⏱️  Total time: ${stopwatch.elapsed.inSeconds}s');
  
  if (options.contains('--coverage')) {
    await _generateCoverageReport();
  }
  
  // Exit with error if any tests failed
  final hasFailures = results.values.any((r) => r.failed > 0);
  exit(hasFailures ? 1 : 0);
}

Map<String, dynamic> _parseArgs(List<String> args) {
  return {
    'unit': args.contains('--unit'),
    'widget': args.contains('--widget'),
    'integration': args.contains('--integration'),
    'security': args.contains('--security'),
    'performance': args.contains('--performance'),
    'all': args.contains('--all') || args.isEmpty,
    'coverage': args.contains('--coverage'),
    'verbose': args.contains('--verbose'),
  };
}

List<String> _getTestTypes(Map<String, dynamic> options) {
  if (options['all']) {
    return ['unit', 'widget', 'integration', 'security', 'performance'];
  }
  
  final types = <String>[];
  if (options['unit']) types.add('unit');
  if (options['widget']) types.add('widget');
  if (options['integration']) types.add('integration');
  if (options['security']) types.add('security');
  if (options['performance']) types.add('performance');
  
  return types.isEmpty ? ['unit', 'widget', 'integration', 'security', 'performance'] : types;
}

Future<TestResult> _runTests(String type, Map<String, dynamic> options) async {
  print('\n🧪 Running $type tests...');
  
  final testDir = _getTestDirectory(type);
  final verbose = options['verbose'] as bool;
  
  final args = [
    'test',
    testDir,
    if (verbose) '--reporter=expanded' else '--reporter=compact',
    '--color',
  ];
  
  if (options['coverage'] && type != 'integration') {
    args.add('--coverage=coverage');
  }
  
  final result = await Process.run('flutter', args);
  
  if (verbose) {
    print(result.stdout);
    if (result.stderr.toString().isNotEmpty) {
      print('Errors: ${result.stderr}');
    }
  }
  
  return _parseTestResults(result.stdout.toString(), type);
}

String _getTestDirectory(String type) {
  switch (type) {
    case 'unit':
      return 'test/unit';
    case 'widget':
      return 'test/widget';
    case 'integration':
      return 'test/integration';
    case 'security':
      return 'test/security';
    case 'performance':
      return 'test/performance';
    default:
      return 'test';
  }
}

TestResult _parseTestResults(String output, String type) {
  // Parse test output to extract passed/failed counts
  final passedMatch = RegExp(r'(\d+) passed').firstMatch(output);
  final failedMatch = RegExp(r'(\d+) failed').firstMatch(output);
  final skippedMatch = RegExp(r'(\d+) skipped').firstMatch(output);
  
  final passed = passedMatch != null ? int.parse(passedMatch.group(1)!) : 0;
  final failed = failedMatch != null ? int.parse(failedMatch.group(1)!) : 0;
  final skipped = skippedMatch != null ? int.parse(skippedMatch.group(1)!) : 0;
  
  // If no test counts found, check for success message
  if (passed == 0 && failed == 0) {
    if (output.contains('All tests passed!')) {
      // Count actual tests from output
      final testCount = RegExp(r'✓').allMatches(output).length;
      return TestResult(type, testCount, 0, 0);
    }
  }
  
  return TestResult(type, passed, failed, skipped);
}

void _printResults(Map<String, TestResult> results) {
  int totalPassed = 0;
  int totalFailed = 0;
  int totalSkipped = 0;
  
  for (final result in results.values) {
    final status = result.failed == 0 ? '✅' : '❌';
    print('$status ${result.type.padRight(15)} Passed: ${result.passed}, Failed: ${result.failed}, Skipped: ${result.skipped}');
    
    totalPassed += result.passed;
    totalFailed += result.failed;
    totalSkipped += result.skipped;
  }
  
  print('\n📈 Total: $totalPassed passed, $totalFailed failed, $totalSkipped skipped');
  
  if (totalFailed == 0) {
    print('\n✨ All tests passed! Great job! 🎉');
  } else {
    print('\n⚠️  Some tests failed. Please check the output above.');
  }
}

Future<void> _generateCoverageReport() async {
  print('\n📊 Generating code coverage report...');
  
  // Generate LCOV report
  final lcovResult = await Process.run('flutter', [
    'test',
    '--coverage',
  ]);
  
  if (lcovResult.exitCode == 0) {
    // Generate HTML report
    final genHtmlResult = await Process.run('genhtml', [
      'coverage/lcov.info',
      '-o',
      'coverage/html',
    ]);
    
    if (genHtmlResult.exitCode == 0) {
      print('✅ Coverage report generated at coverage/html/index.html');
    } else {
      print('⚠️  Failed to generate HTML coverage report. Make sure lcov is installed.');
    }
    
    // Show coverage summary
    final coverageInfo = File('coverage/lcov.info');
    if (coverageInfo.existsSync()) {
      final lines = coverageInfo.readAsLinesSync();
      int totalLines = 0;
      int coveredLines = 0;
      
      for (final line in lines) {
        if (line.startsWith('LF:')) {
          totalLines += int.parse(line.substring(3));
        } else if (line.startsWith('LH:')) {
          coveredLines += int.parse(line.substring(3));
        }
      }
      
      if (totalLines > 0) {
        final coverage = (coveredLines / totalLines * 100).toStringAsFixed(1);
        print('📈 Code coverage: $coverage%');
        
        if (double.parse(coverage) >= 80) {
          print('✅ Coverage meets the target of 80%');
        } else {
          print('⚠️  Coverage is below the target of 80%');
        }
      }
    }
  }
}

class TestResult {
  final String type;
  final int passed;
  final int failed;
  final int skipped;
  
  TestResult(this.type, this.passed, this.failed, this.skipped);
}