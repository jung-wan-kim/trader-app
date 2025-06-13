#!/bin/bash

# UI 테스트 실행 스크립트
# 사용법: ./scripts/run_ui_tests.sh [옵션]

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 기본 설정
TEST_TYPE="all"
PLATFORM="all"
UPDATE_GOLDENS=false
COVERAGE=false
VERBOSE=false

# 도움말 표시
show_help() {
    echo "사용법: $0 [옵션]"
    echo ""
    echo "옵션:"
    echo "  -t, --type <type>       테스트 타입 (all, critical, happy, edge, negative, a11y, responsive, performance, platform, visual)"
    echo "  -p, --platform <platform> 플랫폼 (all, ios, android, web)"
    echo "  -u, --update-goldens    골든 파일 업데이트"
    echo "  -c, --coverage          커버리지 리포트 생성"
    echo "  -v, --verbose           상세 출력"
    echo "  -h, --help              도움말 표시"
    echo ""
    echo "예시:"
    echo "  $0 -t critical -p ios    # iOS에서 Critical Path 테스트만 실행"
    echo "  $0 -c                    # 모든 테스트 실행 후 커버리지 리포트 생성"
    echo "  $0 -u -t visual          # Visual Regression 테스트 골든 파일 업데이트"
}

# 옵션 파싱
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            TEST_TYPE="$2"
            shift 2
            ;;
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -u|--update-goldens)
            UPDATE_GOLDENS=true
            shift
            ;;
        -c|--coverage)
            COVERAGE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}알 수 없는 옵션: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# 테스트 파일 매핑
declare -A TEST_FILES=(
    ["critical"]="test/ui_automation/scenarios/new_user_journey_test.dart test/ui_automation/critical_path_test.dart"
    ["happy"]="test/ui_automation/scenarios/happy_path_scenarios.dart"
    ["edge"]="test/ui_automation/scenarios/edge_case_scenarios.dart"
    ["negative"]="test/ui_automation/scenarios/negative_test_scenarios.dart"
    ["a11y"]="test/ui_automation/scenarios/accessibility_test_scenarios.dart"
    ["responsive"]="test/ui_automation/scenarios/responsive_design_test.dart"
    ["performance"]="test/ui_automation/scenarios/performance_test.dart"
    ["platform"]="test/ui_automation/scenarios/platform_specific_test.dart"
    ["visual"]="test/ui_automation/scenarios/visual_regression_test.dart"
    ["all"]="test/ui_automation/run_all_ui_tests.dart"
)

# 테스트 파일 결정
if [[ -z "${TEST_FILES[$TEST_TYPE]}" ]]; then
    echo -e "${RED}유효하지 않은 테스트 타입: $TEST_TYPE${NC}"
    exit 1
fi

TEST_FILE="${TEST_FILES[$TEST_TYPE]}"

echo -e "${BLUE}=== Trader App UI 테스트 실행 ===${NC}"
echo -e "테스트 타입: ${YELLOW}$TEST_TYPE${NC}"
echo -e "플랫폼: ${YELLOW}$PLATFORM${NC}"
echo ""

# Flutter 의존성 설치
echo -e "${BLUE}📦 의존성 설치 중...${NC}"
flutter pub get

# 빌드 러너 실행
echo -e "${BLUE}🔨 코드 생성 중...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs

# 골든 파일 업데이트 모드 설정
if [ "$UPDATE_GOLDENS" = true ]; then
    export UPDATE_GOLDENS=true
    echo -e "${YELLOW}⚠️  골든 파일 업데이트 모드 활성화됨${NC}"
fi

# 테스트 결과 디렉토리 생성
mkdir -p test_results/screenshots
mkdir -p test/ui_automation/goldens/failures

# 플랫폼별 테스트 실행
run_tests() {
    local platform=$1
    local device=""
    
    case $platform in
        ios)
            device="iPhone 14 Pro"
            echo -e "${BLUE}🍎 iOS 테스트 실행 중...${NC}"
            ;;
        android)
            device="Pixel 6"
            echo -e "${BLUE}🤖 Android 테스트 실행 중...${NC}"
            ;;
        web)
            device="chrome"
            echo -e "${BLUE}🌐 Web 테스트 실행 중...${NC}"
            ;;
    esac
    
    # 테스트 명령어 구성
    CMD="flutter test $TEST_FILE"
    
    if [ ! -z "$device" ]; then
        CMD="$CMD -d \"$device\""
    fi
    
    if [ "$COVERAGE" = true ]; then
        CMD="$CMD --coverage"
    fi
    
    if [ "$VERBOSE" = true ]; then
        CMD="$CMD -v"
    fi
    
    # 테스트 실행
    if eval $CMD; then
        echo -e "${GREEN}✅ $platform 테스트 성공!${NC}"
        return 0
    else
        echo -e "${RED}❌ $platform 테스트 실패!${NC}"
        return 1
    fi
}

# 테스트 실행
FAILED_PLATFORMS=()

if [ "$PLATFORM" = "all" ]; then
    for p in ios android web; do
        if ! run_tests $p; then
            FAILED_PLATFORMS+=($p)
        fi
    done
else
    if ! run_tests $PLATFORM; then
        FAILED_PLATFORMS+=($PLATFORM)
    fi
fi

# 커버리지 리포트 생성
if [ "$COVERAGE" = true ]; then
    echo -e "${BLUE}📊 커버리지 리포트 생성 중...${NC}"
    
    # HTML 리포트 생성
    if command -v genhtml &> /dev/null; then
        genhtml coverage/lcov.info -o coverage/html
        echo -e "${GREEN}✅ HTML 커버리지 리포트 생성됨: coverage/html/index.html${NC}"
    fi
    
    # 커버리지 요약 표시
    if [ -f coverage/lcov.info ]; then
        echo -e "${BLUE}📈 커버리지 요약:${NC}"
        # lcov 요약 추출 (간단한 버전)
        lines=$(grep -o "LF:[0-9]*" coverage/lcov.info | cut -d':' -f2 | paste -sd+ | bc)
        hits=$(grep -o "LH:[0-9]*" coverage/lcov.info | cut -d':' -f2 | paste -sd+ | bc)
        if [ $lines -gt 0 ]; then
            coverage=$(echo "scale=2; $hits * 100 / $lines" | bc)
            echo -e "전체 라인 커버리지: ${YELLOW}$coverage%${NC}"
        fi
    fi
fi

# 결과 요약
echo ""
echo -e "${BLUE}=== 테스트 결과 요약 ===${NC}"

if [ ${#FAILED_PLATFORMS[@]} -eq 0 ]; then
    echo -e "${GREEN}🎉 모든 테스트가 성공적으로 완료되었습니다!${NC}"
    
    # 성능 메트릭 표시 (performance 테스트인 경우)
    if [ "$TEST_TYPE" = "performance" ] || [ "$TEST_TYPE" = "all" ]; then
        echo -e "${BLUE}📊 성능 메트릭은 콘솔 출력을 확인하세요.${NC}"
    fi
    
    exit 0
else
    echo -e "${RED}❌ 다음 플랫폼에서 테스트가 실패했습니다:${NC}"
    for platform in "${FAILED_PLATFORMS[@]}"; do
        echo -e "  - ${RED}$platform${NC}"
    done
    
    echo ""
    echo -e "${YELLOW}💡 실패한 스크린샷은 다음 경로에서 확인할 수 있습니다:${NC}"
    echo -e "  - test_results/screenshots/"
    echo -e "  - test/ui_automation/goldens/failures/"
    
    exit 1
fi