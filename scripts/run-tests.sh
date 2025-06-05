#!/bin/bash

# Trader App Test Runner Script
# This script runs all tests and generates reports

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

# Function to run tests
run_tests() {
    test_type=$1
    print_color "$BLUE" "\n🧪 Running $test_type tests..."
    
    case $test_type in
        "unit")
            flutter test test/unit --reporter compact
            ;;
        "widget")
            flutter test test/widget --reporter compact
            ;;
        "integration")
            flutter test test/integration --reporter compact
            ;;
        "security")
            flutter test test/security --reporter compact
            ;;
        "performance")
            flutter test test/performance --reporter compact
            ;;
        "e2e")
            flutter test integration_test --reporter compact
            ;;
        *)
            print_color "$RED" "Unknown test type: $test_type"
            return 1
            ;;
    esac
}

# Main script
print_color "$GREEN" "🚀 Trader App Test Suite"
print_color "$GREEN" "========================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_color "$RED" "Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Parse command line arguments
RUN_ALL=true
RUN_UNIT=false
RUN_WIDGET=false
RUN_INTEGRATION=false
RUN_SECURITY=false
RUN_PERFORMANCE=false
RUN_E2E=false
RUN_COVERAGE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --unit)
            RUN_UNIT=true
            RUN_ALL=false
            shift
            ;;
        --widget)
            RUN_WIDGET=true
            RUN_ALL=false
            shift
            ;;
        --integration)
            RUN_INTEGRATION=true
            RUN_ALL=false
            shift
            ;;
        --security)
            RUN_SECURITY=true
            RUN_ALL=false
            shift
            ;;
        --performance)
            RUN_PERFORMANCE=true
            RUN_ALL=false
            shift
            ;;
        --e2e)
            RUN_E2E=true
            RUN_ALL=false
            shift
            ;;
        --coverage)
            RUN_COVERAGE=true
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --unit         Run unit tests only"
            echo "  --widget       Run widget tests only"
            echo "  --integration  Run integration tests only"
            echo "  --security     Run security tests only"
            echo "  --performance  Run performance tests only"
            echo "  --e2e          Run E2E tests only"
            echo "  --coverage     Generate code coverage report"
            echo "  --help         Show this help message"
            echo ""
            echo "By default, all tests are run if no options are specified."
            exit 0
            ;;
        *)
            print_color "$RED" "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Get dependencies
print_color "$BLUE" "📦 Getting dependencies..."
flutter pub get

# Clean previous test results
rm -rf coverage
mkdir -p coverage

# Track test results
FAILED_TESTS=""

# Run tests based on flags
if [ "$RUN_ALL" = true ] || [ "$RUN_UNIT" = true ]; then
    if ! run_tests "unit"; then
        FAILED_TESTS="$FAILED_TESTS unit"
    fi
fi

if [ "$RUN_ALL" = true ] || [ "$RUN_WIDGET" = true ]; then
    if ! run_tests "widget"; then
        FAILED_TESTS="$FAILED_TESTS widget"
    fi
fi

if [ "$RUN_ALL" = true ] || [ "$RUN_INTEGRATION" = true ]; then
    if ! run_tests "integration"; then
        FAILED_TESTS="$FAILED_TESTS integration"
    fi
fi

if [ "$RUN_ALL" = true ] || [ "$RUN_SECURITY" = true ]; then
    if ! run_tests "security"; then
        FAILED_TESTS="$FAILED_TESTS security"
    fi
fi

if [ "$RUN_ALL" = true ] || [ "$RUN_PERFORMANCE" = true ]; then
    if ! run_tests "performance"; then
        FAILED_TESTS="$FAILED_TESTS performance"
    fi
fi

if [ "$RUN_E2E" = true ]; then
    if ! run_tests "e2e"; then
        FAILED_TESTS="$FAILED_TESTS e2e"
    fi
fi

# Generate coverage report if requested
if [ "$RUN_COVERAGE" = true ]; then
    print_color "$BLUE" "\n📊 Generating code coverage report..."
    flutter test --coverage
    
    # Check if lcov is installed
    if command -v lcov &> /dev/null; then
        # Remove generated files from coverage
        lcov --remove coverage/lcov.info 'lib/*/*.g.dart' 'lib/*/*.freezed.dart' -o coverage/lcov.info
        
        # Generate HTML report
        if command -v genhtml &> /dev/null; then
            genhtml coverage/lcov.info -o coverage/html --quiet
            print_color "$GREEN" "✅ Coverage report generated at coverage/html/index.html"
            
            # Show coverage summary
            covered_lines=$(lcov --summary coverage/lcov.info 2>&1 | grep -E "lines\.\.\.\.\.\.: [0-9]+\.[0-9]+%" | sed 's/.*: \([0-9]*\.[0-9]*\)%.*/\1/')
            if [ ! -z "$covered_lines" ]; then
                print_color "$BLUE" "📈 Line coverage: ${covered_lines}%"
                
                # Check if coverage meets minimum threshold
                if (( $(echo "$covered_lines >= 80" | bc -l) )); then
                    print_color "$GREEN" "✅ Coverage meets the minimum threshold of 80%"
                else
                    print_color "$YELLOW" "⚠️  Coverage is below the minimum threshold of 80%"
                fi
            fi
        else
            print_color "$YELLOW" "⚠️  genhtml not found. Install lcov to generate HTML reports."
        fi
    else
        print_color "$YELLOW" "⚠️  lcov not found. Install lcov for detailed coverage reports."
    fi
fi

# Summary
print_color "$GREEN" "\n========================"
print_color "$GREEN" "📊 Test Summary"
print_color "$GREEN" "========================"

if [ -z "$FAILED_TESTS" ]; then
    print_color "$GREEN" "✅ All tests passed! 🎉"
    exit 0
else
    print_color "$RED" "❌ Failed tests:$FAILED_TESTS"
    print_color "$YELLOW" "Please check the test output above for details."
    exit 1
fi