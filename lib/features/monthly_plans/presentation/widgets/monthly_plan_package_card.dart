import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_card.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanPackageCard extends StatelessWidget {
  const MonthlyPlanPackageCard({
    super.key,
    required this.package,
    required this.title,
    required this.width,
    required this.height,
    required this.isCentered,
    required this.isSelected,
    required this.onTap,
    required this.onBrowseRestaurants,
  });

  final MonthlyPackageTierEntity package;
  final String title;
  final double width;
  final double height;
  final bool isCentered;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    return RestaurantPackageTierCard(
      package: RestaurantPackageTierUiModel(
        title: package.title,
        subtitle: package.subtitle,
        iconName: package.iconName,
        logoUrl: package.logoUrl,
        restaurantCount: package.restaurantCount,
        restaurantLogoUrls: package.restaurantLogoUrls,
        isPopular: package.isPopular,
      ),
      title: title,
      width: width,
      height: height,
      isCentered: isCentered,
      isSelected: isSelected,
      onTap: onTap,
      onBrowseRestaurants: onBrowseRestaurants,
    );
  }
}

