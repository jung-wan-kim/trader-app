const { chromium } = require('playwright');

class AdvancedFlutterTest {
  constructor() {
    this.browser = null;
    this.page = null;
  }

  async setup() {
    this.browser = await chromium.launch({ 
      headless: false,
      devtools: true 
    });
    this.page = await this.browser.newPage();
  }

  async navigateAndWait() {
    console.log('🚀 Navigating to Flutter app...');
    await this.page.goto('http://localhost:8080', {
      waitUntil: 'networkidle',
      timeout: 60000
    });
    
    // Wait for Flutter to initialize
    await this.page.waitForFunction(() => {
      return window.flutter && window.flutter.initialized;
    }, { timeout: 30000 }).catch(() => {
      console.log('⚠️ Flutter initialization check skipped');
    });
    
    await this.page.waitForTimeout(5000);
  }

  async findFlutterElements() {
    console.log('\n🔍 Searching for Flutter elements...');
    
    // Method 1: Check Shadow DOM
    const shadowRoots = await this.page.evaluate(() => {
      const elements = [];
      const traverse = (node) => {
        if (node.shadowRoot) {
          elements.push({
            tag: node.tagName,
            id: node.id,
            className: node.className
          });
        }
        node.querySelectorAll('*').forEach(traverse);
      };
      traverse(document.body);
      return elements;
    });
    console.log(`Shadow DOM elements: ${shadowRoots.length}`);
    
    // Method 2: Find elements inside flt-semantics
    const semanticsHost = await this.page.$('flt-semantics-host');
    if (semanticsHost) {
      console.log('✅ Found semantics host');
      
      // Get all semantics elements
      const semanticsElements = await this.page.evaluate(() => {
        const host = document.querySelector('flt-semantics-host');
        if (!host) return [];
        
        const elements = [];
        const collectElements = (root) => {
          root.querySelectorAll('[role], [aria-label]').forEach(el => {
            elements.push({
              tag: el.tagName,
              role: el.getAttribute('role'),
              ariaLabel: el.getAttribute('aria-label'),
              text: el.textContent?.trim(),
              visible: el.offsetParent !== null
            });
          });
        };
        
        // Check shadow root
        if (host.shadowRoot) {
          collectElements(host.shadowRoot);
        }
        collectElements(host);
        
        return elements;
      });
      
      console.log(`\nFound ${semanticsElements.length} semantic elements:`);
      semanticsElements.forEach((el, i) => {
        if (el.visible && (el.ariaLabel || el.text)) {
          console.log(`  ${i + 1}. ${el.tag} role="${el.role}" aria-label="${el.ariaLabel}" text="${el.text}"`);
        }
      });
    }
  }

  async testLanguageSelection() {
    console.log('\n📋 Testing Language Selection...');
    
    // Try multiple methods to interact with Flutter elements
    
    // Method 1: Direct click on coordinates (if we know where elements are)
    console.log('Attempting coordinate-based clicks...');
    
    // Get viewport size
    const viewport = await this.page.viewportSize();
    console.log(`Viewport: ${viewport.width}x${viewport.height}`);
    
    // Take screenshot for reference
    await this.page.screenshot({ path: 'test/playwright/screenshots/advanced-before-click.png' });
    
    // Try clicking in the middle where language options might be
    const centerX = viewport.width / 2;
    const optionHeight = 80; // Approximate height of each option
    const startY = viewport.height / 2 - 100; // Start from above center
    
    // Click where Korean option might be (2nd option)
    console.log(`Clicking at coordinates (${centerX}, ${startY + optionHeight})...`);
    await this.page.mouse.click(centerX, startY + optionHeight);
    await this.page.waitForTimeout(2000);
    
    await this.page.screenshot({ path: 'test/playwright/screenshots/advanced-after-korean-click.png' });
    
    // Click Continue button (usually at bottom)
    const continueY = viewport.height - 100;
    console.log(`Clicking Continue at (${centerX}, ${continueY})...`);
    await this.page.mouse.click(centerX, continueY);
    await this.page.waitForTimeout(3000);
    
    await this.page.screenshot({ path: 'test/playwright/screenshots/advanced-after-continue.png' });
  }

  async run() {
    try {
      await this.setup();
      await this.navigateAndWait();
      await this.findFlutterElements();
      await this.testLanguageSelection();
      
      console.log('\n✅ Test complete. Browser remains open.');
    } catch (error) {
      console.error('❌ Test error:', error);
      await this.page.screenshot({ path: 'test/playwright/screenshots/advanced-error.png' });
    }
  }
}

const test = new AdvancedFlutterTest();
test.run().catch(console.error);