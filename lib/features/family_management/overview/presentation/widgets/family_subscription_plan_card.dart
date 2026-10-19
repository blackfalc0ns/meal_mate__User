import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/shared/domain/entities/family_subscription_settings_entity.dart';

class FamilySubscriptionPlanCard extends StatelessWidget {
  const FamilySubscriptionPlanCard({super.key, required this.settings});

  final FamilySubscriptionSettingsEntity settings;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ColoredBox(
      color: color.surface.withValues(alpha: 0),
      child: Semantics(
        label: locale.family_manage_title,
        child: SizedBox(
          width: double.infinity,
          height: Spacing.familyManagePlanCardHeight,
          child: ClipRRect(
            borderRadius: BorderRadiusDirectional.circular(
              Spacing.familyManagePlanCardRadius,
            ),
            child: Image.asset(
              settings.heroImageAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(Assets.familyBanner, fit: BoxFit.cover);
              },
            ),
          ),
        ),
      ),
    );
  }
}
