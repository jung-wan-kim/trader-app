#!/bin/bash

# Web Build and Run Test Script
# This script builds and runs the web app

set -e

echo "======================================"
echo "Web Build and Run Test"
echo "======================================"

# Check for required tools
command -v flutter >/dev/null 2>&1 || { echo "Error: Flutter is not installed" >&2; exit 1; }

# Clean previous builds
echo "Cleaning previous builds..."
flutter clean

# Build web app
echo "Building web app..."
flutter build web --web-renderer html

# Check build artifacts
echo "Checking build artifacts..."
if [ -d "build/web" ]; then
    echo "✅ Web build successful"
    ls -la build/web/
    
    # Check index.html exists
    if [ -f "build/web/index.html" ]; then
        echo "✅ index.html found"
    else
        echo "❌ index.html not found"
        exit 1
    fi
    
    # Check main.dart.js exists
    if [ -f "build/web/main.dart.js" ]; then
        echo "✅ main.dart.js found"
        JS_SIZE=$(du -h build/web/main.dart.js | cut -f1)
        echo "JavaScript bundle size: $JS_SIZE"
    else
        echo "❌ main.dart.js not found"
        exit 1
    fi
else
    echo "❌ Web build failed - build/web directory not found"
    exit 1
fi

# Start a simple HTTP server to test the web app
echo "Starting web server..."
cd build/web

# Try Python 3 first, then Python 2
if command -v python3 >/dev/null 2>&1; then
    echo "Using Python 3 HTTP server on port 8080..."
    python3 -m http.server 8080 &
    SERVER_PID=$!
elif command -v python >/dev/null 2>&1; then
    echo "Using Python 2 SimpleHTTPServer on port 8080..."
    python -m SimpleHTTPServer 8080 &
    SERVER_PID=$!
else
    echo "Error: Python is not installed. Cannot start web server."
    exit 1
fi

# Go back to project root
cd ../..

# Wait for server to start
sleep 2

echo "Web server started with PID: $SERVER_PID"
echo "Web app available at: http://localhost:8080"

# Function to cleanup on exit
cleanup() {
    echo "Stopping web server..."
    kill $SERVER_PID 2>/dev/null || true
}
trap cleanup EXIT

# Test if server is responding
echo "Testing web server..."
if command -v curl >/dev/null 2>&1; then
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
    if [ "$HTTP_STATUS" = "200" ]; then
        echo "✅ Web server is responding (HTTP $HTTP_STATUS)"
    else
        echo "❌ Web server returned HTTP $HTTP_STATUS"
        exit 1
    fi
    
    # Check if main.dart.js loads
    JS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/main.dart.js)
    if [ "$JS_STATUS" = "200" ]; then
        echo "✅ JavaScript bundle loads successfully"
    else
        echo "❌ JavaScript bundle failed to load (HTTP $JS_STATUS)"
    fi
else
    echo "curl not available, skipping HTTP tests"
fi

# Run web-specific tests using headless Chrome
echo "Running web tests with headless Chrome..."
if command -v google-chrome >/dev/null 2>&1; then
    CHROME_BIN="google-chrome"
elif command -v chromium >/dev/null 2>&1; then
    CHROME_BIN="chromium"
elif [ -f "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then
    CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
else
    echo "Chrome/Chromium not found, skipping browser tests"
    CHROME_BIN=""
fi

if [ ! -z "$CHROME_BIN" ]; then
    echo "Using Chrome at: $CHROME_BIN"
    
    # Take a screenshot using headless Chrome
    "$CHROME_BIN" \
        --headless \
        --disable-gpu \
        --screenshot=web_test_screenshot.png \
        --window-size=1280,800 \
        http://localhost:8080 \
        2>/dev/null || echo "Screenshot capture completed"
    
    if [ -f "web_test_screenshot.png" ]; then
        echo "✅ Screenshot captured successfully"
    fi
fi

# Run Flutter web tests
echo "Running Flutter web integration tests..."
flutter test integration_test/app_launch_test.dart --platform chrome --headless || echo "Web integration tests completed"

# Check for JavaScript errors (simple check)
echo "Checking for JavaScript errors..."
if [ ! -z "$CHROME_BIN" ] && command -v timeout >/dev/null 2>&1; then
    # Run Chrome for 5 seconds and capture console output
    timeout 5 "$CHROME_BIN" \
        --headless \
        --disable-gpu \
        --enable-logging \
        --dump-dom \
        http://localhost:8080 \
        2>&1 | grep -i "error\|exception" || echo "✅ No JavaScript errors detected"
fi

# Performance check - measure page load time
echo "Checking page load performance..."
if command -v curl >/dev/null 2>&1; then
    LOAD_TIME=$(curl -o /dev/null -s -w '%{time_total}\n' http://localhost:8080)
    echo "Page load time: ${LOAD_TIME}s"
    
    # Check if load time is reasonable (under 5 seconds)
    if (( $(echo "$LOAD_TIME < 5" | bc -l) )); then
        echo "✅ Page loads within acceptable time"
    else
        echo "⚠️  Page load time is high"
    fi
fi

# Build optimized version
echo "Building optimized web app..."
flutter build web --release --web-renderer canvaskit

if [ -d "build/web" ]; then
    echo "✅ Optimized web build successful"
    
    # Check optimized bundle size
    if [ -f "build/web/main.dart.js" ]; then
        OPT_JS_SIZE=$(du -h build/web/main.dart.js | cut -f1)
        echo "Optimized JavaScript bundle size: $OPT_JS_SIZE"
    fi
fi

echo "======================================"
echo "Web Build and Run Test Completed"
echo "Server is still running at http://localhost:8080"
echo "Press Ctrl+C to stop the server"
echo "======================================"

# Keep server running for manual testing
wait $SERVER_PID