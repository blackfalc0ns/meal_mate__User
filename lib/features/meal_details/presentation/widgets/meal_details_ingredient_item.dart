import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';

class MealDetailsIngredientItem extends StatelessWidget {
  const MealDetailsIngredientItem({super.key, required this.ingredient});

  final MealDetailsIngredientEntity ingredient;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    final weight = ingredient.weight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 52.0,
          height: 52.0,
          padding: const EdgeInsets.all(Spacing.xs),
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(color: color.outlineVariant),
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Spacing.radiusXs),
            child: ingredient.iconUrl == null || ingredient.iconUrl!.isEmpty
                ? Image.asset(ingredient.asset, fit: BoxFit.contain)
                : AppCachedNetworkImage(
                    imageUrl: ingredient.iconUrl!,
                    fit: BoxFit.contain,
                    semanticLabel: ingredient.label,
                  ),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          ingredient.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurface,
          ),
        ),
        if (weight != null && weight.isNotEmpty) ...[
          const SizedBox(height: 2.0),
          Text(
            weight,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
