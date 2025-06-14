#!/bin/bash

# Flutter Integration Test Runner
# This script runs integration tests for the trader-app

echo "🚀 Starting Flutter Integration Tests..."
echo "=================================="

# Clean previous test results
echo "🧹 Cleaning previous test results..."
flutter clean
flutter pub get

# Run integration tests
echo ""
echo "🧪 Running language selection tests..."
flutter test integration_test/language_selection_test.dart --verbose

# Check if tests passed
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All tests passed!"
else
    echo ""
    echo "❌ Some tests failed. Please check the output above."
    exit 1
fi

echo ""
echo "📊 Test execution complete!"
echo "=================================="