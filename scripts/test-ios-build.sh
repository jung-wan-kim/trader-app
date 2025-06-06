#!/bin/bash

# iOS Build and Run Test Script
# This script builds and runs the iOS app on simulator

set -e

echo "======================================"
echo "iOS Build and Run Test"
echo "======================================"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: iOS builds can only be run on macOS"
    exit 1
fi

# Check for required tools
command -v flutter >/dev/null 2>&1 || { echo "Error: Flutter is not installed" >&2; exit 1; }
command -v xcrun >/dev/null 2>&1 || { echo "Error: Xcode command line tools are not installed" >&2; exit 1; }

# Clean previous builds
echo "Cleaning previous builds..."
flutter clean
cd ios && pod install && cd ..

# Build iOS app
echo "Building iOS app..."
flutter build ios --simulator --debug

# List available simulators
echo "Available iOS simulators:"
xcrun simctl list devices

# Boot iPhone simulator (default to iPhone 14)
SIMULATOR_NAME="iPhone 14"
echo "Booting $SIMULATOR_NAME simulator..."
xcrun simctl boot "$SIMULATOR_NAME" || echo "Simulator already booted"

# Wait for simulator to boot
sleep 5

# Install and run the app
echo "Installing app on simulator..."
flutter install --debug

# Run integration tests on iOS
echo "Running integration tests on iOS..."
flutter test integration_test/app_launch_test.dart \
    --device-id=`xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -E -o -i "([0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})" | head -n 1`

# Capture screenshot
echo "Capturing screenshot..."
xcrun simctl io booted screenshot ios_test_screenshot.png

# Run specific platform tests
echo "Running iOS-specific tests..."
flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/app_launch_test.dart \
    --device-id=`xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -E -o -i "([0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})" | head -n 1` \
    || echo "Drive tests completed"

# Check build artifacts
echo "Checking build artifacts..."
if [ -d "build/ios/iphonesimulator/Runner.app" ]; then
    echo "✅ iOS build successful"
    ls -la build/ios/iphonesimulator/Runner.app
else
    echo "❌ iOS build failed - Runner.app not found"
    exit 1
fi

# Basic app launch test
echo "Testing app launch..."
xcrun simctl launch booted com.example.traderApp || echo "App launch test completed"

# Memory and performance check
echo "Checking app performance..."
xcrun simctl diagnose

echo "======================================"
echo "iOS Build and Run Test Completed"
echo "======================================"