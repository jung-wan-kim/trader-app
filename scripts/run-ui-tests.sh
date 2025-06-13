#!/bin/bash

# UI 통합 테스트 실행 스크립트

echo "=== UI Integration Tests Runner ==="
echo ""

# 색상 코드
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 사용 가능한 디바이스 확인
echo -e "${YELLOW}Available devices:${NC}"
flutter devices

echo ""
echo -e "${YELLOW}Select device for UI testing:${NC}"
echo "1) iOS Simulator"
echo "2) Android Emulator"
echo "3) Physical iOS Device"
echo "4) Physical Android Device"
echo "5) Skip UI Tests"

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo -e "${GREEN}Starting iOS Simulator...${NC}"
        open -a Simulator
        sleep 5
        
        # iOS 시뮬레이터 ID 찾기
        DEVICE_ID=$(xcrun simctl list devices | grep "iPhone" | grep "Booted" | head -1 | awk -F '[()]' '{print $2}')
        
        if [ -z "$DEVICE_ID" ]; then
            echo -e "${RED}No iOS Simulator is running. Please start one manually.${NC}"
            exit 1
        fi
        
        echo -e "${GREEN}Running UI tests on iOS Simulator...${NC}"
        flutter test integration_test/ui_integration_test.dart -d $DEVICE_ID
        ;;
        
    2)
        echo -e "${GREEN}Starting Android Emulator...${NC}"
        # Android 에뮬레이터 실행 (이름은 환경에 따라 다를 수 있음)
        emulator -avd Pixel_7_API_33 &
        sleep 10
        
        echo -e "${GREEN}Running UI tests on Android Emulator...${NC}"
        flutter test integration_test/ui_integration_test.dart -d emulator-5554
        ;;
        
    3)
        echo -e "${GREEN}Running UI tests on Physical iOS Device...${NC}"
        # 연결된 iOS 기기 ID 찾기
        DEVICE_ID=$(flutter devices | grep "ios" | head -1 | awk '{print $2}')
        
        if [ -z "$DEVICE_ID" ]; then
            echo -e "${RED}No iOS device connected.${NC}"
            exit 1
        fi
        
        flutter test integration_test/ui_integration_test.dart -d $DEVICE_ID
        ;;
        
    4)
        echo -e "${GREEN}Running UI tests on Physical Android Device...${NC}"
        # 연결된 Android 기기 ID 찾기
        DEVICE_ID=$(flutter devices | grep "android" | head -1 | awk '{print $2}')
        
        if [ -z "$DEVICE_ID" ]; then
            echo -e "${RED}No Android device connected.${NC}"
            exit 1
        fi
        
        flutter test integration_test/ui_integration_test.dart -d $DEVICE_ID
        ;;
        
    5)
        echo -e "${YELLOW}Skipping UI tests...${NC}"
        exit 0
        ;;
        
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

# 테스트 결과 확인
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ UI tests passed successfully!${NC}"
else
    echo -e "${RED}✗ UI tests failed!${NC}"
    exit 1
fi

# 기존 integration 테스트도 실행
echo ""
echo -e "${YELLOW}Running existing integration tests...${NC}"
flutter test integration_test/