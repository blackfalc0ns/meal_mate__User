import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_included_feature_item.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_tile.dart';

class SubscriptionPlanSummaryCard extends StatelessWidget {
  const SubscriptionPlanSummaryCard({
    super.key,
    required this.plan,
    required this.summary,
  });

  final MonthlyPlanDetailsEntity plan;
  final SubscriptionSummaryEntity? summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final durationValue = summary != null
        ? '${summary!.durationDays} ${locale.subscription_day}'
        : plan.duration;

    final packageValue = summary != null
        ? summary!.bundleName(locale.localeName)
        : (plan.packageTiers.isEmpty
              ? plan.mealsPerDay
              : plan.packageTiers.first.title);

    final tierValue = summary != null
        ? summary!.tierName(locale.localeName)
        : plan.discountLabel;

    final fridaySubtext = summary?.includeFriday == true
        ? locale.subscription_with_friday
        : (summary?.includeFriday == false
              ? locale.subscription_without_friday
              : null);

    final dailyMealsTitle = summary?.slotRequirements.isNotEmpty == true
        ? summary!.slotRequirements
              .where((r) => r.count > 0)
              .map((r) => '${r.count} ${r.name(locale.localeName)}')
              .join(' + ')
        : locale.subscription_meals_count_daily;

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Spacing.avatarSm,
                height: Spacing.avatarSm,
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: color.primary,
                  size: Spacing.iconSm,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                locale.subscription_summary_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size18,
                  color: color.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: SubscriptionSummaryTile(
                  label: locale.subscription_summary_duration_label,
                  value: durationValue,
                  subvalue: fridaySubtext,
                  icon: Icon(
                    Icons.calendar_today_rounded,
                    color: color.primary,
                    size: Spacing.iconSm,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: SubscriptionSummaryTile(
                  label: locale.subscription_summary_package_label,
                  value: packageValue,
                  icon: Icon(
                    Icons.inventory_2_outlined,
                    color: color.primary,
                    size: Spacing.iconSm,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          SubscriptionSummaryTile(
            label: locale.subscription_summary_restaurant_tier_label,
            value: tierValue,
            icon: Icon(
              Icons.workspace_premium_rounded,
              color: color.primary,
              size: Spacing.iconSm,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.border,
              ),
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: Spacing.avatarSm,
                      height: Spacing.avatarSm,
                      decoration: BoxDecoration(
                        color: color.primaryContainer,
                        borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        color: color.primary,
                        size: Spacing.iconSm,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      locale.subscription_summary_includes_label,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SubscriptionIncludedFeatureItem(
                        icon: Icon(
                          Icons.dinner_dining_rounded,
                          color: color.primary,
                          size: Spacing.iconSm,
                        ),
                        title: dailyMealsTitle,
                        subtitle: locale.subscription_meals_breakdown,
                      ),
                    ),
                    Container(
                      width: Spacing.border,
                      height: Spacing.xxl,
                      color: color.outlineVariant,
                    ),
                    Expanded(
                      child: SubscriptionIncludedFeatureItem(
                        icon: Icon(
                          Icons.soup_kitchen_rounded,
                          color: color.primary,
                          size: Spacing.iconSm,
                        ),
                        title: locale.subscription_summary_restaurants,
                      ),
                    ),
                    Container(
                      width: Spacing.border,
                      height: Spacing.xxl,
                      color: color.outlineVariant,
                    ),
                    Expanded(
                      child: SubscriptionIncludedFeatureItem(
                        icon: Icon(
                          Icons.verified_rounded,
                          color: color.primary,
                          size: Spacing.iconSm,
                        ),
                        title: locale.subscription_summary_quality,
                      ),
                    ),
                    Container(
                      width: Spacing.border,
                      height: Spacing.xxl,
                      color: color.outlineVariant,
                    ),
                    Expanded(
                      child: SubscriptionIncludedFeatureItem(
                        icon: Icon(
                          Icons.eco_rounded,
                          color: color.primary,
                          size: Spacing.iconSm,
                        ),
                        title: locale.subscription_summary_variety,
                      ),
                    ),
                    Container(
                      width: Spacing.border,
                      height: Spacing.xxl,
                      color: color.outlineVariant,
                    ),
                    Expanded(
                      child: SubscriptionIncludedFeatureItem(
                        icon: Icon(
                          Icons.check_circle_outline_rounded,
                          color: color.primary,
                          size: Spacing.iconSm,
                        ),
                        title: locale.subscription_certified_meals,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
