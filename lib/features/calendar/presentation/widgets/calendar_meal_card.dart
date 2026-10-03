import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/widget/app_nutrition_row.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
part 'calendar_meal_details.dart';
part 'calendar_meal_type_badge.dart';
part 'calendar_nutrition_row.dart';
part 'calendar_ingredient_chip.dart';

class CalendarMealCard extends StatelessWidget {
  const CalendarMealCard({
    super.key,
    required this.meal,
    required this.onChangeMeal,
    this.onTap,
    this.readOnly = false,
  });

  final CalendarMealEntity meal;
  final VoidCallback onChangeMeal;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: color.primary.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: CalendarMealDetails(meal: meal)),
                const SizedBox(width: Spacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  child: AppCachedNetworkImage(
                    imageUrl: meal.imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          if (!readOnly) ...[
            const SizedBox(height: Spacing.md),
            InkWell(
              onTap: onChangeMeal,
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
              child: Container(
                height: 36,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      size: 14,
                      color: color.primary,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      locale.calendar_change_meal,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
