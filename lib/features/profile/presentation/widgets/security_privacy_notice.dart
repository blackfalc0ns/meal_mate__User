import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SecurityPrivacyNotice extends StatelessWidget {
  const SecurityPrivacyNotice({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.isWarning = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final accent = isWarning ? color.secondary : color.primary;
    final background = isWarning
        ? color.secondary.withValues(alpha: 0.08)
        : color.primaryContainer;
    final height = isWarning
        ? Spacing.profilePrivacyReminderHeight
        : Spacing.profilePrivacyNoticeHeight;

    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.profileSettingsInset,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(Spacing.profilePrivacyCardRadius),
        border: Border.all(
          color: isWarning
              ? color.secondary.withValues(alpha: 0.2)
              : color.outlineVariant,
        ),
      ),
      child: Row(
        textDirection: locale.localeName == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        children: [
          Icon(icon, color: accent, size: Spacing.xxl),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size10,
                    color: accent,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size10,
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
