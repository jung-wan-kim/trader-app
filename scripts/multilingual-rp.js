#!/usr/bin/env node

/**
 * 다국어 RP (Review Process) 스크립트
 * 
 * 이 스크립트는 모든 Dart 파일을 검사하여:
 * 1. 하드코딩된 문자열 찾기
 * 2. 다국어 지원이 필요한 텍스트 식별
 * 3. AppLocalizations 사용 여부 확인
 * 4. 누락된 번역 키 확인
 */

const fs = require('fs');
const path = require('path');

class MultilingualRP {
  constructor() {
    this.hardcodedStrings = [];
    this.missingLocalizations = [];
    this.nonLocalizedWidgets = [];
    this.warnings = [];
    this.errors = [];
    this.checkedFiles = 0;
    this.totalIssues = 0;
    
    // 검사 대상 경로
    this.sourcePaths = [
      'lib/screens',
      'lib/widgets',
      'lib/providers'
    ];
    
    // 무시할 패턴들
    this.ignorePatterns = [
      /^[A-Z_]+$/, // 상수 (예: API_KEY)
      /^\d+(\.\d+)?$/, // 숫자
      /^[a-z]+[A-Z]/, // camelCase 변수명
      /^[\w\-\.]+\.(png|jpg|jpeg|svg|dart|json)$/, // 파일명
      /^(http|https):\/\//, // URL
      /^[\w\-\.]+@[\w\-\.]+\.\w+$/, // 이메일
      /^\+?\d+[\d\s\-\(\)]*$/, // 전화번호
      /^v?\d+\.\d+\.\d+/, // 버전
      /^[A-Z]{2,5}$/, // 주식 심볼 (AAPL, GOOGL 등)
      /^\$\d+/, // 가격 형식 ($100.00)
      /^[\+\-]?\d+(\.\d+)?%?$/, // 퍼센트나 숫자
    ];
    
    // 다국어가 필요한 위젯들
    this.localizableWidgets = [
      'Text',
      'TextField',
      'TextFormField',
      'AlertDialog',
      'SnackBar',
      'AppBar',
      'FloatingActionButton',
      'ElevatedButton',
      'TextButton',
      'OutlinedButton',
      'ListTile',
      'Card',
      'Chip',
      'Tooltip',
      'Banner'
    ];
  }

  async run() {
    console.log('🔍 다국어 RP (Review Process) 시작...\n');
    
    try {
      for (const sourcePath of this.sourcePaths) {
        await this.checkDirectory(sourcePath);
      }
      
      this.generateReport();
    } catch (error) {
      console.error('❌ RP 실행 중 오류:', error.message);
    }
  }

  async checkDirectory(dirPath) {
    if (!fs.existsSync(dirPath)) {
      this.warnings.push(`경로가 존재하지 않음: ${dirPath}`);
      return;
    }

    const files = fs.readdirSync(dirPath);
    
    for (const file of files) {
      const filePath = path.join(dirPath, file);
      const stat = fs.statSync(filePath);
      
      if (stat.isDirectory()) {
        await this.checkDirectory(filePath);
      } else if (file.endsWith('.dart')) {
        await this.checkDartFile(filePath);
      }
    }
  }

  async checkDartFile(filePath) {
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      this.checkedFiles++;
      
      console.log(`📋 검사 중: ${filePath}`);
      
      // 1. AppLocalizations import 여부 확인
      const hasLocalizationImport = content.includes("import '../generated/l10n/app_localizations.dart'") ||
                                   content.includes('AppLocalizations');
      
      // 2. 하드코딩된 문자열 찾기
      this.findHardcodedStrings(content, filePath);
      
      // 3. 다국어가 필요한 위젯 확인
      this.checkLocalizableWidgets(content, filePath, hasLocalizationImport);
      
      // 4. 사용되는 번역 키 확인
      this.checkTranslationKeys(content, filePath);
      
    } catch (error) {
      this.errors.push(`파일 읽기 오류 (${filePath}): ${error.message}`);
    }
  }

  findHardcodedStrings(content, filePath) {
    // 문자열 리터럴 패턴 (작은따옴표, 큰따옴표)
    const stringPatterns = [
      /'([^'\\\\]|\\\\.)*'/g,
      /"([^"\\\\]|\\\\.)*"/g
    ];

    for (const pattern of stringPatterns) {
      let match;
      while ((match = pattern.exec(content)) !== null) {
        const stringValue = match[0].slice(1, -1); // 따옴표 제거
        
        // 무시할 패턴들 확인
        if (this.shouldIgnoreString(stringValue)) {
          continue;
        }

        // 사용자에게 보여질 가능성이 있는 문자열인지 확인
        if (this.isUserFacingString(stringValue)) {
          const lineNumber = this.getLineNumber(content, match.index);
          
          this.hardcodedStrings.push({
            file: filePath,
            line: lineNumber,
            string: stringValue,
            context: this.getContext(content, match.index)
          });
          
          this.totalIssues++;
        }
      }
    }
  }

  shouldIgnoreString(str) {
    if (!str || str.length === 0) return true;
    
    return this.ignorePatterns.some(pattern => pattern.test(str));
  }

  isUserFacingString(str) {
    // 공백만 있는 문자열 무시
    if (!str.trim()) return false;
    
    // 매우 짧은 문자열 (아이콘이나 구분자일 가능성)
    if (str.length < 2) return false;
    
    // 사용자 친화적 문자열 패턴
    const userFacingPatterns = [
      /[가-힣]/, // 한글
      /[a-zA-Z]{3,}/, // 3글자 이상 영문
      /\s/, // 공백을 포함한 문구
    ];
    
    return userFacingPatterns.some(pattern => pattern.test(str));
  }

  checkLocalizableWidgets(content, filePath, hasLocalizationImport) {
    for (const widget of this.localizableWidgets) {
      const widgetPattern = new RegExp(`${widget}\\s*\\(`, 'g');
      let match;
      
      while ((match = widgetPattern.exec(content)) !== null) {
        const lineNumber = this.getLineNumber(content, match.index);
        const context = this.getContext(content, match.index);
        
        // 해당 위젯이 AppLocalizations를 사용하는지 확인
        const isLocalized = /l10n\?\.|\bl10n\.|\bAppLocalizations\b/.test(context);
        
        if (!isLocalized && this.containsUserText(context)) {
          this.nonLocalizedWidgets.push({
            file: filePath,
            line: lineNumber,
            widget: widget,
            context: context,
            hasImport: hasLocalizationImport
          });
          
          this.totalIssues++;
        }
      }
    }
  }

  containsUserText(context) {
    // 사용자에게 보여질 텍스트가 포함되어 있는지 확인
    const textPatterns = [
      /'[^']*[가-힣][^']*'/, // 한글 포함 문자열
      /"[^"]*[가-힣][^"]*"/, // 한글 포함 문자열
      /'[A-Za-z\s]{3,}'/, // 영문 문구
      /"[A-Za-z\s]{3,}"/, // 영문 문구
    ];
    
    return textPatterns.some(pattern => pattern.test(context));
  }

  checkTranslationKeys(content, filePath) {
    // AppLocalizations 사용 패턴 확인
    const localizationPattern = /l10n\?\.([\w]+)/g;
    let match;
    
    while ((match = localizationPattern.exec(content)) !== null) {
      const key = match[1];
      const lineNumber = this.getLineNumber(content, match.index);
      
      // 여기서 실제 ARB 파일에 해당 키가 있는지 확인할 수 있음
      // 현재는 로깅만 수행
      console.log(`  ✓ 번역 키 사용: ${key} (${filePath}:${lineNumber})`);
    }
  }

  getLineNumber(content, index) {
    return content.substring(0, index).split('\n').length;
  }

  getContext(content, index, contextLength = 100) {
    const start = Math.max(0, index - contextLength);
    const end = Math.min(content.length, index + contextLength);
    return content.substring(start, end).replace(/\n/g, ' ').trim();
  }

  generateReport() {
    console.log('\n' + '='.repeat(60));
    console.log('📊 다국어 RP 결과 리포트');
    console.log('='.repeat(60));
    
    console.log(`📁 검사한 파일: ${this.checkedFiles}개`);
    console.log(`⚠️  총 이슈: ${this.totalIssues}개`);
    console.log(`❗ 오류: ${this.errors.length}개`);
    console.log(`⚡ 경고: ${this.warnings.length}개\n`);

    // 하드코딩된 문자열 리포트
    if (this.hardcodedStrings.length > 0) {
      console.log('🔤 하드코딩된 문자열 (다국어 변환 필요):');
      console.log('-'.repeat(50));
      
      this.hardcodedStrings.slice(0, 10).forEach((item, index) => {
        console.log(`${index + 1}. ${item.file}:${item.line}`);
        console.log(`   문자열: "${item.string}"`);
        console.log(`   컨텍스트: ${item.context.substring(0, 80)}...`);
        console.log('');
      });
      
      if (this.hardcodedStrings.length > 10) {
        console.log(`   ... 그 외 ${this.hardcodedStrings.length - 10}개 더`);
      }
      console.log('');
    }

    // 다국어가 필요한 위젯 리포트
    if (this.nonLocalizedWidgets.length > 0) {
      console.log('🎨 다국어 지원이 필요한 위젯:');
      console.log('-'.repeat(50));
      
      this.nonLocalizedWidgets.slice(0, 5).forEach((item, index) => {
        console.log(`${index + 1}. ${item.file}:${item.line}`);
        console.log(`   위젯: ${item.widget}`);
        console.log(`   AppLocalizations Import: ${item.hasImport ? '✓' : '✗'}`);
        console.log(`   컨텍스트: ${item.context.substring(0, 80)}...`);
        console.log('');
      });
      
      if (this.nonLocalizedWidgets.length > 5) {
        console.log(`   ... 그 외 ${this.nonLocalizedWidgets.length - 5}개 더`);
      }
      console.log('');
    }

    // 오류 리포트
    if (this.errors.length > 0) {
      console.log('❌ 오류:');
      console.log('-'.repeat(50));
      this.errors.forEach((error, index) => {
        console.log(`${index + 1}. ${error}`);
      });
      console.log('');
    }

    // 경고 리포트
    if (this.warnings.length > 0) {
      console.log('⚠️  경고:');
      console.log('-'.repeat(50));
      this.warnings.forEach((warning, index) => {
        console.log(`${index + 1}. ${warning}`);
      });
      console.log('');
    }

    // 권장사항
    console.log('💡 권장사항:');
    console.log('-'.repeat(50));
    console.log('1. 하드코딩된 문자열을 AppLocalizations으로 교체하세요');
    console.log('2. 모든 사용자 대면 텍스트에 l10n?.key 패턴을 사용하세요');
    console.log('3. 새로운 화면 개발 시 다국어 지원을 고려하세요');
    console.log('4. ARB 파일에 번역 키를 추가하고 flutter gen-l10n을 실행하세요');
    console.log('');

    // 종합 평가
    console.log('📋 종합 평가:');
    console.log('-'.repeat(50));
    if (this.totalIssues === 0) {
      console.log('🎉 우수! 다국어 지원이 잘 구현되어 있습니다.');
    } else if (this.totalIssues < 10) {
      console.log('👍 양호! 몇 가지 개선이 필요합니다.');
    } else if (this.totalIssues < 25) {
      console.log('⚠️  보통! 다국어 지원을 개선해야 합니다.');
    } else {
      console.log('❗ 주의! 다국어 지원이 많이 부족합니다.');
    }
    
    console.log('='.repeat(60));
  }
}

// 스크립트 실행
if (require.main === module) {
  const rp = new MultilingualRP();
  rp.run().catch(console.error);
}

module.exports = MultilingualRP;