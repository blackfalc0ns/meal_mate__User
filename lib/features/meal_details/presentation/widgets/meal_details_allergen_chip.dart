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
      height: Spacing.iconMd,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon,
            size: Spacing.iconSm,
            color: IconTheme.of(context).color ?? color.onSurface,
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            allergen.label,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  IconData get _icon {
    return switch (allergen.type) {
      MealDetailsAllergenType.nuts => Icons.grain_rounded,
      MealDetailsAllergenType.lactose => Icons.local_drink_rounded,
      MealDetailsAllergenType.gluten => Icons.bakery_dining_rounded,
    };
  }
}
