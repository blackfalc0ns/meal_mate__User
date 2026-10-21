import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_empty_meals.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_meals_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/staggered_slide_item.dart';

import 'family_member_calendar_action_section.dart';
import 'family_member_selected_meals_section.dart';
import 'family_member_calendar_summary_section.dart';

class FamilyMemberSelectedDaySection extends StatelessWidget {
  const FamilyMemberSelectedDaySection({
    super.key,
    required this.fallbackDate,
    this.fallbackMemberId,
    required this.onChooseMeals,
    required this.onShowDetails,
  });
  final DateTime fallbackDate;
  final String? fallbackMemberId;
  final VoidCallback onChooseMeals;
  final VoidCallback onShowDetails;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return BlocSelector<
      FamilyCalendarViewModel,
      FamilyCalendarState,
      ({
        DateTime date,
        String? memberId,
        bool loading,
        List<CalendarMealEntity> meals,
        String name,
      })
    >(
      selector: (state) => (
        date: state.selectedDate ?? fallbackDate,
        memberId: state.currentMember?.memberId ?? fallbackMemberId,
        loading: state.isLoadingDay,
        meals: state.selectedDay?.meals ?? const [],
        name: state.displayName,
      ),
      builder: (context, data) {
        final selectedDate = data.date;
        final memberId = data.memberId;
        final hasMeals = data.meals.isNotEmpty;
        if (data.loading) {
          return const FamilyMemberCalendarMealsLoadingSkeleton();
        }
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
                    child: FamilyMemberSelectedMealsSection(
                      meals: data.meals,
                      selectedDate: selectedDate,
                      displayName: data.name,
                    ),
                  ),
                  const SizedBox(
                    height: Spacing.familyMemberCalendarDaySummaryTopGap,
                  ),
                  StaggeredSlideItem(
                    key: ValueKey('summary_card_${selectedDate.day}'),
                    index: 1,
                    child: FamilyMemberCalendarSummarySection(
                      selectedDate: selectedDate,
                      mealCount: data.meals.length,
                    ),
                  ),
                ] else ...[
                  StaggeredSlideItem(
                    key: ValueKey('empty_meals_${selectedDate.day}'),
                    index: 0,
                    child: const FamilyMemberCalendarEmptyMeals(),
                  ),
                ],
                const SizedBox(
                  height: Spacing.familyMemberCalendarButtonTopGap,
                ),
                StaggeredSlideItem(
                  key: ValueKey('action_btn_${selectedDate.day}'),
                  index: hasMeals ? 2 : 1,
                  child: FamilyMemberCalendarActionSection(
                    hasMeals: hasMeals,
                    onChooseMeals: onChooseMeals,
                    onShowDetails: onShowDetails,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
