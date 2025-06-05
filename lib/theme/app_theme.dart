import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';

/// Trader App 테마 설정
/// 
/// 라이트/다크 모드를 지원하는 통합 테마 시스템
class AppTheme {
  // 공통 설정값
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  static const double borderRadiusRound = 24.0;
  
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  static const EdgeInsets paddingXSmall = EdgeInsets.all(4.0);
  static const EdgeInsets paddingSmall = EdgeInsets.all(8.0);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLarge = EdgeInsets.all(24.0);
  static const EdgeInsets paddingXLarge = EdgeInsets.all(32.0);
  
  // 라이트 테마
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      
      // 컬러 스킴
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.bullish,
        secondaryContainer: AppColors.bullishLight,
        tertiary: AppColors.gold,
        error: AppColors.error,
        errorContainer: AppColors.bearishLight,
        background: AppColors.backgroundLight,
        surface: AppColors.surfaceLight,
        surfaceVariant: AppColors.neutralLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      
      // 앱바 테마
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.h4(color: AppColors.textPrimary),
        toolbarTextStyle: AppTypography.bodyMedium(),
      ),
      
      // 엘리베이티드 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: elevationLow,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: AppTypography.buttonMedium(),
        ),
      ),
      
      // 텍스트 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: AppTypography.buttonMedium(color: AppColors.primary),
        ),
      ),
      
      // 아웃라인 버튼 테마
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: AppTypography.buttonMedium(color: AppColors.primary),
        ),
      ),
      
      // 카드 테마
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: elevationLow,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
      ),
      
      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutralLight.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.neutralLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.neutralLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.bodyMedium(color: AppColors.textSecondary),
        hintStyle: AppTypography.bodyMedium(color: AppColors.textTertiary),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // 바텀 네비게이션 바 테마
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: AppTypography.caption(color: AppColors.primary),
        unselectedLabelStyle: AppTypography.caption(),
        type: BottomNavigationBarType.fixed,
      ),
      
      // 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        contentTextStyle: AppTypography.bodyMedium(color: AppColors.textPrimaryDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // 텍스트 테마
      textTheme: TextTheme(
        displayLarge: AppTypography.h1(),
        displayMedium: AppTypography.h2(),
        displaySmall: AppTypography.h3(),
        headlineMedium: AppTypography.h4(),
        bodyLarge: AppTypography.bodyLarge(),
        bodyMedium: AppTypography.bodyMedium(),
        bodySmall: AppTypography.bodySmall(),
        labelLarge: AppTypography.buttonMedium(),
        labelSmall: AppTypography.caption(),
      ),
    );
  }
  
  // 다크 테마
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      
      // 컬러 스킴
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.bullish,
        secondaryContainer: AppColors.bullishDark,
        tertiary: AppColors.gold,
        error: AppColors.bearish,
        errorContainer: AppColors.bearishDark,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        surfaceVariant: AppColors.neutralDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),
      
      // 앱바 테마
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.h4(color: AppColors.textPrimaryDark),
        toolbarTextStyle: AppTypography.bodyMedium(color: AppColors.textPrimaryDark),
      ),
      
      // 엘리베이티드 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: elevationLow,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: AppTypography.buttonMedium(),
        ),
      ),
      
      // 텍스트 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: AppTypography.buttonMedium(color: AppColors.primaryLight),
        ),
      ),
      
      // 아웃라인 버튼 테마
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: BorderSide(color: AppColors.primaryLight),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: AppTypography.buttonMedium(color: AppColors.primaryLight),
        ),
      ),
      
      // 카드 테마
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: elevationLow,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
      ),
      
      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutralDark.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.neutralDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.neutralDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.bearish),
        ),
        labelStyle: AppTypography.bodyMedium(color: AppColors.textSecondaryDark),
        hintStyle: AppTypography.bodyMedium(color: AppColors.textTertiaryDark),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // 바텀 네비게이션 바 테마
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textTertiaryDark,
        selectedLabelStyle: AppTypography.caption(color: AppColors.primaryLight),
        unselectedLabelStyle: AppTypography.caption(color: AppColors.textTertiaryDark),
        type: BottomNavigationBarType.fixed,
      ),
      
      // 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutralDark,
        contentTextStyle: AppTypography.bodyMedium(color: AppColors.textPrimaryDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // 텍스트 테마
      textTheme: TextTheme(
        displayLarge: AppTypography.h1(color: AppColors.textPrimaryDark),
        displayMedium: AppTypography.h2(color: AppColors.textPrimaryDark),
        displaySmall: AppTypography.h3(color: AppColors.textPrimaryDark),
        headlineMedium: AppTypography.h4(color: AppColors.textPrimaryDark),
        bodyLarge: AppTypography.bodyLarge(color: AppColors.textPrimaryDark),
        bodyMedium: AppTypography.bodyMedium(color: AppColors.textPrimaryDark),
        bodySmall: AppTypography.bodySmall(color: AppColors.textSecondaryDark),
        labelLarge: AppTypography.buttonMedium(color: AppColors.textPrimaryDark),
        labelSmall: AppTypography.caption(color: AppColors.textTertiaryDark),
      ),
    );
  }
}