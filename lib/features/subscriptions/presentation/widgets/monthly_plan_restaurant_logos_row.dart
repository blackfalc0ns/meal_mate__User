import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MonthlyPlanRestaurantLogosRow extends StatelessWidget {
  const MonthlyPlanRestaurantLogosRow({
    super.key,
    required this.countLabel,
    required this.isFeatured,
  });

  final String countLabel;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final icons = [
      Icons.eco_rounded,
      Icons.ramen_dining_rounded,
      Icons.restaurant_rounded,
    ];

    return Semantics(
      label: locale.calendar_browse_restaurants,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Spacing.lg,
              height: Spacing.lg,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFeatured ? color.secondary : color.primary,
                  width: Spacing.hairline,
                ),
              ),
              child: Text(
                countLabel,
                maxLines: 1,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size6,
                  color: color.onSurface,
                ).copyWith(height: 1),
              ),
            ),
            for (final icon in icons) ...[
              const SizedBox(width: Spacing.xs),
              Container(
                width: Spacing.lg,
                height: Spacing.lg,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFeatured ? color.secondary : color.primary,
                    width: Spacing.hairline,
                  ),
                ),
                child: Icon(
                  icon,
                  size: FontSize.size10,
                  color: icon == Icons.restaurant_rounded
                      ? color.onSurface
                      : color.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
