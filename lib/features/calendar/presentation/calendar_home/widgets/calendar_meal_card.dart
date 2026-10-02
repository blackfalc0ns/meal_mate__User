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
    const mealCardBodyHeight = 140.0;
    return SizedBox(
      height: readOnly
          ? mealCardBodyHeight
          : (mealCardBodyHeight + Spacing.sm + 25.0),
      child: Column(
        children: [
          SizedBox(
            height: mealCardBodyHeight,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsetsDirectional.only(
                  top: Spacing.calendarMealCardVerticalPadding,
                  bottom: Spacing.calendarMealCardVerticalPadding,
                  start: Spacing.md,
                  end: Spacing.md,
                ),
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: color.primary),
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.10),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(child: CalendarMealDetails(meal: meal)),
                    const SizedBox(width: Spacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      child: AppCachedNetworkImage(
                        imageUrl: meal.imageUrl,
                        width: 95,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!readOnly) ...[
            const SizedBox(height: Spacing.sm),
            SizedBox(
              height: 25,
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onChangeMeal,
                icon: const Icon(Icons.edit_rounded, size: 13),
                label: Text(locale.calendar_change_meal),
                style: FilledButton.styleFrom(
                  backgroundColor: color.primary,
                  foregroundColor: color.onPrimary,
                  padding: EdgeInsets.zero,
                  textStyle: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onPrimary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  fixedSize: const Size.fromHeight(25),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
