import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable error / empty state widget with retry action.
/// ─────────────────────────────────────────────────────────────
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.message = 'Something went wrong',
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onRetry,
    this.retryLabel = 'Try Again',
    this.padding,
  });

  /// Empty state constructor.
  const AppErrorWidget.empty({
    super.key,
    this.message = 'No data available',
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onRetry,
    this.retryLabel = 'Refresh',
    this.padding,
  });

  final String message;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onRetry;
  final String retryLabel;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ??
            const EdgeInsets.all(Spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline_rounded,
              size: 64,
              color: iconColor ?? AppColors.textHint,
            ),
            const SizedBox(height: Spacing.base),
            Text(
              message,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size16,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                subtitle!,
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size13,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: Spacing.xl),
              AppButton(
                text: retryLabel,
                onPressed: onRetry,
                isExpanded: false,
                height: Spacing.buttonSmallHeight,
                borderRadius: Spacing.buttonSmallRadius,
              ),
            ],
          ],
        ),
      ),
    );
  }
}