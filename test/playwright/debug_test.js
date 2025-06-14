const { chromium } = require('playwright');

async function debugFlutterApp() {
  const browser = await chromium.launch({ 
    headless: false,
    devtools: true 
  });
  const page = await browser.newPage();

  console.log('🚀 Navigating to Flutter app...');
  await page.goto('http://localhost:8080');
  await page.waitForTimeout(5000); // Flutter 앱 로딩 대기

  console.log('\n📋 Checking DOM structure...');
  
  // 1. Flutter view 확인
  const flutterView = await page.$('flt-glass-pane');
  console.log('Flutter glass pane found:', !!flutterView);

  // 2. Semantics 요소 확인
  const semanticsElements = await page.$$('[role]');
  console.log(`\nSemantics elements found: ${semanticsElements.length}`);
  
  for (let i = 0; i < Math.min(semanticsElements.length, 10); i++) {
    const role = await semanticsElements[i].getAttribute('role');
    const ariaLabel = await semanticsElements[i].getAttribute('aria-label');
    const text = await semanticsElements[i].textContent();
    console.log(`  ${i + 1}. role="${role}", aria-label="${ariaLabel}", text="${text}"`);
  }

  // 3. 모든 버튼 요소 찾기
  console.log('\n🔘 Looking for button elements...');
  const buttons = await page.$$('[role="button"]');
  console.log(`Buttons found: ${buttons.length}`);
  
  for (const button of buttons) {
    const ariaLabel = await button.getAttribute('aria-label');
    const text = await button.textContent();
    console.log(`  - Button: aria-label="${ariaLabel}", text="${text}"`);
  }

  // 4. 텍스트 요소 찾기
  console.log('\n📝 Looking for text elements...');
  const textElements = await page.$$('[role="text"], [role="heading"]');
  console.log(`Text elements found: ${textElements.length}`);
  
  for (let i = 0; i < Math.min(textElements.length, 10); i++) {
    const role = await textElements[i].getAttribute('role');
    const text = await textElements[i].textContent();
    console.log(`  ${i + 1}. ${role}: "${text}"`);
  }

  // 5. 클릭 가능한 요소 찾기
  console.log('\n👆 Looking for clickable elements...');
  const clickableElements = await page.$$('[aria-label]');
  console.log(`Elements with aria-label: ${clickableElements.length}`);

  // 6. HTML 구조 확인
  console.log('\n🏗️ HTML structure:');
  const bodyHTML = await page.evaluate(() => {
    const body = document.body;
    const structure = [];
    
    function traverse(element, depth = 0) {
      if (depth > 3) return; // 깊이 제한
      
      const tag = element.tagName.toLowerCase();
      const role = element.getAttribute('role');
      const ariaLabel = element.getAttribute('aria-label');
      
      if (role || ariaLabel || tag.startsWith('flt-')) {
        structure.push({
          depth,
          tag,
          role,
          ariaLabel,
          childCount: element.children.length
        });
        
        for (const child of element.children) {
          traverse(child, depth + 1);
        }
      }
    }
    
    traverse(body);
    return structure;
  });

  bodyHTML.forEach(item => {
    const indent = '  '.repeat(item.depth);
    console.log(`${indent}<${item.tag}> role="${item.role}" aria-label="${item.ariaLabel}" children=${item.childCount}`);
  });

  // 7. 스크린샷 저장
  await page.screenshot({ path: 'test/playwright/screenshots/debug-screenshot.png' });
  console.log('\n📸 Screenshot saved: debug-screenshot.png');

  // 브라우저는 열어둠 (수동으로 확인 가능)
  console.log('\n✅ Debug complete. Browser window remains open for manual inspection.');
  console.log('Press Ctrl+C to close.');
}

debugFlutterApp().catch(console.error);