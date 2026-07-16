import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileSettingsTile extends StatelessWidget {
  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.showDivider,
    this.onTap,
    this.trailingIcon,
    this.height = Spacing.profileSettingsTileHeight,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool showDivider;
  final VoidCallback? onTap;
  final IconData? trailingIcon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: height,
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
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
                      width: Spacing.profileSettingsIconContainer,
                      height: Spacing.profileSettingsIconContainer,
                      decoration: BoxDecoration(
                        color: color.secondaryContainer,
                        borderRadius: BorderRadius.circular(Spacing.xss),
                      ),
                      child: Icon(
                        icon,
                        color: color.primary,
                        size: Spacing.profileSettingsIconSize,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size12,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            subtitle,
                            maxLines: 1,
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
                    Icon(
                   Icons.chevron_right_rounded,
                      color: color.onSurfaceVariant,
                      size: Spacing.iconSm,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.profileSettingsInset,
              ),
              child: Divider(
                height: Spacing.hairline,
                color: color.outlineVariant,
              ),
            ),
        ],
      ),
    );
  }
}
