const { chromium } = require('playwright');

async function quickTest() {
  console.log('🚀 Starting quick test...');
  
  const browser = await chromium.launch({
    headless: true,
    timeout: 10000
  });
  
  try {
    const context = await browser.newContext();
    const page = await context.newPage();
    
    // Log console messages
    page.on('console', msg => {
      console.log(`[Console ${msg.type()}]`, msg.text());
    });
    
    page.on('response', response => {
      if (response.status() >= 400) {
        console.log(`❌ HTTP ${response.status()} - ${response.url()}`);
      }
    });
    
    console.log('📱 Navigating to app...');
    const response = await page.goto('http://localhost:8080/index.html', {
      waitUntil: 'domcontentloaded',
      timeout: 10000
    });
    
    console.log(`✅ Page loaded with status: ${response.status()}`);
    
    // Wait a bit for app to initialize
    await page.waitForTimeout(3000);
    
    // Check what's on the page
    console.log('\n📋 Checking page content...');
    
    // Try to find any visible text
    const bodyText = await page.textContent('body');
    console.log('Body text length:', bodyText.length);
    
    // Check for common Flutter app elements
    const elements = [
      'text=Choose Your Language',
      'text=언어 선택',
      'text=로그인',
      'text=Login',
      'flutter-view',
      'flt-glass-pane',
      '[class*="flutter"]'
    ];
    
    for (const selector of elements) {
      try {
        const visible = await page.locator(selector).first().isVisible({ timeout: 1000 });
        if (visible) {
          console.log(`✅ Found: ${selector}`);
        }
      } catch (e) {
        // Element not found
      }
    }
    
    // Take a screenshot
    await page.screenshot({ path: 'test/playwright/screenshots/quick-test.png' });
    console.log('📸 Screenshot saved');
    
    // Get page title
    const title = await page.title();
    console.log(`Page title: "${title}"`);
    
  } catch (error) {
    console.error('❌ Test error:', error.message);
  } finally {
    await browser.close();
  }
}

quickTest().catch(console.error);