import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CustomWarningWidget extends StatelessWidget {
  const CustomWarningWidget({
    super.key,
    this.icon,
    this.iconWidget,
    this.title,
    required this.message,
    this.isWarning = false,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.horizontalPadding = Spacing.profileSettingsInset,
    this.iconSize = Spacing.iconMd,
    this.iconTextSpacing = Spacing.md,
    this.borderRadius = Spacing.profilePrivacyCardRadius,
    this.messageFontSize = FontSize.size10,
    this.maxMessageLines = 2,
  }) : assert(icon != null || iconWidget != null);

  final IconData? icon;
  final Widget? iconWidget;
  final String? title;
  final String message;
  final bool isWarning;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final double horizontalPadding;
  final double iconSize;
  final double iconTextSpacing;
  final double borderRadius;
  final double messageFontSize;
  final int maxMessageLines;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final accent = isWarning ? color.secondary : color.primary;
    final defaultBackground = isWarning
        ? color.secondary.withValues(alpha: 0.08)
        : color.primaryContainer;
    final defaultHeight = isWarning
        ? Spacing.profilePrivacyReminderHeight
        : Spacing.profilePrivacyNoticeHeight;

    return Container(
      width: double.infinity,
      height: height ?? defaultHeight,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color:
              borderColor ??
              (isWarning
                  ? color.secondary.withValues(alpha: 0.2)
                  : color.outlineVariant),
        ),
      ),
      child: Row(
        textDirection: locale.localeName == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        children: [
          iconWidget ?? Icon(icon, color: accent, size: iconSize),
          SizedBox(width: iconTextSpacing),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size13,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                ],
                Text(
                  message,
                  maxLines: maxMessageLines,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: messageFontSize,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
