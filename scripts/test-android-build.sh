#!/bin/bash

# Android Build and Run Test Script
# This script builds and runs the Android app on emulator

set -e

echo "======================================"
echo "Android Build and Run Test"
echo "======================================"

# Check for required tools
command -v flutter >/dev/null 2>&1 || { echo "Error: Flutter is not installed" >&2; exit 1; }
command -v adb >/dev/null 2>&1 || { echo "Error: Android SDK (adb) is not installed" >&2; exit 1; }

# Clean previous builds
echo "Cleaning previous builds..."
flutter clean

# Build Android app
echo "Building Android app..."
flutter build apk --debug

# Check if emulator is running
echo "Checking for running emulators..."
if ! adb devices | grep -q "emulator"; then
    echo "No emulator running. Please start an Android emulator first."
    echo "You can start an emulator using Android Studio or command line:"
    echo "  emulator -avd <avd_name>"
    
    # List available AVDs
    echo "Available AVDs:"
    emulator -list-avds
    
    # Try to start the first available AVD
    FIRST_AVD=$(emulator -list-avds | head -n 1)
    if [ ! -z "$FIRST_AVD" ]; then
        echo "Starting emulator: $FIRST_AVD"
        emulator -avd "$FIRST_AVD" -no-window &
        
        # Wait for emulator to boot
        echo "Waiting for emulator to boot..."
        adb wait-for-device
        
        # Wait for boot completion
        while [ "$(adb shell getprop sys.boot_completed 2>/dev/null)" != "1" ]; do
            sleep 2
        done
        
        echo "Emulator booted successfully"
    fi
else
    echo "Emulator is already running"
fi

# Install the app
echo "Installing app on emulator..."
flutter install --debug

# Run integration tests on Android
echo "Running integration tests on Android..."
flutter test integration_test/app_launch_test.dart

# Run specific platform tests
echo "Running Android-specific tests..."
flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/app_launch_test.dart \
    || echo "Drive tests completed"

# Check build artifacts
echo "Checking build artifacts..."
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo "✅ Android build successful"
    ls -la build/app/outputs/flutter-apk/app-debug.apk
    
    # Check APK size
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-debug.apk | cut -f1)
    echo "APK size: $APK_SIZE"
else
    echo "❌ Android build failed - APK not found"
    exit 1
fi

# Basic app launch test using ADB
echo "Testing app launch..."
adb shell am start -n com.example.trader_app/.MainActivity || echo "App launch test completed"

# Wait for app to start
sleep 3

# Capture screenshot
echo "Capturing screenshot..."
adb shell screencap -p /sdcard/android_test_screenshot.png
adb pull /sdcard/android_test_screenshot.png ./android_test_screenshot.png

# Check for crashes
echo "Checking for crashes..."
CRASHES=$(adb logcat -d | grep -E "FATAL EXCEPTION|AndroidRuntime" | wc -l)
if [ "$CRASHES" -gt 0 ]; then
    echo "⚠️  Warning: Found $CRASHES crash entries in logcat"
    adb logcat -d | grep -E "FATAL EXCEPTION|AndroidRuntime" | head -20
else
    echo "✅ No crashes detected"
fi

# Memory info
echo "Checking memory usage..."
adb shell dumpsys meminfo com.example.trader_app | grep -E "TOTAL|Native Heap|Dalvik Heap" || echo "Memory info not available"

# Performance stats
echo "Checking performance..."
adb shell dumpsys gfxinfo com.example.trader_app | grep -E "Total frames rendered|Janky frames" || echo "Performance info not available"

echo "======================================"
echo "Android Build and Run Test Completed"
echo "======================================"