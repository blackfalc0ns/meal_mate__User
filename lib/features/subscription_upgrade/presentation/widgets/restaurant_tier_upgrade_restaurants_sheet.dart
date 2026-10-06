import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_restaurant_item.dart';

class RestaurantTierUpgradeRestaurantsSheet extends StatelessWidget {
  const RestaurantTierUpgradeRestaurantsSheet({
    super.key,
    required this.restaurants,
  });

  final List<SubscriptionUpgradeRestaurantEntity> restaurants;

  static Future<void> show({
    required BuildContext context,
    required List<SubscriptionUpgradeRestaurantEntity> restaurants,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;

    final titleWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            locale.upgrade_summary_all_new_restaurants_title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.xxs,
          ),
          decoration: BoxDecoration(
            color: color.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
          ),
          child: Text(
            '${restaurants.length}',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.primary,
            ),
          ),
        ),
      ],
    );

    return AppWoltModalSheet.show<void>(
      context: context,
      titleWidget: titleWidget,
      child: RestaurantTierUpgradeRestaurantsSheet(restaurants: restaurants),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (restaurants.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Center(
          child: Text(
            locale.upgrade_summary_no_new_restaurants,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.md,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: restaurants.length,
        separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
        itemBuilder: (context, index) {
          return RestaurantTierUpgradeRestaurantItem(
            restaurant: restaurants[index],
          );
        },
      ),
    );
  }
}
