#!/bin/bash

# Trader App - Comprehensive Test Coverage Script
# 98% 테스트 커버리지 달성을 위한 스크립트

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT=$(pwd)
COVERAGE_DIR="coverage"
REPORTS_DIR="test_reports"
MIN_COVERAGE_THRESHOLD=98.0

echo -e "${BLUE}🚀 Trader App - Test Coverage Analysis${NC}"
echo "========================================"
echo "Target Coverage: ${MIN_COVERAGE_THRESHOLD}%"
echo ""

# Clean previous coverage data
echo -e "${YELLOW}🧹 Cleaning previous coverage data...${NC}"
rm -rf "$COVERAGE_DIR"
rm -rf "$REPORTS_DIR"
mkdir -p "$COVERAGE_DIR"
mkdir -p "$REPORTS_DIR"

# Install dependencies if needed
echo -e "${YELLOW}📦 Ensuring dependencies are installed...${NC}"
flutter pub get

# Function to run tests with coverage for a specific directory
run_test_suite() {
    local test_dir=$1
    local suite_name=$2
    local output_file="$REPORTS_DIR/${suite_name}_results.json"
    
    echo -e "${BLUE}🧪 Running ${suite_name} tests...${NC}"
    
    if [ -d "test/$test_dir" ]; then
        flutter test "test/$test_dir" \
            --coverage \
            --reporter=json \
            --coverage-path="$COVERAGE_DIR/${suite_name}_lcov.info" \
            > "$output_file" 2>&1
        
        local exit_code=$?
        if [ $exit_code -eq 0 ]; then
            echo -e "${GREEN}✅ ${suite_name} tests passed${NC}"
        else
            echo -e "${RED}❌ ${suite_name} tests failed${NC}"
            cat "$output_file"
            return $exit_code
        fi
    else
        echo -e "${YELLOW}⚠️  ${suite_name} test directory not found: test/$test_dir${NC}"
    fi
}

# Function to merge LCOV files
merge_coverage() {
    echo -e "${YELLOW}🔗 Merging coverage data...${NC}"
    
    local lcov_files=""
    for file in "$COVERAGE_DIR"/*_lcov.info; do
        if [ -f "$file" ]; then
            lcov_files="$lcov_files -a $file"
        fi
    done
    
    if [ -n "$lcov_files" ]; then
        lcov $lcov_files -o "$COVERAGE_DIR/merged_lcov.info"
    else
        echo -e "${RED}❌ No LCOV files found to merge${NC}"
        return 1
    fi
}

# Run comprehensive test suites
echo -e "${BLUE}🏃‍♂️ Running comprehensive test suites...${NC}"

# Unit Tests
run_test_suite "unit/models" "models"
run_test_suite "unit/providers" "providers" 
run_test_suite "unit/services" "services"
run_test_suite "unit/widgets" "widgets"
run_test_suite "unit/theme" "theme"

# Integration Tests
run_test_suite "integration" "integration"

# Widget Tests (if main widget_test.dart exists)
if [ -f "test/widget_test.dart" ]; then
    echo -e "${BLUE}🧪 Running main widget tests...${NC}"
    flutter test test/widget_test.dart \
        --coverage \
        --reporter=json \
        --coverage-path="$COVERAGE_DIR/widget_lcov.info" \
        > "$REPORTS_DIR/widget_results.json" 2>&1
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Widget tests passed${NC}"
    else
        echo -e "${RED}❌ Widget tests failed${NC}"
        cat "$REPORTS_DIR/widget_results.json"
    fi
fi

# Performance Tests
run_test_suite "performance" "performance"

# E2E Tests (if available)
if [ -d "test/e2e" ]; then
    run_test_suite "e2e" "e2e"
fi

# Merge all coverage data
merge_coverage

# Generate HTML coverage report
echo -e "${YELLOW}📊 Generating HTML coverage report...${NC}"
if [ -f "$COVERAGE_DIR/merged_lcov.info" ]; then
    genhtml "$COVERAGE_DIR/merged_lcov.info" \
        --output-directory "$COVERAGE_DIR/html" \
        --title "Trader App Test Coverage" \
        --legend \
        --show-details \
        --highlight \
        --frames \
        --demangle-cpp \
        --prefix "$PROJECT_ROOT"
    
    echo -e "${GREEN}📈 HTML coverage report generated: $COVERAGE_DIR/html/index.html${NC}"
else
    echo -e "${RED}❌ No merged coverage data found${NC}"
    exit 1
fi

# Extract coverage percentage
echo -e "${YELLOW}📈 Analyzing coverage results...${NC}"
COVERAGE_SUMMARY=$(lcov --summary "$COVERAGE_DIR/merged_lcov.info" 2>&1)
COVERAGE_PERCENTAGE=$(echo "$COVERAGE_SUMMARY" | grep -oP 'lines......: \K[0-9.]+(?=%)')

if [ -z "$COVERAGE_PERCENTAGE" ]; then
    echo -e "${RED}❌ Could not extract coverage percentage${NC}"
    exit 1
fi

echo ""
echo "========================================"
echo -e "${BLUE}📊 COVERAGE SUMMARY${NC}"
echo "========================================"
echo -e "Current Coverage: ${GREEN}${COVERAGE_PERCENTAGE}%${NC}"
echo -e "Target Coverage:  ${YELLOW}${MIN_COVERAGE_THRESHOLD}%${NC}"

# Check if coverage meets threshold
if (( $(echo "$COVERAGE_PERCENTAGE >= $MIN_COVERAGE_THRESHOLD" | bc -l) )); then
    echo -e "${GREEN}🎉 Coverage target achieved! ✅${NC}"
    COVERAGE_STATUS="PASSED"
else
    echo -e "${RED}❌ Coverage below target${NC}"
    COVERAGE_GAP=$(echo "$MIN_COVERAGE_THRESHOLD - $COVERAGE_PERCENTAGE" | bc -l)
    echo -e "${YELLOW}📈 Need to improve by: ${COVERAGE_GAP}%${NC}"
    COVERAGE_STATUS="FAILED"
fi

# Generate detailed coverage report
echo -e "${YELLOW}📝 Generating detailed coverage report...${NC}"
cat > "$REPORTS_DIR/coverage_summary.md" << EOF
# Trader App - Test Coverage Report

**Generated:** $(date)
**Target Coverage:** ${MIN_COVERAGE_THRESHOLD}%
**Actual Coverage:** ${COVERAGE_PERCENTAGE}%
**Status:** ${COVERAGE_STATUS}

## Coverage by Test Suite

$(for file in "$REPORTS_DIR"/*_results.json; do
    if [ -f "$file" ]; then
        suite_name=$(basename "$file" _results.json)
        echo "- **${suite_name}:** $(grep -c '"type":"test"' "$file" 2>/dev/null || echo "N/A") tests"
    fi
done)

## Coverage Details

\`\`\`
$COVERAGE_SUMMARY
\`\`\`

## Files with Low Coverage

$(lcov --list "$COVERAGE_DIR/merged_lcov.info" | grep -v "100.0%" | head -20)

## Recommendations

EOF

# Add recommendations based on coverage
if (( $(echo "$COVERAGE_PERCENTAGE < $MIN_COVERAGE_THRESHOLD" | bc -l) )); then
    cat >> "$REPORTS_DIR/coverage_summary.md" << EOF
### To Improve Coverage:

1. **Add missing unit tests** for uncovered functions
2. **Increase edge case testing** for complex logic
3. **Add error handling tests** for exception scenarios
4. **Improve widget testing** for UI components
5. **Add integration tests** for user workflows

### Focus Areas:
$(lcov --list "$COVERAGE_DIR/merged_lcov.info" | grep -E "^SF:" | head -10)
EOF
else
    cat >> "$REPORTS_DIR/coverage_summary.md" << EOF
### Excellent Coverage! 🎉

Your test coverage exceeds the target threshold. Consider:

1. **Maintaining current coverage** during development
2. **Adding performance benchmarks** for critical paths
3. **Expanding E2E test scenarios**
4. **Regular coverage monitoring** in CI/CD
EOF
fi

# Generate test statistics
echo -e "${YELLOW}📊 Generating test statistics...${NC}"
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

for file in "$REPORTS_DIR"/*_results.json; do
    if [ -f "$file" ]; then
        SUITE_TOTAL=$(grep -c '"type":"test"' "$file" 2>/dev/null || echo "0")
        SUITE_PASSED=$(grep -c '"result":"success"' "$file" 2>/dev/null || echo "0")
        SUITE_FAILED=$(grep -c '"result":"error"' "$file" 2>/dev/null || echo "0")
        
        TOTAL_TESTS=$((TOTAL_TESTS + SUITE_TOTAL))
        PASSED_TESTS=$((PASSED_TESTS + SUITE_PASSED))
        FAILED_TESTS=$((FAILED_TESTS + SUITE_FAILED))
    fi
done

echo ""
echo "========================================"
echo -e "${BLUE}🧪 TEST SUMMARY${NC}"
echo "========================================"
echo -e "Total Tests:  ${BLUE}${TOTAL_TESTS}${NC}"
echo -e "Passed Tests: ${GREEN}${PASSED_TESTS}${NC}"
echo -e "Failed Tests: ${RED}${FAILED_TESTS}${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed! ✅${NC}"
else
    echo -e "${RED}❌ Some tests failed${NC}"
fi

# Generate CI-friendly outputs
echo -e "${YELLOW}📝 Generating CI outputs...${NC}"
cat > "$REPORTS_DIR/ci_summary.json" << EOF
{
  "coverage_percentage": $COVERAGE_PERCENTAGE,
  "coverage_target": $MIN_COVERAGE_THRESHOLD,
  "coverage_status": "$COVERAGE_STATUS",
  "total_tests": $TOTAL_TESTS,
  "passed_tests": $PASSED_TESTS,
  "failed_tests": $FAILED_TESTS,
  "test_status": "$([ $FAILED_TESTS -eq 0 ] && echo "PASSED" || echo "FAILED")",
  "report_generated": "$(date -Iseconds)",
  "html_report": "$COVERAGE_DIR/html/index.html"
}
EOF

# Open coverage report (macOS)
if command -v open >/dev/null 2>&1; then
    echo -e "${BLUE}🌐 Opening coverage report in browser...${NC}"
    open "$COVERAGE_DIR/html/index.html"
fi

echo ""
echo "========================================"
echo -e "${BLUE}📁 REPORT LOCATIONS${NC}"
echo "========================================"
echo -e "HTML Coverage: ${GREEN}$COVERAGE_DIR/html/index.html${NC}"
echo -e "Summary Report: ${GREEN}$REPORTS_DIR/coverage_summary.md${NC}"
echo -e "CI Summary: ${GREEN}$REPORTS_DIR/ci_summary.json${NC}"
echo -e "Raw Coverage: ${GREEN}$COVERAGE_DIR/merged_lcov.info${NC}"

# Exit with appropriate code
if [ $FAILED_TESTS -eq 0 ] && (( $(echo "$COVERAGE_PERCENTAGE >= $MIN_COVERAGE_THRESHOLD" | bc -l) )); then
    echo -e "${GREEN}🎉 All tests passed and coverage target achieved!${NC}"
    exit 0
else
    echo -e "${RED}❌ Tests failed or coverage below target${NC}"
    exit 1
fi
EOF