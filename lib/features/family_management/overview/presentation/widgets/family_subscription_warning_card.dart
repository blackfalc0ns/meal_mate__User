import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/shared/domain/entities/family_subscription_settings_entity.dart';

class FamilySubscriptionWarningCard extends StatelessWidget {
  const FamilySubscriptionWarningCard({super.key, required this.settings});

  final FamilySubscriptionSettingsEntity settings;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.familyManageWarningHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
      decoration: BoxDecoration(
        color: color.secondaryContainer,
        border: Border.all(color: color.secondary.withValues(alpha: 0.25)),
        borderRadius: BorderRadiusDirectional.circular(13.31),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.familyManageAlert,
            width: 29.04,
            height: 29.04,
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settings.warningTitle,
                  locale: Locale(locale.localeName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: 9.52,
                    color: color.secondary,
                  ),
                ),
                const SizedBox(height: Spacing.xss),
                Text(
                  settings.warningMessage,
                  locale: Locale(locale.localeName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: 9.68,
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
