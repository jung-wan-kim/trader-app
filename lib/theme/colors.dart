import 'package:flutter/material.dart';

/// Trader App 컬러 팔레트
/// 
/// 주식 트레이딩 앱의 특성을 고려한 컬러 시스템
/// - 상승/하락 표시를 위한 명확한 색상 구분
/// - 다크 모드 지원을 위한 대비가 높은 색상
/// - 접근성을 고려한 WCAG AA 기준 충족
class AppColors {
  // 브랜드 컬러
  static const Color primary = Color(0xFF1E3A8A); // 딥 블루 - 신뢰와 전문성
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E40AF);
  
  // 상승/하락 컬러 (주식 차트용)
  static const Color bullish = Color(0xFF10B981); // 상승 - 에메랄드 그린
  static const Color bullishLight = Color(0xFF34D399);
  static const Color bullishDark = Color(0xFF059669);
  
  static const Color bearish = Color(0xFFEF4444); // 하락 - 레드
  static const Color bearishLight = Color(0xFFF87171);
  static const Color bearishDark = Color(0xFFDC2626);
  
  // 중립 컬러
  static const Color neutral = Color(0xFF6B7280); // 변동 없음
  static const Color neutralLight = Color(0xFF9CA3AF);
  static const Color neutralDark = Color(0xFF4B5563);
  
  // 배경 컬러
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1F2937);
  
  // 텍스트 컬러
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);
  
  // 상태 컬러
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // 특수 용도 컬러
  static const Color gold = Color(0xFFFBBF24); // 프리미엄 구독
  static const Color silver = Color(0xFF9CA3AF); // 베이직 구독
  static const Color bronze = Color(0xFFB45309); // 무료 티어
  
  // 차트 컬러 세트
  static const List<Color> chartColors = [
    Color(0xFF3B82F6), // 블루
    Color(0xFF10B981), // 그린
    Color(0xFFF59E0B), // 앰버
    Color(0xFF8B5CF6), // 퍼플
    Color(0xFFEC4899), // 핑크
    Color(0xFF06B6D4), // 시안
  ];
  
  // 그라디언트
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryDark],
  );
  
  static const LinearGradient bullishGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [bullishDark, bullishLight],
  );
  
  static const LinearGradient bearishGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bearishDark, bearishLight],
  );
  
  // 투명도 레벨
  static const double opacity10 = 0.1;
  static const double opacity20 = 0.2;
  static const double opacity40 = 0.4;
  static const double opacity60 = 0.6;
  static const double opacity80 = 0.8;
  
  // 다크 모드 대응 함수
  static Color getTextColor(BuildContext context, {bool isSecondary = false, bool isTertiary = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isTertiary) {
      return isDark ? textTertiaryDark : textTertiary;
    } else if (isSecondary) {
      return isDark ? textSecondaryDark : textSecondary;
    }
    return isDark ? textPrimaryDark : textPrimary;
  }
  
  static Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? backgroundDark : backgroundLight;
  }
  
  static Color getSurfaceColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? surfaceDark : surfaceLight;
  }
}