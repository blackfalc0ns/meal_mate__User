import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AppNutritionItem extends StatelessWidget {
  const AppNutritionItem({
    super.key,
    this.icon,
    this.animationAsset,
    required this.value,
    required this.label,
    this.iconColor,
  });

  final IconData? icon;
  final String? animationAsset;
  final String value;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (animationAsset != null)
              Lottie.asset(
                animationAsset!,
                fit: BoxFit.contain,
                repeat: true,
                width: 30,
                height: 30,
              )
            else if (icon != null)
              Icon(icon, size: 14, color: iconColor ?? color.primary),
            const SizedBox(width: Spacing.xs - 2),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value.formattedValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ).copyWith(height: 1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xs - 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurface.withValues(alpha: 0.62),
            ).copyWith(height: 1),
          ),
        ),
      ],
    );
  }
}
