import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart';
part 'calendar_meal_details.dart';
part 'calendar_meal_type_badge.dart';
part 'calendar_nutrition_row.dart';
part 'calendar_nutrition_item.dart';
part 'calendar_ingredient_chip.dart';

class CalendarMealCard extends StatelessWidget {
  const CalendarMealCard({super.key, required this.meal});

  final CalendarMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return SizedBox(
      height: 147,
      child: Column(
        children: [
          SizedBox(
            height: 114,
            child: InkWell(
              onTap: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.mealDetails, arguments: meal),
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
                      child: Image.asset(
                        meal.imageAsset,
                        width: 83,
                        height: 96,
                        fit: BoxFit.cover,
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
          const SizedBox(height: Spacing.sm),
          SizedBox(
            height: 25,
            width: double.infinity,
            child: OpenContainer<void>(
              closedElevation: 0,
              openElevation: 0,
              closedColor: color.surface.withValues(alpha: 0),
              middleColor: color.surface,
              openColor: color.surface,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              openShape: const RoundedRectangleBorder(),
              transitionDuration: const Duration(milliseconds: 560),
              transitionType: ContainerTransitionType.fadeThrough,
              tappable: false,
              openBuilder: (context, _) => const CalendarMealPickerSheet(),
              closedBuilder: (context, openContainer) {
                return FilledButton.icon(
                  onPressed: openContainer,
                  icon: const Icon(Icons.edit_rounded, size: 13),
                  label: Text(locale.calendar_change_meal),
                  style: FilledButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: color.onPrimary,
                    padding: EdgeInsets.zero,
                    textStyle: getSemiBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: 9.3,
                      color: color.onPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size.zero,
                    fixedSize: const Size.fromHeight(25),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
