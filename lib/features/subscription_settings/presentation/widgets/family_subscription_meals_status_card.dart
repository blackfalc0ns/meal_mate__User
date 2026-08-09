import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_meals_status_item.dart';

class FamilySubscriptionMealsStatusCard extends StatelessWidget {
  const FamilySubscriptionMealsStatusCard({super.key, required this.statuses});

  final List<FamilySubscriptionMealStatusEntity> statuses;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.familyManageMealsStatusHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant, width: 1.85),
        borderRadius: BorderRadiusDirectional.circular(14.48),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            offset: const Offset(0, Spacing.sm),
            blurRadius: Spacing.sm,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                locale.family_manage_today_meals_status,

                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                locale.family_manage_today_date,

                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 31,
                crossAxisSpacing: Spacing.lg,
                mainAxisSpacing: Spacing.md,
              ),
              itemCount: statuses.length,
              itemBuilder: (context, index) {
                return FamilySubscriptionMealsStatusItem(
                  status: statuses[index],
                );
              },
            ),
          ),
          //  const SizedBox(height: Spacing.xs),
          AppButton(
            text: locale.family_manage_complete_missing_meals,
            onPressed: () {},
            height: Spacing.xxl,
            borderRadius: Spacing.radiusPill,
            color: color.primary,
            textColor: color.onPrimary,
            fontSize: FontSize.size9,
          ),
        ],
      ),
    );
  }
}
