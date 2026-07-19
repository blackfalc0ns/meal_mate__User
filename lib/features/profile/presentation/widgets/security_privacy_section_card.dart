import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_settings_tile.dart';

class SecurityPrivacySectionCard extends StatelessWidget {
  const SecurityPrivacySectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.tileHeight,
    this.trailingIcon,
  });

  final String title;
  final IconData icon;
  final List<(IconData, String, String, VoidCallback?)> items;
  final double tileHeight;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.profilePrivacyCardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.07),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: Spacing.profilePrivacySectionHeaderHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.profileSettingsInset,
              ),
              child: Row(
                textDirection: locale.localeName == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                children: [
                  Container(
                    width: Spacing.profilePrivacyIconContainerSize,
                    height: Spacing.profilePrivacyIconContainerSize,
                    decoration: BoxDecoration(
                      color: color.secondaryContainer,
                      borderRadius: BorderRadius.circular(Spacing.xss),
                    ),
                    child: Icon(
                      icon,
                      size: Spacing.profilePrivacyIconSize,
                      color: color.primary,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: Spacing.hairline, color: color.outlineVariant),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return ProfileSettingsTile(
              icon: item.$1,
              title: item.$2,
              subtitle: item.$3,
              onTap: item.$4,
              height: tileHeight,
              showDivider: index != items.length - 1,
              trailingIcon: trailingIcon,
            );
          }),
        ],
      ),
    );
  }
}
