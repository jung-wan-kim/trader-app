#!/bin/bash

# Trader App Test Automation Script
# This script runs various test suites and generates reports

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test result variables
UNIT_TEST_RESULT=0
WIDGET_TEST_RESULT=0
INTEGRATION_TEST_RESULT=0
COVERAGE_RESULT=0

echo "🚀 Starting Trader App Test Automation"
echo "======================================"

# Function to print section headers
print_section() {
    echo -e "\n${YELLOW}>>> $1${NC}"
    echo "------------------------------"
}

# Function to check test results
check_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ $2 passed${NC}"
    else
        echo -e "${RED}✗ $2 failed${NC}"
    fi
}

# Clean previous test results
print_section "Cleaning previous test results"
rm -rf coverage/
rm -f test_results.json

# Get Flutter dependencies
print_section "Getting dependencies"
flutter pub get

# Run analyzer
print_section "Running Flutter Analyzer"
flutter analyze || true

# Run unit tests
print_section "Running Unit Tests"
flutter test test/unit/ --coverage || UNIT_TEST_RESULT=$?
check_result $UNIT_TEST_RESULT "Unit tests"

# Run widget tests
print_section "Running Widget Tests"
flutter test test/widget/ test/widget_test.dart --coverage || WIDGET_TEST_RESULT=$?
check_result $WIDGET_TEST_RESULT "Widget tests"

# Run integration tests (skip performance tests due to timeout issues)
print_section "Running Integration Tests"
flutter test test/integration/ --coverage || INTEGRATION_TEST_RESULT=$?
check_result $INTEGRATION_TEST_RESULT "Integration tests"

# Generate coverage report
if [ -d "coverage" ]; then
    print_section "Generating Coverage Report"
    # Install lcov if not present
    if ! command -v lcov &> /dev/null; then
        echo "Installing lcov..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install lcov
        else
            sudo apt-get install -y lcov
        fi
    fi
    
    # Generate HTML coverage report
    genhtml coverage/lcov.info -o coverage/html || COVERAGE_RESULT=$?
    check_result $COVERAGE_RESULT "Coverage report generation"
    
    # Display coverage summary
    echo -e "\n${YELLOW}Coverage Summary:${NC}"
    lcov --summary coverage/lcov.info 2>/dev/null || true
fi

# Run specific test suites based on arguments
if [ "$1" == "full" ]; then
    print_section "Running Full App Flow Test"
    flutter test integration_test/full_app_flow_test.dart
elif [ "$1" == "performance" ]; then
    print_section "Running Performance Tests"
    flutter test test/performance/ --timeout 120s
fi

# Generate test results summary
print_section "Test Results Summary"
echo "===================="
check_result $UNIT_TEST_RESULT "Unit Tests"
check_result $WIDGET_TEST_RESULT "Widget Tests"  
check_result $INTEGRATION_TEST_RESULT "Integration Tests"
check_result $COVERAGE_RESULT "Coverage Report"

# Calculate overall result
OVERALL_RESULT=$((UNIT_TEST_RESULT + WIDGET_TEST_RESULT + INTEGRATION_TEST_RESULT))

if [ $OVERALL_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All tests passed successfully!${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Some tests failed. Please check the logs above.${NC}"
    exit 1
fi