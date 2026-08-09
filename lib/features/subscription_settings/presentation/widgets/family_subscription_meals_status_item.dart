import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilySubscriptionMealsStatusItem extends StatelessWidget {
  const FamilySubscriptionMealsStatusItem({super.key, required this.status});

  final FamilySubscriptionMealStatusEntity status;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final statusColor = switch (status.status) {
      FamilySubscriptionMealStatus.completed => color.primary,
      FamilySubscriptionMealStatus.selected => color.secondary,
      FamilySubscriptionMealStatus.missing => color.onSurfaceVariant,
    };

    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            status.memberImageAsset,
            width: 28,
            height: 28,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: Spacing.xs),
        Text(
          status.memberName,
          locale: Locale(locale.localeName),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size9,
            color: color.onSurface,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: Spacing.xss,
                    height: Spacing.xss,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    status.statusLabel,
                    locale: Locale(locale.localeName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadiusDirectional.circular(
                        Spacing.radiusPill,
                      ),
                      child: LinearProgressIndicator(
                        value: status.progress,
                        minHeight: Spacing.xs,
                        backgroundColor: color.outlineVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    status.mealsLabel,
                    locale: Locale(locale.localeName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
