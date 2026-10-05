import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';

class MealDetailsAllergenChip extends StatelessWidget {
  const MealDetailsAllergenChip({super.key, required this.allergen});

  final MealDetailsAllergenEntity allergen;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xss,
      ),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(Spacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon,
            size: Spacing.iconSm,
            color: IconTheme.of(context).color ?? color.secondary,
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            allergen.label,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  IconData get _icon {
    return switch (allergen.type) {
      MealDetailsAllergenType.nuts => Icons.cookie_rounded,
      MealDetailsAllergenType.lactose => Icons.local_drink_rounded,
      MealDetailsAllergenType.gluten => Icons.grass_rounded,
    };
  }
}
