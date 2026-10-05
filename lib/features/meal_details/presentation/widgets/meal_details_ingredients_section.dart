import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_ingredient_item.dart';

class MealDetailsIngredientsSection extends StatefulWidget {
  const MealDetailsIngredientsSection({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  State<MealDetailsIngredientsSection> createState() =>
      _MealDetailsIngredientsSectionState();
}

class _MealDetailsIngredientsSectionState
    extends State<MealDetailsIngredientsSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollForward() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final target = (_scrollController.offset + 80.0).clamp(0.0, maxScroll);
    unawaited(
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final ingredients = widget.meal.ingredients;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.meal.ingredientsTitle,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      for (int i = 0; i < ingredients.length; i++) ...[
                        MealDetailsIngredientItem(ingredient: ingredients[i]),
                        if (i < ingredients.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                            ),
                            child: SizedBox(
                              height: 32.0,
                              child: VerticalDivider(
                                color: color.outlineVariant,
                                thickness: 1.0,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              GestureDetector(
                onTap: _scrollForward,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 28.0,
                  height: 28.0,
                  decoration: BoxDecoration(
                    color: color.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    size: Spacing.iconSm,
                    color: color.onSurface,
                    semanticLabel: locale.calendar_ingredients,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
