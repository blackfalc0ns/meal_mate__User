import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class SubscriptionRestaurantLogo extends StatelessWidget {
  const SubscriptionRestaurantLogo({
    super.key,
    required this.restaurant,
    required this.size,
  });

  final MonthlyRestaurantPlanEntity restaurant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
      ),
      child: AppCachedNetworkImage(
        imageUrl: restaurant.logoUrl,
        width: size,
        height: size,
        shape: BoxShape.circle,
        fit: BoxFit.contain,
        semanticLabel: locale.calendar_browse_restaurants,
      ),
    );
  }
}
