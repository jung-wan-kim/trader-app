const { chromium } = require('playwright');

async function simpleTest() {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();

  console.log('🚀 Navigating to Flutter app...');
  await page.goto('http://localhost:8080');
  await page.waitForTimeout(5000);

  // 1. Enable accessibility 버튼 클릭
  console.log('\n🔧 Looking for accessibility button...');
  try {
    // 다양한 방법으로 버튼 찾기
    const button1 = await page.$('[aria-label="Enable accessibility"]');
    const button2 = await page.$('button:has-text("Enable accessibility")');
    const button3 = await page.$('text=Enable accessibility');
    
    if (button1) {
      console.log('✅ Found button using aria-label');
      await button1.click();
    } else if (button2) {
      console.log('✅ Found button using has-text');
      await button2.click();
    } else if (button3) {
      console.log('✅ Found button using text selector');
      await button3.click();
    } else {
      console.log('❌ No accessibility button found');
    }
  } catch (error) {
    console.log('❌ Error finding button:', error.message);
  }

  await page.waitForTimeout(3000);

  // 2. 다시 DOM 구조 확인
  console.log('\n📋 Checking DOM after enabling accessibility...');
  const semanticsElements = await page.$$('[role]');
  console.log(`Semantics elements found: ${semanticsElements.length}`);
  
  for (let i = 0; i < Math.min(semanticsElements.length, 20); i++) {
    const element = semanticsElements[i];
    const role = await element.getAttribute('role');
    const ariaLabel = await element.getAttribute('aria-label');
    const text = await element.textContent();
    const isVisible = await element.isVisible();
    
    console.log(`  ${i + 1}. role="${role}", aria-label="${ariaLabel}", text="${text}", visible=${isVisible}`);
  }

  // 3. 특정 텍스트 찾기
  console.log('\n🔍 Looking for specific text...');
  const textsToFind = ['Choose Your Language', '언어를 선택하세요', 'English', '한국어', 'Continue', '계속'];
  
  for (const text of textsToFind) {
    try {
      const element = await page.$(`text=${text}`);
      const ariaElement = await page.$(`[aria-label*="${text}"]`);
      
      if (element) {
        console.log(`✅ Found "${text}" using text selector`);
      } else if (ariaElement) {
        console.log(`✅ Found "${text}" using aria-label`);
      } else {
        console.log(`❌ "${text}" not found`);
      }
    } catch (error) {
      console.log(`❌ Error finding "${text}": ${error.message}`);
    }
  }

  // 4. 스크린샷
  await page.screenshot({ path: 'test/playwright/screenshots/simple-test.png' });
  console.log('\n📸 Screenshot saved');

  console.log('\n✅ Test complete. Keeping browser open...');
  // 브라우저 열어둠
}

simpleTest().catch(console.error);