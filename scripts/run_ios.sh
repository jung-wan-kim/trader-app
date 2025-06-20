#!/bin/bash

# iOS 실행 스크립트
# Trader App iOS 실행을 위한 자동화 스크립트

set -e  # 에러 발생 시 스크립트 중단

echo "🚀 Trader App iOS 실행 스크립트"
echo "================================"

# 프로젝트 루트 디렉토리로 이동
cd "$(dirname "$0")/.."

# Flutter 설치 확인
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter가 설치되지 않았습니다."
    echo "📥 Flutter 설치 방법:"
    echo "1. https://docs.flutter.dev/get-started/install/macos 방문"
    echo "2. Flutter SDK 다운로드 및 설치"
    echo "3. PATH에 Flutter 추가"
    echo ""
    echo "💡 빠른 설치 (Homebrew):"
    echo "brew install --cask flutter"
    exit 1
fi

# Flutter Doctor 실행
echo "🔍 Flutter 환경 확인..."
flutter doctor

# iOS 개발 환경 확인
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode가 설치되지 않았습니다."
    echo "📥 App Store에서 Xcode를 설치하세요."
    exit 1
fi

# CocoaPods 설치 확인
if ! command -v pod &> /dev/null; then
    echo "❌ CocoaPods가 설치되지 않았습니다."
    echo "📥 CocoaPods 설치:"
    echo "sudo gem install cocoapods"
    exit 1
fi

# 환경 변수 파일 확인
if [ ! -f "config/development.env" ]; then
    echo "⚠️  환경 변수 파일이 없습니다."
    echo "📄 config/development.env 파일을 생성하세요."
    echo ""
    echo "예제 파일을 복사합니다..."
    cp config/development.env.example config/development.env
    echo "✅ config/development.env 파일이 생성되었습니다."
    echo "🔧 실제 Supabase 키를 입력하세요."
    echo ""
fi

# Flutter 의존성 설치
echo "📦 Flutter 의존성 설치 중..."
flutter pub get

# iOS 의존성 설치
echo "🍎 iOS 의존성 설치 중..."
cd ios
pod install
cd ..

# 사용 가능한 디바이스 확인
echo "📱 사용 가능한 디바이스:"
flutter devices

# iOS 시뮬레이터 실행
echo "🎮 iOS 시뮬레이터 실행 중..."
open -a Simulator

# 잠시 대기 (시뮬레이터 부팅 시간)
echo "⏳ 시뮬레이터 부팅 대기 중 (5초)..."
sleep 5

# Flutter 앱 실행
echo "🚀 iOS에서 Trader App 실행 중..."
flutter run -d ios --debug

echo "✅ iOS 실행 완료!"