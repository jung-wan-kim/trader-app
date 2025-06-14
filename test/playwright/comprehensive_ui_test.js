const { chromium } = require('playwright');
const fs = require('fs').promises;
const path = require('path');

class TraderAppUITest {
  constructor() {
    this.browser = null;
    this.context = null;
    this.page = null;
    this.screenshotDir = 'test/playwright/screenshots';
    this.testResults = [];
  }

  async setup() {
    console.log('🚀 Setting up test environment...');
    
    // Create screenshot directories
    const dirs = [
      'language-selection',
      'onboarding', 
      'login',
      'home',
      'portfolio',
      'performance',
      'watchlist',
      'profile',
      'common'
    ];
    
    for (const dir of dirs) {
      await fs.mkdir(path.join(this.screenshotDir, dir), { recursive: true });
    }

    // Launch browser
    this.browser = await chromium.launch({
      headless: true,
      slowMo: 100,
      args: ['--window-size=1280,800']
    });

    this.context = await this.browser.newContext({
      viewport: { width: 1280, height: 800 },
      locale: 'ko-KR',
      timezoneId: 'Asia/Seoul'
    });

    this.page = await this.context.newPage();
    
    // Log console messages
    this.page.on('console', msg => {
      if (msg.type() === 'error') {
        console.log('❌ Console Error:', msg.text());
      }
    });
  }

  async navigateToApp() {
    console.log('📱 Navigating to app...');
    await this.page.goto('http://localhost:8080/index.html', {
      waitUntil: 'networkidle',
      timeout: 60000
    });
    await this.page.waitForTimeout(3000);
  }

  async testLanguageSelection() {
    console.log('\n📋 Testing Language Selection Screen...');
    const results = [];

    try {
      // Check if language selection screen is visible
      const languageScreen = await this.page.locator('text=Choose Your Language').isVisible();
      results.push({
        test: 'Language selection screen visible',
        passed: languageScreen
      });

      if (languageScreen) {
        await this.screenshot('language-selection/01-initial');

        // Test all language options
        const languages = [
          { code: 'en', text: 'English', flag: '🇺🇸' },
          { code: 'ko', text: '한국어', flag: '🇰🇷' },
          { code: 'zh', text: '中文简体', flag: '🇨🇳' },
          { code: 'ja', text: '日本語', flag: '🇯🇵' }
        ];

        for (const lang of languages) {
          const langOption = await this.page.locator(`text=${lang.text}`).isVisible();
          results.push({
            test: `${lang.text} option visible`,
            passed: langOption
          });
        }

        // Select Korean
        await this.page.click('text=한국어');
        await this.page.waitForTimeout(1000);
        await this.screenshot('language-selection/02-korean-selected');

        // Click Continue
        const continueButton = await this.page.locator('text=Continue').isVisible();
        if (continueButton) {
          await this.page.click('text=Continue');
          await this.page.waitForTimeout(2000);
        }
      }
    } catch (error) {
      console.error('❌ Language selection test error:', error);
      results.push({
        test: 'Language selection test',
        passed: false,
        error: error.message
      });
    }

    this.testResults.push({ screen: 'Language Selection', results });
    return results;
  }

  async testOnboarding() {
    console.log('\n📋 Testing Onboarding Screen...');
    const results = [];

    try {
      // Check if onboarding is visible
      const onboardingVisible = await this.page.locator('text=시작하기').isVisible()
        .catch(() => false);

      if (onboardingVisible) {
        await this.screenshot('onboarding/01-page1');

        // Test swipe navigation
        for (let i = 0; i < 2; i++) {
          await this.page.locator('.onboarding-container').swipe({
            direction: 'left',
            distance: 300
          }).catch(() => {
            // Fallback to click on indicator
            this.page.click(`.page-indicator:nth-child(${i + 2})`);
          });
          await this.page.waitForTimeout(1000);
          await this.screenshot(`onboarding/0${i + 2}-page${i + 2}`);
        }

        // Click start button
        const startButton = await this.page.locator('text=시작하기').isVisible();
        results.push({
          test: 'Start button visible',
          passed: startButton
        });

        if (startButton) {
          await this.page.click('text=시작하기');
          await this.page.waitForTimeout(2000);
        }
      }
    } catch (error) {
      console.error('❌ Onboarding test error:', error);
      results.push({
        test: 'Onboarding test',
        passed: false,
        error: error.message
      });
    }

    this.testResults.push({ screen: 'Onboarding', results });
    return results;
  }

  async testLogin() {
    console.log('\n📋 Testing Login Screen...');
    const results = [];

    try {
      // Check if login screen is visible
      const emailInput = await this.page.locator('input[type="email"]').isVisible()
        .catch(() => false);

      if (emailInput) {
        await this.screenshot('login/01-initial');

        // Test login/signup tab switching
        const signupTab = await this.page.locator('text=회원가입').isVisible();
        if (signupTab) {
          await this.page.click('text=회원가입');
          await this.page.waitForTimeout(500);
          await this.screenshot('login/02-signup-tab');
          
          // Switch back to login
          await this.page.click('text=로그인');
          await this.page.waitForTimeout(500);
        }

        // Test form validation
        await this.page.fill('input[type="email"]', 'invalid-email');
        await this.page.fill('input[type="password"]', '123');
        await this.screenshot('login/03-invalid-input');

        // Clear and fill valid data
        await this.page.fill('input[type="email"]', 'test@example.com');
        await this.page.fill('input[type="password"]', 'Test1234!');
        await this.screenshot('login/04-valid-input');

        // Test Demo mode
        const demoButton = await this.page.locator('text=Continue with Demo').first().isVisible()
          .catch(() => false);
        
        results.push({
          test: 'Demo button visible',
          passed: demoButton
        });

        if (demoButton) {
          await this.page.click('text=Continue with Demo');
          await this.page.waitForTimeout(3000);
          await this.screenshot('login/05-demo-clicked');
        }
      }
    } catch (error) {
      console.error('❌ Login test error:', error);
      results.push({
        test: 'Login test',
        passed: false,
        error: error.message
      });
    }

    this.testResults.push({ screen: 'Login', results });
    return results;
  }

  async testHomeScreen() {
    console.log('\n📋 Testing Home Screen (Signals)...');
    const results = [];

    try {
      // Wait for home screen to load
      await this.page.waitForTimeout(2000);
      
      // Check if we're on home screen
      const homeScreen = await this.page.locator('text=AI 추천').isVisible()
        .catch(() => this.page.locator('text=Signals').isVisible())
        .catch(() => false);

      if (homeScreen) {
        await this.screenshot('home/01-initial');

        // Test filter button
        const filterButton = await this.page.locator('[aria-label="filter"], button:has-text("필터")').first().isVisible()
          .catch(() => false);
        
        results.push({
          test: 'Filter button visible',
          passed: filterButton
        });

        if (filterButton) {
          await this.page.locator('[aria-label="filter"], button:has-text("필터")').first().click();
          await this.page.waitForTimeout(1000);
          await this.screenshot('home/02-filter-dialog');
          
          // Close filter
          await this.page.keyboard.press('Escape');
          await this.page.waitForTimeout(500);
        }

        // Test recommendation cards
        const recommendationCards = await this.page.locator('.recommendation-card, [class*="card"]').count();
        results.push({
          test: 'Recommendation cards displayed',
          passed: recommendationCards > 0,
          count: recommendationCards
        });

        if (recommendationCards > 0) {
          // Click first card
          await this.page.locator('.recommendation-card, [class*="card"]').first().click();
          await this.page.waitForTimeout(2000);
          await this.screenshot('home/03-detail-view');
          
          // Go back
          await this.page.goBack();
          await this.page.waitForTimeout(1000);
        }

        // Test pull to refresh (simulate)
        await this.page.evaluate(() => {
          window.scrollTo(0, -100);
        });
        await this.page.waitForTimeout(1000);
        await this.screenshot('home/04-pull-refresh');
      }
    } catch (error) {
      console.error('❌ Home screen test error:', error);
      results.push({
        test: 'Home screen test',
        passed: false,
        error: error.message
      });
    }

    this.testResults.push({ screen: 'Home', results });
    return results;
  }

  async testBottomNavigation() {
    console.log('\n📋 Testing Bottom Navigation...');
    const results = [];

    try {
      const tabs = [
        { index: 0, name: '신호', key: 'signals' },
        { index: 1, name: '포트폴리오', key: 'portfolio' },
        { index: 2, name: '성과', key: 'performance' },
        { index: 3, name: '관심종목', key: 'watchlist' },
        { index: 4, name: '프로필', key: 'profile' }
      ];

      for (const tab of tabs) {
        try {
          // Try multiple selectors
          const clicked = await this.clickTab(tab.name, tab.index);
          
          if (clicked) {
            await this.page.waitForTimeout(1500);
            await this.screenshot(`${tab.key}/01-screen`);
            
            results.push({
              test: `Navigate to ${tab.name}`,
              passed: true
            });

            // Test specific screen elements
            await this[`test${tab.key.charAt(0).toUpperCase() + tab.key.slice(1)}Elements`]();
          } else {
            results.push({
              test: `Navigate to ${tab.name}`,
              passed: false,
              error: 'Tab not found'
            });
          }
        } catch (error) {
          results.push({
            test: `Navigate to ${tab.name}`,
            passed: false,
            error: error.message
          });
        }
      }
    } catch (error) {
      console.error('❌ Bottom navigation test error:', error);
      results.push({
        test: 'Bottom navigation test',
        passed: false,
        error: error.message
      });
    }

    this.testResults.push({ screen: 'Bottom Navigation', results });
    return results;
  }

  async clickTab(tabName, index) {
    // Try multiple strategies to click tab
    const selectors = [
      `text=${tabName}`,
      `[aria-label="${tabName}"]`,
      `.bottom-nav-item:nth-child(${index + 1})`,
      `[role="tab"]:nth-child(${index + 1})`,
      `nav button:nth-child(${index + 1})`
    ];

    for (const selector of selectors) {
      try {
        const element = await this.page.locator(selector).first();
        if (await element.isVisible()) {
          await element.click();
          return true;
        }
      } catch (e) {
        // Continue to next selector
      }
    }

    // Fallback: click by coordinates
    const navBar = await this.page.locator('[role="navigation"], nav, .bottom-navigation').first().boundingBox();
    if (navBar) {
      const tabWidth = navBar.width / 5;
      const x = navBar.x + (tabWidth * index) + (tabWidth / 2);
      const y = navBar.y + (navBar.height / 2);
      await this.page.mouse.click(x, y);
      return true;
    }

    return false;
  }

  async testPortfolioElements() {
    console.log('  - Testing Portfolio elements...');
    try {
      const elements = [
        'text=보유 포지션',
        'text=총 수익',
        'text=승률'
      ];

      for (const selector of elements) {
        const visible = await this.page.locator(selector).isVisible()
          .catch(() => false);
        if (visible) {
          console.log(`    ✓ Found: ${selector}`);
        }
      }

      await this.screenshot('portfolio/02-elements');
    } catch (error) {
      console.error('    ❌ Portfolio elements test error:', error);
    }
  }

  async testPerformanceElements() {
    console.log('  - Testing Performance elements...');
    try {
      // Test period filters
      const periods = ['1일', '1주', '1개월', '3개월', '1년'];
      for (const period of periods) {
        const visible = await this.page.locator(`text=${period}`).isVisible()
          .catch(() => false);
        if (visible) {
          await this.page.click(`text=${period}`);
          await this.page.waitForTimeout(500);
        }
      }

      await this.screenshot('performance/02-period-filters');
    } catch (error) {
      console.error('    ❌ Performance elements test error:', error);
    }
  }

  async testWatchlistElements() {
    console.log('  - Testing Watchlist elements...');
    try {
      // Check for add button
      const addButton = await this.page.locator('button:has-text("추가"), [aria-label="add"]').isVisible()
        .catch(() => false);
      
      if (addButton) {
        await this.page.locator('button:has-text("추가"), [aria-label="add"]').first().click();
        await this.page.waitForTimeout(1000);
        await this.screenshot('watchlist/02-add-dialog');
        
        // Close dialog
        await this.page.keyboard.press('Escape');
      }
    } catch (error) {
      console.error('    ❌ Watchlist elements test error:', error);
    }
  }

  async testProfileElements() {
    console.log('  - Testing Profile elements...');
    try {
      const menuItems = [
        '언어 설정',
        '알림 설정',
        '다크 모드',
        '고객 지원',
        '로그아웃'
      ];

      for (const item of menuItems) {
        const visible = await this.page.locator(`text=${item}`).isVisible()
          .catch(() => false);
        if (visible) {
          console.log(`    ✓ Found menu item: ${item}`);
        }
      }

      // Test dark mode toggle
      const darkModeToggle = await this.page.locator('text=다크 모드').isVisible();
      if (darkModeToggle) {
        await this.page.click('text=다크 모드');
        await this.page.waitForTimeout(1000);
        await this.screenshot('profile/02-dark-mode');
        
        // Toggle back
        await this.page.click('text=다크 모드');
        await this.page.waitForTimeout(500);
      }
    } catch (error) {
      console.error('    ❌ Profile elements test error:', error);
    }
  }

  async testSignalsElements() {
    // Placeholder for home screen elements (already tested in testHomeScreen)
    console.log('  - Signals elements already tested');
  }

  async testResponsiveness() {
    console.log('\n📋 Testing Responsive Design...');
    const results = [];

    const viewports = [
      { name: 'mobile', width: 375, height: 812 },
      { name: 'tablet', width: 768, height: 1024 },
      { name: 'desktop', width: 1920, height: 1080 }
    ];

    for (const viewport of viewports) {
      try {
        await this.page.setViewportSize(viewport);
        await this.page.waitForTimeout(1000);
        await this.screenshot(`common/responsive-${viewport.name}`);
        
        results.push({
          test: `${viewport.name} viewport (${viewport.width}x${viewport.height})`,
          passed: true
        });
      } catch (error) {
        results.push({
          test: `${viewport.name} viewport`,
          passed: false,
          error: error.message
        });
      }
    }

    // Reset to default viewport
    await this.page.setViewportSize({ width: 1280, height: 800 });
    
    this.testResults.push({ screen: 'Responsive Design', results });
    return results;
  }

  async screenshot(name) {
    const filepath = path.join(this.screenshotDir, `${name}.png`);
    await this.page.screenshot({ 
      path: filepath,
      fullPage: false 
    });
    console.log(`    📸 Screenshot saved: ${name}`);
  }

  async generateReport() {
    console.log('\n📊 Generating Test Report...');
    
    let totalTests = 0;
    let passedTests = 0;
    let failedTests = 0;

    const reportContent = [`
# Trader App UI Test Report
Generated: ${new Date().toLocaleString('ko-KR')}

## Test Summary
`];

    for (const screenResult of this.testResults) {
      reportContent.push(`\n### ${screenResult.screen}`);
      reportContent.push('| Test Case | Result | Details |');
      reportContent.push('|-----------|--------|---------|');
      
      for (const result of screenResult.results) {
        totalTests++;
        const status = result.passed ? '✅ Passed' : '❌ Failed';
        if (result.passed) passedTests++;
        else failedTests++;
        
        const details = result.error || result.count || '-';
        reportContent.push(`| ${result.test} | ${status} | ${details} |`);
      }
    }

    reportContent.push(`
## Overall Statistics
- Total Tests: ${totalTests}
- Passed: ${passedTests} (${((passedTests/totalTests)*100).toFixed(1)}%)
- Failed: ${failedTests} (${((failedTests/totalTests)*100).toFixed(1)}%)
`);

    await fs.writeFile(
      path.join(this.screenshotDir, 'test-report.md'),
      reportContent.join('\n')
    );

    // Generate HTML report
    const htmlReport = `
<!DOCTYPE html>
<html>
<head>
  <title>Trader App UI Test Report</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 40px; }
    h1, h2, h3 { color: #333; }
    table { border-collapse: collapse; width: 100%; margin: 20px 0; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
    .passed { color: #28a745; }
    .failed { color: #dc3545; }
    .summary { background-color: #f8f9fa; padding: 20px; border-radius: 5px; margin: 20px 0; }
  </style>
</head>
<body>
  <h1>Trader App UI Test Report</h1>
  <p>Generated: ${new Date().toLocaleString('ko-KR')}</p>
  
  <div class="summary">
    <h2>Test Summary</h2>
    <p>Total Tests: ${totalTests}</p>
    <p class="passed">Passed: ${passedTests} (${((passedTests/totalTests)*100).toFixed(1)}%)</p>
    <p class="failed">Failed: ${failedTests} (${((failedTests/totalTests)*100).toFixed(1)}%)</p>
  </div>
  
  ${this.testResults.map(screen => `
    <h3>${screen.screen}</h3>
    <table>
      <tr><th>Test Case</th><th>Result</th><th>Details</th></tr>
      ${screen.results.map(result => `
        <tr>
          <td>${result.test}</td>
          <td class="${result.passed ? 'passed' : 'failed'}">${result.passed ? '✅ Passed' : '❌ Failed'}</td>
          <td>${result.error || result.count || '-'}</td>
        </tr>
      `).join('')}
    </table>
  `).join('')}
</body>
</html>`;

    await fs.writeFile(
      path.join(this.screenshotDir, 'test-report.html'),
      htmlReport
    );

    console.log(`\n✅ Test Report generated: ${path.join(this.screenshotDir, 'test-report.html')}`);
    console.log(`📊 Test Results: ${passedTests}/${totalTests} passed (${((passedTests/totalTests)*100).toFixed(1)}%)`);
  }

  async cleanup() {
    if (this.browser) {
      await this.browser.close();
    }
  }

  async run() {
    try {
      await this.setup();
      await this.navigateToApp();
      
      // Run all tests
      await this.testLanguageSelection();
      await this.testOnboarding();
      await this.testLogin();
      await this.testHomeScreen();
      await this.testBottomNavigation();
      await this.testResponsiveness();
      
      await this.generateReport();
      
      console.log('\n✅ All tests completed!');
    } catch (error) {
      console.error('❌ Test suite error:', error);
      await this.screenshot('error-final-state');
    } finally {
      await this.cleanup();
    }
  }
}

// Run the test suite
const test = new TraderAppUITest();
test.run().catch(console.error);