import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_restaurant_logo.dart';

class MonthlyRestaurantGridCard extends StatelessWidget {
  const MonthlyRestaurantGridCard({super.key, required this.restaurant});

  final MonthlyRestaurantPlanEntity restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(Spacing.sm, Spacing.md, Spacing.sm, 7),
      decoration: BoxDecoration(
        color: AppColors.appSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.appBorder, width: 1.2),
      ),
      child: Column(
        children: [
          MonthlyRestaurantLogo(restaurant: restaurant, size: 47),
          const SizedBox(height: Spacing.xs),
          Text(
            restaurant.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size10,
              color: AppColors.black,
            ),
          ),
          Text(
            restaurant.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size8,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${restaurant.meals} وجبة',
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size8,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              const Icon(
                Icons.star_rounded,
                size: 10,
                color: AppColors.primary,
              ),
              const SizedBox(width: 2),
              Text(
                restaurant.rating,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size8,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Container(
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F7F1),
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
            ),
            child: Text(
              '${restaurant.meals} وجبة في الباقة',
              style: getRegularStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size8,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
