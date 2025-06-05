import 'package:flutter/material.dart';
import 'colors.dart';

/// Trader App 타이포그래피 시스템
/// 
/// 금융 앱의 특성을 고려한 명확하고 가독성 높은 타이포그래피
/// - 숫자 표시에 최적화된 폰트 설정
/// - 계층적 정보 구조를 위한 다양한 텍스트 스타일
/// - 다크/라이트 모드 대응
class AppTypography {
  // 폰트 패밀리
  static const String primaryFont = 'SF Pro Display'; // iOS
  static const String secondaryFont = 'Roboto'; // Android
  static const String numberFont = 'SF Mono'; // 숫자 전용 (등폭 폰트)
  
  // 폰트 사이즈 스케일
  static const double sizeXXS = 10.0;
  static const double sizeXS = 12.0;
  static const double sizeS = 14.0;
  static const double sizeM = 16.0;
  static const double sizeL = 18.0;
  static const double sizeXL = 20.0;
  static const double sizeXXL = 24.0;
  static const double sizeXXXL = 32.0;
  static const double sizeJumbo = 40.0;
  
  // 폰트 웨이트
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;
  
  // 라인 높이
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;
  static const double lineHeightLoose = 2.0;
  
  // 자간 (Letter Spacing)
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  static const double letterSpacingExtraWide = 1.0;
  
  // 헤딩 스타일
  static TextStyle h1({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: sizeXXXL,
    fontWeight: weightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: color ?? AppColors.textPrimary,
  );
  
  static TextStyle h2({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: sizeXXL,
    fontWeight: weightSemiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: color ?? AppColors.textPrimary,
  );
  
  static TextStyle h3({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: sizeXL,
    fontWeight: weightSemiBold,
    height: lineHeightNormal,
    color: color ?? AppColors.textPrimary,
  );
  
  static TextStyle h4({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: sizeL,
    fontWeight: weightMedium,
    height: lineHeightNormal,
    color: color ?? AppColors.textPrimary,
  );
  
  // 바디 텍스트 스타일
  static TextStyle bodyLarge({Color? color}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: sizeL,
    fontWeight: weightRegular,
    height: lineHeightRelaxed,
    color: color ?? AppColors.textPrimary,
  );
  
  static TextStyle bodyMedium({Color? color}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: sizeM,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    color: color ?? AppColors.textPrimary,
  );
  
  static TextStyle bodySmall({Color? color}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: sizeS,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    color: color ?? AppColors.textSecondary,
  );
  
  // 캡션 스타일
  static TextStyle caption({Color? color}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: sizeXS,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    color: color ?? AppColors.textTertiary,
  );
  
  static TextStyle overline({Color? color}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: sizeXXS,
    fontWeight: weightMedium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingExtraWide,
    color: color ?? AppColors.textTertiary,
  );
  
  // 숫자 전용 스타일 (주가, 수익률 등)
  static TextStyle numberLarge({Color? color, bool isBold = false}) => TextStyle(
    fontFamily: numberFont,
    fontSize: sizeXXL,
    fontWeight: isBold ? weightBold : weightMedium,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
    color: color ?? AppColors.textPrimary,
  );
  
  static TextStyle numberMedium({Color? color, bool isBold = false}) => TextStyle(
    fontFamily: numberFont,
    fontSize: sizeL,
    fontWeight: isBold ? weightSemiBold : weightRegular,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
    color: color ?? AppColors.textPrimary,
  );
  
  static TextStyle numberSmall({Color? color}) => TextStyle(
    fontFamily: numberFont,
    fontSize: sizeM,
    fontWeight: weightRegular,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
    color: color ?? AppColors.textSecondary,
  );
  
  // 수익률 표시 전용 스타일
  static TextStyle profitLoss({required bool isProfit, bool isLarge = false}) => TextStyle(
    fontFamily: numberFont,
    fontSize: isLarge ? sizeXL : sizeM,
    fontWeight: weightSemiBold,
    height: lineHeightTight,
    color: isProfit ? AppColors.bullish : AppColors.bearish,
  );
  
  // 버튼 텍스트 스타일
  static TextStyle buttonLarge({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: sizeL,
    fontWeight: weightSemiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingWide,
    color: color ?? Colors.white,
  );
  
  static TextStyle buttonMedium({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: sizeM,
    fontWeight: weightMedium,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
    color: color ?? Colors.white,
  );
  
  static TextStyle buttonSmall({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: sizeS,
    fontWeight: weightMedium,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
    color: color ?? Colors.white,
  );
  
  // 링크 스타일
  static TextStyle link({Color? color, double? fontSize}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: fontSize ?? sizeM,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    color: color ?? AppColors.primary,
    decoration: TextDecoration.underline,
  );
  
  // 특수 스타일
  static TextStyle ticker() => TextStyle(
    fontFamily: numberFont,
    fontSize: sizeL,
    fontWeight: weightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingWide,
    color: AppColors.textPrimary,
  );
  
  static TextStyle badge({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: sizeXXS,
    fontWeight: weightSemiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingWide,
    color: color ?? Colors.white,
  );
  
  // 구독 티어 표시 스타일
  static TextStyle subscriptionTier({required String tier}) {
    Color color;
    switch (tier.toLowerCase()) {
      case 'gold':
      case 'professional':
        color = AppColors.gold;
        break;
      case 'silver':
      case 'premium':
        color = AppColors.primary;
        break;
      default:
        color = AppColors.textSecondary;
    }
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: sizeS,
      fontWeight: weightSemiBold,
      height: lineHeightTight,
      letterSpacing: letterSpacingWide,
      color: color,
    );
  }
}