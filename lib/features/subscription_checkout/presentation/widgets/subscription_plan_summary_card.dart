import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_included_feature_item.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_tile.dart';

class SubscriptionPlanSummaryCard extends StatelessWidget {
  const SubscriptionPlanSummaryCard({
    super.key,
    required this.summary,
  });

  final SubscriptionSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final durationValue = '${summary.durationDays} ${locale.subscription_day}';
    final packageValue = summary.bundleName(locale.localeName);
    final tierValue = summary.tierName(locale.localeName);
    final fridaySubtext = summary.includeFriday
        ? locale.subscription_with_friday
        : locale.subscription_without_friday;

    final dailyMealsTitle = summary.slotRequirements.isNotEmpty
        ? summary.slotRequirements
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
                      summary.includes
                              .title(locale.localeName)
                              .trim()
                              .isNotEmpty
                          ? summary.includes.title(locale.localeName)
                          : locale.subscription_summary_includes_label,
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
                  children: _buildFeatureItems(
                    color: color,
                    locale: locale,
                    dailyMealsTitle: dailyMealsTitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureItems({
    required ColorScheme color,
    required dynamic locale,
    required String dailyMealsTitle,
  }) {
    final dynamicItems = summary.includes.items;
    final widgets = <Widget>[];

    if (dynamicItems.isNotEmpty) {
      for (var i = 0; i < dynamicItems.length; i++) {
        final item = dynamicItems[i];
        if (i > 0) {
          widgets.add(
            Container(
              width: Spacing.border,
              height: Spacing.xxl,
              color: color.outlineVariant,
            ),
          );
        }
        widgets.add(
          Expanded(
            child: SubscriptionIncludedFeatureItem(
              icon: Icon(
                _resolveIcon(item.code),
                color: color.primary,
                size: Spacing.iconSm,
              ),
              title: item.text(locale.localeName),
            ),
          ),
        );
      }
      return widgets;
    }

    final fallbackItems = [
      SubscriptionIncludedFeatureItem(
        icon: Icon(
          Icons.dinner_dining_rounded,
          color: color.primary,
          size: Spacing.iconSm,
        ),
        title: dailyMealsTitle,
        subtitle: locale.subscription_meals_breakdown,
      ),
      SubscriptionIncludedFeatureItem(
        icon: Icon(
          Icons.soup_kitchen_rounded,
          color: color.primary,
          size: Spacing.iconSm,
        ),
        title: locale.subscription_summary_restaurants,
      ),
      SubscriptionIncludedFeatureItem(
        icon: Icon(
          Icons.verified_rounded,
          color: color.primary,
          size: Spacing.iconSm,
        ),
        title: locale.subscription_summary_quality,
      ),
      SubscriptionIncludedFeatureItem(
        icon: Icon(
          Icons.eco_rounded,
          color: color.primary,
          size: Spacing.iconSm,
        ),
        title: locale.subscription_summary_variety,
      ),
      SubscriptionIncludedFeatureItem(
        icon: Icon(
          Icons.check_circle_outline_rounded,
          color: color.primary,
          size: Spacing.iconSm,
        ),
        title: locale.subscription_certified_meals,
      ),
    ];

    for (var i = 0; i < fallbackItems.length; i++) {
      if (i > 0) {
        widgets.add(
          Container(
            width: Spacing.border,
            height: Spacing.xxl,
            color: color.outlineVariant,
          ),
        );
      }
      widgets.add(Expanded(child: fallbackItems[i]));
    }

    return widgets;
  }

  IconData _resolveIcon(String code) {
    final lower = code.toLowerCase();
    if (lower.contains('meal') || lower.contains('food')) {
      return Icons.dinner_dining_rounded;
    }
    if (lower.contains('restaurant')) {
      return Icons.soup_kitchen_rounded;
    }
    if (lower.contains('quality') || lower.contains('cert')) {
      return Icons.verified_rounded;
    }
    if (lower.contains('variety') || lower.contains('eco')) {
      return Icons.eco_rounded;
    }
    return Icons.check_circle_outline_rounded;
  }
}
