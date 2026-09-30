import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tiers_section.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanPackagesSection extends StatelessWidget {
  const MonthlyPlanPackagesSection({
    super.key,
    required this.packages,
    required this.selectedIndex,
    required this.onSelected,
    required this.onBrowseRestaurants,
  });

  final List<MonthlyPackageTierEntity> packages;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final ValueChanged<int> onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    final uiModels = packages
        .map(
          (p) => RestaurantPackageTierUiModel(
            title: p.title,
            subtitle: p.subtitle,
            iconName: p.iconName,
            logoUrl: p.logoUrl,
            restaurantCount: p.restaurantCount,
            restaurantLogoUrls: p.restaurantLogoUrls,
            isPopular: p.isPopular,
            price: p.price,
            currency: p.currency,
            priceSubtitle: p.period,
          ),
        )
        .toList();

    return RestaurantPackageTiersSection(
      packages: uiModels,
      selectedIndex: selectedIndex,
      onSelected: onSelected,
      onBrowseRestaurants: onBrowseRestaurants,
    );
  }
}

