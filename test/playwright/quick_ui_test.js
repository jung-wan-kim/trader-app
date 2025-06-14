const { chromium } = require('playwright');

async function runQuickTest() {
  console.log('🚀 Starting Quick UI Test...');
  
  const browser = await chromium.launch({ 
    headless: false,
    slowMo: 200
  });
  
  const page = await browser.newContext().then(ctx => ctx.newPage());
  
  try {
    console.log('📱 Navigating to app...');
    await page.goto('http://localhost:8081', { 
      waitUntil: 'networkidle',
      timeout: 30000 
    });
    
    await page.waitForTimeout(3000);
    console.log('✓ App loaded');
    
    // Take initial screenshot
    await page.screenshot({ path: 'test/playwright/screenshots/quick-test-01-initial.png' });
    console.log('📸 Initial screenshot taken');
    
    // Check if language selection is visible
    const hasLanguageSelection = await page.locator('text=Choose Your Language').isVisible()
      .catch(() => false);
    
    if (hasLanguageSelection) {
      console.log('✓ Language selection screen detected');
      
      // Click Korean
      await page.click('text=한국어');
      await page.waitForTimeout(1000);
      await page.screenshot({ path: 'test/playwright/screenshots/quick-test-02-korean.png' });
      
      // Click Continue if visible
      const continueBtn = await page.locator('text=Continue').isVisible().catch(() => false);
      if (continueBtn) {
        await page.click('text=Continue');
        await page.waitForTimeout(2000);
        console.log('✓ Clicked Continue');
      }
    }
    
    // Check for demo button or login
    const demoButton = await page.locator('text=Demo').first().isVisible().catch(() => false);
    if (demoButton) {
      console.log('✓ Demo button found');
      await page.click('text=Demo');
      await page.waitForTimeout(3000);
      await page.screenshot({ path: 'test/playwright/screenshots/quick-test-03-after-demo.png' });
      console.log('✓ Demo mode activated');
    }
    
    // Try to find bottom navigation
    const bottomNav = await page.locator('[role="navigation"], nav').first().isVisible()
      .catch(() => false);
    
    if (bottomNav) {
      console.log('✓ Bottom navigation found');
      
      // Try clicking tabs by index
      const tabNames = ['홈', '포트폴리오', '성과', '관심종목', '프로필'];
      for (let i = 0; i < tabNames.length; i++) {
        try {
          // Try text selector first
          const tabVisible = await page.locator(`text=${tabNames[i]}`).isVisible().catch(() => false);
          if (tabVisible) {
            await page.click(`text=${tabNames[i]}`);
            console.log(`✓ Clicked ${tabNames[i]} tab`);
          } else {
            // Try clicking by position
            const navBox = await page.locator('[role="navigation"], nav').first().boundingBox();
            if (navBox) {
              const x = navBox.x + (navBox.width / 5 * i) + (navBox.width / 10);
              const y = navBox.y + (navBox.height / 2);
              await page.mouse.click(x, y);
              console.log(`✓ Clicked tab ${i + 1} by position`);
            }
          }
          
          await page.waitForTimeout(1500);
          await page.screenshot({ 
            path: `test/playwright/screenshots/quick-test-0${4 + i}-tab${i + 1}.png` 
          });
        } catch (error) {
          console.log(`⚠️ Could not click tab ${i + 1}: ${error.message}`);
        }
      }
    } else {
      console.log('⚠️ Bottom navigation not found');
    }
    
    // Final screenshot
    await page.screenshot({ 
      path: 'test/playwright/screenshots/quick-test-final.png',
      fullPage: true 
    });
    
    console.log('\n✅ Quick test completed!');
    
  } catch (error) {
    console.error('❌ Test error:', error);
    await page.screenshot({ path: 'test/playwright/screenshots/quick-test-error.png' });
  } finally {
    await browser.close();
  }
}

// Run the test
runQuickTest().catch(console.error);