#!/bin/bash

# Master script to run all platform build tests
# This script orchestrates testing across iOS, Android, and Web platforms

set -e

echo "======================================"
echo "Multi-Platform Build and Test Suite"
echo "======================================"
echo "Starting at: $(date)"
echo ""

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Results directory
RESULTS_DIR="$PROJECT_ROOT/test_results"
mkdir -p "$RESULTS_DIR"

# Log file
LOG_FILE="$RESULTS_DIR/platform_tests_$(date +%Y%m%d_%H%M%S).log"

# Function to log output
log() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Function to run platform test
run_platform_test() {
    local platform=$1
    local script=$2
    local start_time=$(date +%s)
    
    log ""
    log "======================================"
    log "Testing $platform platform"
    log "======================================"
    
    if [ -f "$script" ]; then
        chmod +x "$script"
        if $script >> "$LOG_FILE" 2>&1; then
            local end_time=$(date +%s)
            local duration=$((end_time - start_time))
            log "✅ $platform test completed successfully in ${duration}s"
            echo "PASS" > "$RESULTS_DIR/${platform}_result.txt"
            return 0
        else
            local end_time=$(date +%s)
            local duration=$((end_time - start_time))
            log "❌ $platform test failed after ${duration}s"
            echo "FAIL" > "$RESULTS_DIR/${platform}_result.txt"
            return 1
        fi
    else
        log "❌ $platform test script not found: $script"
        echo "SKIP" > "$RESULTS_DIR/${platform}_result.txt"
        return 1
    fi
}

# Check Flutter installation
log "Checking Flutter installation..."
if ! flutter doctor -v >> "$LOG_FILE" 2>&1; then
    log "❌ Flutter is not properly installed"
    exit 1
fi
log "✅ Flutter is properly installed"

# Run pub get to ensure dependencies are installed
log ""
log "Installing dependencies..."
cd "$PROJECT_ROOT"
flutter pub get >> "$LOG_FILE" 2>&1
log "✅ Dependencies installed"

# Initialize test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

# Run unit tests first
log ""
log "======================================"
log "Running unit tests"
log "======================================"
if flutter test --coverage >> "$LOG_FILE" 2>&1; then
    log "✅ Unit tests passed"
    ((PASSED_TESTS++))
else
    log "❌ Unit tests failed"
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))

# Platform tests
declare -A PLATFORMS=(
    ["iOS"]="$SCRIPT_DIR/test-ios-build.sh"
    ["Android"]="$SCRIPT_DIR/test-android-build.sh"
    ["Web"]="$SCRIPT_DIR/test-web-build.sh"
)

# Detect current OS
OS_TYPE="$(uname -s)"
log ""
log "Detected OS: $OS_TYPE"

# Run platform-specific tests
for platform in "${!PLATFORMS[@]}"; do
    script="${PLATFORMS[$platform]}"
    
    # Skip iOS tests on non-macOS systems
    if [[ "$platform" == "iOS" && "$OS_TYPE" != "Darwin" ]]; then
        log ""
        log "⚠️  Skipping iOS tests (requires macOS)"
        echo "SKIP" > "$RESULTS_DIR/iOS_result.txt"
        ((SKIPPED_TESTS++))
    else
        if run_platform_test "$platform" "$script"; then
            ((PASSED_TESTS++))
        else
            ((FAILED_TESTS++))
        fi
    fi
    ((TOTAL_TESTS++))
done

# Generate summary report
log ""
log "======================================"
log "Test Summary Report"
log "======================================"
log "Total tests run: $TOTAL_TESTS"
log "Passed: $PASSED_TESTS"
log "Failed: $FAILED_TESTS"
log "Skipped: $SKIPPED_TESTS"
log ""

# Generate detailed report
REPORT_FILE="$RESULTS_DIR/test_report_$(date +%Y%m%d_%H%M%S).json"
cat > "$REPORT_FILE" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "summary": {
    "total": $TOTAL_TESTS,
    "passed": $PASSED_TESTS,
    "failed": $FAILED_TESTS,
    "skipped": $SKIPPED_TESTS
  },
  "platforms": {
EOF

first=true
for platform in "${!PLATFORMS[@]}"; do
    if [ -f "$RESULTS_DIR/${platform}_result.txt" ]; then
        result=$(cat "$RESULTS_DIR/${platform}_result.txt")
        if [ "$first" = false ]; then
            echo "," >> "$REPORT_FILE"
        fi
        echo -n "    \"$platform\": \"$result\"" >> "$REPORT_FILE"
        first=false
    fi
done

cat >> "$REPORT_FILE" << EOF

  },
  "artifacts": {
    "ios_screenshot": "ios_test_screenshot.png",
    "android_screenshot": "android_test_screenshot.png",
    "web_screenshot": "web_test_screenshot.png"
  },
  "log_file": "$LOG_FILE"
}
EOF

log "Detailed report saved to: $REPORT_FILE"

# Check for screenshots
log ""
log "Screenshots captured:"
for screenshot in ios_test_screenshot.png android_test_screenshot.png web_test_screenshot.png; do
    if [ -f "$PROJECT_ROOT/$screenshot" ]; then
        log "✅ $screenshot"
    fi
done

# Coverage report
if [ -f "$PROJECT_ROOT/coverage/lcov.info" ]; then
    log ""
    log "Code coverage report available at: $PROJECT_ROOT/coverage/lcov.info"
fi

# Exit with appropriate code
if [ $FAILED_TESTS -eq 0 ]; then
    log ""
    log "✅ All tests passed!"
    exit 0
else
    log ""
    log "❌ Some tests failed. Please check the logs."
    exit 1
fi