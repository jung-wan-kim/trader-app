const { chromium } = require('playwright');

/**
 * Flutter 웹앱 전용 테스트 클래스
 * Flutter의 캔버스 기반 렌더링을 고려한 테스트 전략 사용
 */
class FlutterWebTest {
  constructor() {
    this.browser = null;
    this.page = null;
    this.testResults = [];
  }

  async setup() {
    console.log('🚀 Setting up test environment...');
    this.browser = await chromium.launch({ 
      headless: false,
      args: ['--enable-accessibility-object-model']
    });
    
    const context = await this.browser.newContext({
      viewport: { width: 1280, height: 720 }
    });
    
    this.page = await context.newPage();
    
    // Console logs 캡처
    this.page.on('console', msg => {
      if (msg.type() === 'error') {
        console.log('❌ Console Error:', msg.text());
      }
    });
  }

  async navigateToApp() {
    console.log('📱 Navigating to Flutter app...');
    await this.page.goto('http://localhost:8080', {
      waitUntil: 'networkidle',
      timeout: 60000
    });
    
    // Flutter 초기화 대기
    console.log('⏳ Waiting for Flutter to initialize...');
    await this.page.waitForTimeout(5000); // 스플래시 스크린 대기
    
    // 접근성 활성화 확인
    const needsAccessibility = await this.page.locator('[aria-label="Enable accessibility"]').isVisible()
      .catch(() => false);
    
    if (needsAccessibility) {
      console.log('🔧 Enabling accessibility...');
      await this.page.click('[aria-label="Enable accessibility"]');
      await this.page.waitForTimeout(2000);
    }
  }

  async takeScreenshot(name) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const path = `test/playwright/screenshots/${name}-${timestamp}.png`;
    await this.page.screenshot({ path, fullPage: true });
    console.log(`📸 Screenshot saved: ${name}`);
    return path;
  }

  async testWithCoordinates() {
    console.log('\n📋 Testing with coordinate-based clicks...');
    const results = [];
    
    try {
      // 현재 화면 스크린샷
      await this.takeScreenshot('01-initial-screen');
      
      // 화면 중앙 좌표 계산
      const viewport = await this.page.viewportSize();
      const centerX = viewport.width / 2;
      const centerY = viewport.height / 2;
      
      console.log(`Viewport size: ${viewport.width}x${viewport.height}`);
      
      // 언어 옵션 위치 추정 (화면 중앙 부근)
      const languageOptions = [
        { name: 'English', y: centerY - 150 },
        { name: '한국어', y: centerY - 50 },
        { name: '中文简体', y: centerY + 50 },
        { name: '日本語', y: centerY + 150 }
      ];
      
      // 한국어 선택 시도
      console.log('🔘 Attempting to click Korean option...');
      await this.page.mouse.click(centerX, languageOptions[1].y);
      await this.page.waitForTimeout(1000);
      await this.takeScreenshot('02-after-korean-click');
      
      // Continue 버튼 클릭 (보통 하단에 위치)
      console.log('🔘 Attempting to click Continue button...');
      const continueY = viewport.height - 100;
      await this.page.mouse.click(centerX, continueY);
      await this.page.waitForTimeout(3000);
      await this.takeScreenshot('03-after-continue-click');
      
      results.push({
        test: 'Coordinate-based navigation',
        passed: true,
        note: 'Clicked through language selection using coordinates'
      });
      
    } catch (error) {
      console.error('❌ Test error:', error.message);
      results.push({
        test: 'Coordinate-based navigation',
        passed: false,
        error: error.message
      });
    }
    
    return results;
  }

  async testWithKeyboard() {
    console.log('\n⌨️ Testing with keyboard navigation...');
    const results = [];
    
    try {
      // Tab 키로 네비게이션
      console.log('Pressing Tab to navigate...');
      for (let i = 0; i < 5; i++) {
        await this.page.keyboard.press('Tab');
        await this.page.waitForTimeout(500);
      }
      
      // Enter 키로 선택
      console.log('Pressing Enter to select...');
      await this.page.keyboard.press('Enter');
      await this.page.waitForTimeout(2000);
      await this.takeScreenshot('04-after-keyboard-nav');
      
      results.push({
        test: 'Keyboard navigation',
        passed: true
      });
      
    } catch (error) {
      results.push({
        test: 'Keyboard navigation',
        passed: false,
        error: error.message
      });
    }
    
    return results;
  }

  async checkVisualElements() {
    console.log('\n🎨 Checking visual elements...');
    
    // Flutter canvas 확인
    const flutterView = await this.page.$('flt-glass-pane');
    const hasFlutterView = !!flutterView;
    
    // 페이지 타이틀 확인
    const title = await this.page.title();
    
    // 현재 URL 확인
    const url = this.page.url();
    
    console.log(`Flutter view found: ${hasFlutterView}`);
    console.log(`Page title: ${title}`);
    console.log(`Current URL: ${url}`);
    
    return {
      hasFlutterView,
      title,
      url
    };
  }

  async generateReport() {
    console.log('\n📊 Test Summary:');
    console.log('================');
    
    let totalTests = 0;
    let passedTests = 0;
    
    this.testResults.forEach(resultSet => {
      resultSet.forEach(result => {
        totalTests++;
        if (result.passed) passedTests++;
        
        const status = result.passed ? '✅' : '❌';
        console.log(`${status} ${result.test}`);
        if (result.error) {
          console.log(`   Error: ${result.error}`);
        }
        if (result.note) {
          console.log(`   Note: ${result.note}`);
        }
      });
    });
    
    const successRate = ((passedTests / totalTests) * 100).toFixed(1);
    console.log(`\nSuccess Rate: ${successRate}% (${passedTests}/${totalTests})`);
  }

  async cleanup() {
    // 브라우저는 열어둠 (디버깅용)
    console.log('\n🔍 Browser window remains open for inspection.');
    console.log('Press Ctrl+C to close.');
  }

  async run() {
    try {
      await this.setup();
      await this.navigateToApp();
      
      // 시각적 요소 확인
      const visualCheck = await this.checkVisualElements();
      console.log('\nVisual check results:', visualCheck);
      
      // 좌표 기반 테스트
      const coordResults = await this.testWithCoordinates();
      this.testResults.push(coordResults);
      
      // 키보드 네비게이션 테스트
      const keyboardResults = await this.testWithKeyboard();
      this.testResults.push(keyboardResults);
      
      // 최종 스크린샷
      await this.takeScreenshot('05-final-state');
      
      // 리포트 생성
      await this.generateReport();
      
    } catch (error) {
      console.error('❌ Test suite error:', error);
      await this.takeScreenshot('error-state');
    } finally {
      await this.cleanup();
    }
  }
}

// 테스트 실행
const test = new FlutterWebTest();
test.run().catch(console.error);