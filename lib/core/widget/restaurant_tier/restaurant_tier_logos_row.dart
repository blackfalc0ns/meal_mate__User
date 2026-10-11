import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class RestaurantTierLogosRow extends StatelessWidget {
  const RestaurantTierLogosRow({
    super.key,
    required this.countLabel,
    required this.logoUrls,
    required this.isFeatured,
  });

  final String countLabel;
  final List<String?> logoUrls;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final visibleLogoUrls = logoUrls.take(4).toList();
    final borderColor = color.primary;

    return Semantics(
      label: locale.calendar_browse_restaurants,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (countLabel.isNotEmpty) ...[
              Container(
                width: Spacing.monthlyPlanRestaurantLogoSize,
                height: Spacing.monthlyPlanRestaurantLogoSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: Spacing.border),
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.08),
                      blurRadius: Spacing.xs,
                      offset: const Offset(0, Spacing.hairline),
                    ),
                  ],
                ),
                child: Text(
                  countLabel,
                  maxLines: 1,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ).copyWith(height: 1),
                ),
              ),
              if (visibleLogoUrls.isNotEmpty) const SizedBox(width: Spacing.xs),
            ],
            for (var i = 0; i < visibleLogoUrls.length; i++) ...[
              if (i > 0) const SizedBox(width: Spacing.xs),
              Container(
                width: Spacing.monthlyPlanRestaurantLogoSize,
                height: Spacing.monthlyPlanRestaurantLogoSize,
                decoration: BoxDecoration(
                  color: color.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: Spacing.border),
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.08),
                      blurRadius: Spacing.xs,
                      offset: const Offset(0, Spacing.hairline),
                    ),
                  ],
                ),
                child: ClipOval(
                  child:
                      (visibleLogoUrls[i] != null &&
                          visibleLogoUrls[i]!.startsWith('assets/'))
                      ? Image.asset(
                          visibleLogoUrls[i]!,
                          width: Spacing.monthlyPlanRestaurantLogoSize,
                          height: Spacing.monthlyPlanRestaurantLogoSize,
                          fit: BoxFit.contain,
                        )
                      : AppCachedNetworkImage(
                          imageUrl: visibleLogoUrls[i],
                          width: Spacing.monthlyPlanRestaurantLogoSize,
                          height: Spacing.monthlyPlanRestaurantLogoSize,
                          shape: BoxShape.circle,
                          fit: BoxFit.contain,
                          semanticLabel: locale.calendar_browse_restaurants,
                          errorWidget: Icon(
                            Icons.restaurant_rounded,
                            size: FontSize.size14,
                            color: color.primary,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
