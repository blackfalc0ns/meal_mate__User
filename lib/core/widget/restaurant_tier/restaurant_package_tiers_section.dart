import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_card.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';

class RestaurantPackageTiersSection extends StatelessWidget {
  const RestaurantPackageTiersSection({
    super.key,
    required this.packages,
    required this.selectedIndex,
    required this.onSelected,
    required this.onBrowseRestaurants,
  });

  final List<RestaurantPackageTierUiModel> packages;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final ValueChanged<int> onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.calendar_browse_restaurants,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.grid_view_rounded,
                    size: Spacing.iconMd,
                    color: color.primary,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.subscription_restaurant_categories_title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size15,
                            color: color.onSurface,
                          ),
                        ),
                        Text(
                          locale.subscription_restaurant_categories_subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.lg),
              for (var index = 0; index < packages.length; index++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: index == packages.length - 1
                        ? Spacing.zero
                        : Spacing.monthlyPlanPackageGap,
                  ),
                  child: RestaurantPackageTierCard(
                    package: packages[index],
                    title: packages[index].title,
                    width: double.infinity,
                    height: Spacing.monthlyPlanPackageSideHeight,
                    isCentered: index == 1,
                    isSelected: selectedIndex == index,
                    onTap: () => onSelected(index),
                    onBrowseRestaurants: () => onBrowseRestaurants(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
