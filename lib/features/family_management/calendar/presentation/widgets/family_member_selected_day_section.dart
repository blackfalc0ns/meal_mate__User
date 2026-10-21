import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_member_calendar_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_day_summary_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_empty_meals.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_meals_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_primary_action.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_selected_meals_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/staggered_slide_item.dart';

class FamilyMemberSelectedDaySection extends StatelessWidget {
  const FamilyMemberSelectedDaySection({
    super.key,
    required this.selectedDate,
    required this.selectedDay,
    required this.isLoadingDay,
    required this.canEdit,
    this.memberId,
    required this.displayName,
    required this.onChooseMeals,
    required this.onShowDetails,
  });

  final DateTime selectedDate;
  final CalendarDayEntity? selectedDay;
  final bool isLoadingDay;
  final bool canEdit;
  final String? memberId;
  final String displayName;
  final VoidCallback onChooseMeals;
  final VoidCallback onShowDetails;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (isLoadingDay) {
      return const FamilyMemberCalendarMealsLoadingSkeleton();
    }

    final dayMeals = selectedDay?.meals ?? const [];
    final selectedMealEntities = dayMeals.map((meal) {
      final slotLabel = meal.slot.isNotEmpty
          ? meal.mealType
          : (meal.mealType.isNotEmpty ? meal.mealType : locale.calendar_title);
      final desc = meal.calories.isNotEmpty
          ? locale.family_member_calories_value(meal.calories)
          : meal.description;

      return FamilyCalendarSelectedMealEntity(
        typeLabel: slotLabel,
        name: meal.title,
        description: desc,
        chosenLabel: locale.family_member_meal_chosen,
        imageAsset: meal.imageAsset,
        imageUrl: meal.imageUrl,
      );
    }).toList();

    final formattedDateTitle = intl.DateFormat.yMMMMEEEEd(
      locale.localeName,
    ).format(selectedDate);

    final daySummary = FamilyCalendarDaySummaryEntity(
      title: formattedDateTitle,
      subtitle: locale.family_member_selected_meals_count(
        selectedMealEntities.length,
      ),
    );

    final formattedShortDate = intl.DateFormat.MMMMd(
      locale.localeName,
    ).format(selectedDate);

    final hasMeals = selectedMealEntities.isNotEmpty;

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 320),
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          fillColor: color.surface,
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey(
          '${memberId}_${selectedDate.year}_${selectedDate.month}_${selectedDate.day}_$hasMeals',
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasMeals) ...[
              StaggeredSlideItem(
                key: ValueKey('meals_card_${selectedDate.day}'),
                index: 0,
                child: FamilyMemberSelectedMealsCard(
                  title: locale.family_member_selected_meals_title,
                  subtitle: locale.family_member_selected_meals_subtitle(
                    displayName,
                    formattedShortDate,
                  ),
                  countLabel: locale.family_member_selected_meals_count(
                    selectedMealEntities.length,
                  ),
                  meals: selectedMealEntities,
                ),
              ),
              const SizedBox(
                height: Spacing.familyMemberCalendarDaySummaryTopGap,
              ),
              StaggeredSlideItem(
                key: ValueKey('summary_card_${selectedDate.day}'),
                index: 1,
                child: FamilyMemberCalendarDaySummaryCard(
                  summary: daySummary,
                  dayNumber: selectedDate.day,
                ),
              ),
            ] else ...[
              StaggeredSlideItem(
                key: ValueKey('empty_meals_${selectedDate.day}'),
                index: 0,
                child: const FamilyMemberCalendarEmptyMeals(),
              ),
            ],
            const SizedBox(height: Spacing.familyMemberCalendarButtonTopGap),
            StaggeredSlideItem(
              key: ValueKey('action_btn_${selectedDate.day}'),
              index: hasMeals ? 2 : 1,
              child: FamilyMemberCalendarPrimaryAction(
                hasMeals: hasMeals,
                canEdit: canEdit,
                onChooseMeals: onChooseMeals,
                onShowDetails: onShowDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
