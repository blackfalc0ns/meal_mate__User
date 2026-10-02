import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_empty_meals_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_frozen_day_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_summary_card.dart';

class CalendarDayContent extends StatelessWidget {
  const CalendarDayContent({
    super.key,
    required this.selectedDay,
    required this.showBottomSpace,
    required this.onSelectRestaurant,
    required this.onChangeMeal,
    required this.onMealTap,
    this.onConfirmSelections,
    this.isConfirming = false,
    this.canConfirm = false,
  });
  final CalendarDayEntity? selectedDay;
  final bool showBottomSpace;
  final VoidCallback onSelectRestaurant;
  final VoidCallback onChangeMeal;
  final void Function(CalendarMealEntity, CalendarRestaurantEntity?) onMealTap;
  final VoidCallback? onConfirmSelections;
  final bool isConfirming;
  final bool canConfirm;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final restaurant = selectedDay?.restaurant;
    final meals = selectedDay?.meals ?? const [];
    final readOnly = selectedDay?.isEditable != true;
    final hasMeals = meals.isNotEmpty;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsetsDirectional.only(
        start: Spacing.screenH,
        end: Spacing.screenH,
        top: Spacing.base,
        bottom: showBottomSpace
            ? Spacing.bottomNavHeight + Spacing.xxxl + Spacing.md
            : Spacing.xl,
      ),
      child: Column(
        children: [
          if (selectedDay?.isFrozen == true)
            const CalendarFrozenDayState()
          else if (!hasMeals)
            CalendarEmptyMealsState(
              // ignore: unnecessary_lambdas
              onAddMeals: readOnly ? null : () => onSelectRestaurant(),
            )
          else ...[
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: color.primary,
                  size: Spacing.iconMd,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  locale.calendar_confirm_selection_header,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size16,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            if (restaurant != null) ...[
              CalendarRestaurantSummaryCard(
                key: ValueKey(
                  '${selectedDay?.date?.toIso8601String() ?? ''}-${restaurant.id}-${meals.length}',
                ),
                restaurant: restaurant,
                day: selectedDay,
                onMorePressed: readOnly ? null : onSelectRestaurant,
              ),
              const SizedBox(height: Spacing.xl),
            ],
            for (final meal in meals) ...[
              CalendarMealCard(
                meal: meal,
                readOnly: readOnly,
                onTap: () => onMealTap(meal, restaurant),
                onChangeMeal: onChangeMeal,
              ),
              const SizedBox(height: Spacing.md),
            ],
            if (!readOnly && canConfirm) ...[
              const SizedBox(height: Spacing.lg),
              AppButton(
                text: locale.calendar_confirm_selections,
                isLoading: isConfirming,
                onPressed: isConfirming ? null : onConfirmSelections,
                height: Spacing.buttonHeight,
                borderRadius: Spacing.buttonRadius,
                color: color.primary,
                textColor: color.onPrimary,
                fontSize: FontSize.size16,
              ),
            ] else if (selectedDay?.isAwaitingRestaurantConfirmation == true) ...[
              const SizedBox(height: Spacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.md,
                ),
                decoration: BoxDecoration(
                  color: color.secondaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                  border: Border.all(color: color.secondaryContainer),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_top_rounded,
                      color: color.primary,
                      size: Spacing.iconSm + 2,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      locale.calendar_status_awaiting_restaurant,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
