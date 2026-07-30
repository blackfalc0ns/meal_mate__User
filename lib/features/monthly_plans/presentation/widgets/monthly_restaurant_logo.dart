import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class MonthlyRestaurantLogo extends StatelessWidget {
  const MonthlyRestaurantLogo({
    super.key,
    required this.restaurant,
    required this.size,
  });

  final MonthlyRestaurantPlanEntity restaurant;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.appBorder, width: 1.2),
      ),
      child: restaurant.logoAsset == null
          ? Text(
              restaurant.initials ?? restaurant.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size8,
                color: restaurant.brandColor,
              ).copyWith(height: 1.05),
            )
          : Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(restaurant.logoAsset!, fit: BoxFit.contain),
            ),
    );
  }
}
