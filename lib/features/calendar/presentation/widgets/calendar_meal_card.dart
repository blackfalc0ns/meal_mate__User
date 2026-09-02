import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
part 'calendar_meal_details.dart';
part 'calendar_meal_type_badge.dart';
part 'calendar_nutrition_row.dart';
part 'calendar_nutrition_item.dart';
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
    final mealCardBodyHeight = 140.0;
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
                  textDirection: TextDirection.ltr,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: meal.imageUrl == null || meal.imageUrl!.isEmpty
                          ? Image.asset(
                              Assets.calendarMealPickerHero,
                              width: 83,
                              height: 96,
                              fit: BoxFit.cover,
                            )
                          : AppCachedNetworkImage(
                              imageUrl: meal.imageUrl,
                              width: 83,
                              height: 96,
                              fit: BoxFit.cover,
                              semanticLabel: meal.title,
                            ),
                    ),
                    const SizedBox(width: Spacing.lg),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: CalendarMealDetails(meal: meal),
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
