import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
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
      child: restaurant.logoUrl != null && restaurant.logoUrl!.isNotEmpty
          ? AppCachedNetworkImage(
              imageUrl: restaurant.logoUrl,
              width: size,
              height: size,
              shape: BoxShape.circle,
              fit: BoxFit.contain,
              semanticLabel: locale.calendar_browse_restaurants,
            )
          : restaurant.logoAsset == null
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
              padding: const EdgeInsets.all(Spacing.sm),
              child: Image.asset(restaurant.logoAsset!, fit: BoxFit.contain),
            ),
    );
  }
}
