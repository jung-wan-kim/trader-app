const { chromium } = require('playwright');

async function runUITest() {
  console.log('Starting Trader App UI Test...');
  
  // Launch browser
  const browser = await chromium.launch({ 
    headless: false,
    slowMo: 500 // Slow down for visibility
  });
  
  const context = await browser.newContext({
    viewport: { width: 1280, height: 720 }
  });
  
  const page = await context.newPage();
  
  try {
    // Navigate to app
    console.log('Navigating to http://localhost:8081...');
    await page.goto('http://localhost:8081', { 
      waitUntil: 'networkidle',
      timeout: 30000 
    });
    
    // Wait for app to load
    console.log('Waiting for app to load...');
    await page.waitForTimeout(5000);
    
    // Take initial screenshot
    await page.screenshot({ 
      path: 'test/playwright/screenshots/01-initial-load.png',
      fullPage: true 
    });
    console.log('✓ Initial screenshot captured');
    
    // Check if language selection screen is visible
    const languageSelector = await page.locator('text=언어 선택').isVisible().catch(() => false);
    if (languageSelector) {
      console.log('Language selection screen detected');
      
      // Select Korean
      await page.click('text=한국어');
      await page.waitForTimeout(2000);
      await page.screenshot({ 
        path: 'test/playwright/screenshots/02-language-selected.png' 
      });
      console.log('✓ Language selected');
    }
    
    // Check for onboarding screen
    const onboardingScreen = await page.locator('text=시작하기').isVisible().catch(() => false);
    if (onboardingScreen) {
      console.log('Onboarding screen detected');
      await page.screenshot({ 
        path: 'test/playwright/screenshots/03-onboarding.png' 
      });
      
      // Complete onboarding
      await page.click('text=시작하기');
      await page.waitForTimeout(2000);
    }
    
    // Check for login screen
    const loginScreen = await page.locator('input[type="email"]').isVisible().catch(() => false);
    if (loginScreen) {
      console.log('Login screen detected');
      await page.screenshot({ 
        path: 'test/playwright/screenshots/04-login-screen.png' 
      });
      
      // Try demo login
      const demoButton = await page.locator('text=Demo').isVisible().catch(() => false);
      if (demoButton) {
        await page.click('text=Demo');
        await page.waitForTimeout(3000);
        console.log('✓ Demo mode activated');
      }
    }
    
    // Check main screen elements
    console.log('Checking main screen elements...');
    
    // Look for bottom navigation
    const bottomNav = await page.locator('[role="navigation"]').isVisible().catch(() => false);
    if (bottomNav) {
      console.log('✓ Bottom navigation found');
      
      // Try to navigate through tabs
      const tabs = ['홈', '전략', '포지션', '성과', '프로필'];
      for (const tab of tabs) {
        const tabElement = await page.locator(`text=${tab}`).isVisible().catch(() => false);
        if (tabElement) {
          await page.click(`text=${tab}`);
          await page.waitForTimeout(1500);
          await page.screenshot({ 
            path: `test/playwright/screenshots/05-tab-${tab}.png` 
          });
          console.log(`✓ Navigated to ${tab} tab`);
        }
      }
    }
    
    // Final screenshot
    await page.screenshot({ 
      path: 'test/playwright/screenshots/06-final-state.png',
      fullPage: true 
    });
    
    console.log('\n✅ UI Test completed successfully!');
    console.log('Screenshots saved in: test/playwright/screenshots/');
    
  } catch (error) {
    console.error('❌ Test failed:', error);
    await page.screenshot({ 
      path: 'test/playwright/screenshots/error-state.png',
      fullPage: true 
    });
  } finally {
    await browser.close();
  }
}

// Run the test
runUITest().catch(console.error);