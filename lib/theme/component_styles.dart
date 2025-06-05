import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'app_theme.dart';

/// Trader App 컴포넌트 스타일 라이브러리
/// 
/// 앱 전체에서 재사용 가능한 컴포넌트 스타일 정의
class ComponentStyles {
  
  // 추천 카드 스타일
  static BoxDecoration recommendationCard({
    required BuildContext context,
    bool isHighlighted = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isHighlighted 
        ? (isDark ? AppColors.primaryDark.withOpacity(0.1) : AppColors.primaryLight.withOpacity(0.1))
        : AppColors.getSurfaceColor(context),
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      border: Border.all(
        color: isHighlighted 
          ? AppColors.primary 
          : (isDark ? AppColors.neutralDark : AppColors.neutralLight),
        width: isHighlighted ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
          blurRadius: AppTheme.elevationMedium,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
  
  // 주가 변동 표시 컨테이너
  static BoxDecoration priceChangeContainer({
    required bool isPositive,
    bool isRounded = true,
  }) {
    return BoxDecoration(
      color: isPositive 
        ? AppColors.bullish.withOpacity(0.1) 
        : AppColors.bearish.withOpacity(0.1),
      borderRadius: isRounded 
        ? BorderRadius.circular(AppTheme.borderRadiusSmall) 
        : null,
    );
  }
  
  // 구독 티어 뱃지
  static BoxDecoration subscriptionBadge({required String tier}) {
    Color backgroundColor;
    Color borderColor;
    
    switch (tier.toLowerCase()) {
      case 'professional':
      case 'gold':
        backgroundColor = AppColors.gold.withOpacity(0.1);
        borderColor = AppColors.gold;
        break;
      case 'premium':
      case 'silver':
        backgroundColor = AppColors.primary.withOpacity(0.1);
        borderColor = AppColors.primary;
        break;
      default:
        backgroundColor = AppColors.neutral.withOpacity(0.1);
        borderColor = AppColors.neutral;
    }
    
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusRound),
      border: Border.all(color: borderColor, width: 1),
    );
  }
  
  // 차트 컨테이너
  static BoxDecoration chartContainer({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: AppColors.getSurfaceColor(context),
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      border: Border.all(
        color: isDark ? AppColors.neutralDark : AppColors.neutralLight,
        width: 1,
      ),
    );
  }
  
  // 입력 필드 스타일 (커스텀)
  static InputDecoration customInputDecoration({
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isError = false,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      errorStyle: AppTypography.caption(color: AppColors.error),
    );
  }
  
  // 버튼 스타일 변형
  static ButtonStyle primaryButton({
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.styleFrom(
      minimumSize: minimumSize ?? Size(double.infinity, 48),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }
  
  static ButtonStyle secondaryButton({
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
  }) {
    return OutlinedButton.styleFrom(
      minimumSize: minimumSize ?? Size(double.infinity, 48),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }
  
  static ButtonStyle dangerButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.bearish,
      foregroundColor: Colors.white,
    );
  }
  
  static ButtonStyle successButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.bullish,
      foregroundColor: Colors.white,
    );
  }
  
  // 리스트 아이템 스타일
  static BoxDecoration listItemDecoration({
    required BuildContext context,
    bool isSelected = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isSelected 
        ? AppColors.primary.withOpacity(0.1)
        : Colors.transparent,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      border: isSelected 
        ? Border.all(color: AppColors.primary, width: 2)
        : null,
    );
  }
  
  // 포지션 상태 인디케이터
  static BoxDecoration positionIndicator({
    required String status,
  }) {
    Color color;
    switch (status.toLowerCase()) {
      case 'open':
        color = AppColors.bullish;
        break;
      case 'closed':
        color = AppColors.neutral;
        break;
      case 'profit':
        color = AppColors.bullish;
        break;
      case 'loss':
        color = AppColors.bearish;
        break;
      default:
        color = AppColors.neutral;
    }
    
    return BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    );
  }
  
  // 섹션 헤더 스타일
  static Widget sectionHeader({
    required String title,
    String? subtitle,
    Widget? action,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.h4()),
              if (subtitle != null) ...[
                SizedBox(height: 4),
                Text(subtitle, style: AppTypography.bodySmall()),
              ],
            ],
          ),
        ),
        if (action != null) action,
      ],
    );
  }
  
  // 통계 카드 스타일
  static Widget statCard({
    required String label,
    required String value,
    String? change,
    bool? isPositive,
    IconData? icon,
    required BuildContext context,
  }) {
    return Container(
      padding: AppTheme.paddingMedium,
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.neutralDark 
            : AppColors.neutralLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: AppColors.textSecondary),
                SizedBox(width: 8),
              ],
              Text(label, style: AppTypography.caption()),
            ],
          ),
          SizedBox(height: 8),
          Text(value, style: AppTypography.numberLarge()),
          if (change != null && isPositive != null) ...[
            SizedBox(height: 4),
            Text(
              change,
              style: AppTypography.profitLoss(isProfit: isPositive),
            ),
          ],
        ],
      ),
    );
  }
  
  // 알림 배너 스타일
  static BoxDecoration alertBanner({
    required String type,
  }) {
    Color backgroundColor;
    Color borderColor;
    
    switch (type.toLowerCase()) {
      case 'success':
        backgroundColor = AppColors.bullish.withOpacity(0.1);
        borderColor = AppColors.bullish;
        break;
      case 'warning':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        borderColor = AppColors.warning;
        break;
      case 'error':
        backgroundColor = AppColors.bearish.withOpacity(0.1);
        borderColor = AppColors.bearish;
        break;
      case 'info':
      default:
        backgroundColor = AppColors.info.withOpacity(0.1);
        borderColor = AppColors.info;
    }
    
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      border: Border.all(color: borderColor),
    );
  }
  
  // 탭 인디케이터 스타일
  static BoxDecoration tabIndicator() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusRound),
      color: AppColors.primary,
    );
  }
  
  // 플로팅 액션 버튼 스타일
  static BoxDecoration floatingActionButton({
    bool isExpanded = false,
  }) {
    return BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(
        isExpanded ? AppTheme.borderRadiusRound : 28,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.3),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}