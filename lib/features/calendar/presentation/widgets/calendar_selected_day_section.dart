import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_day_content.dart';

class CalendarSelectedDaySection extends StatelessWidget {
  const CalendarSelectedDaySection({
    super.key,
    required this.showBottomSpace,
    required this.onSelectRestaurant,
    required this.onChangeMeal,
    required this.onMealTap,
    this.onConfirmSelections,
  });

  final bool showBottomSpace;
  final VoidCallback onSelectRestaurant;
  final VoidCallback onChangeMeal;
  final void Function(CalendarMealEntity, CalendarRestaurantEntity?) onMealTap;
  final VoidCallback? onConfirmSelections;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocSelector<
      CalendarOverviewViewModel,
      CalendarOverviewState,
      ({
        CalendarDayEntity? selectedDay,
        bool isSelectedDayLoading,
        bool canConfirm,
        List<CustomerDeliveryItemEntity> deliveryItems,
      })
    >(
      selector: (state) => (
        selectedDay: state.selectedDay,
        isSelectedDayLoading: state.isSelectedDayLoading,
        canConfirm: state.canConfirmSelectedDayMeals,
        deliveryItems: state.deliveryItems,
      ),
      builder: (context, overviewData) {
        return BlocSelector<MealSelectionViewModel, MealSelectionState, bool>(
          selector: (mealState) => mealState.isConfirming,
          builder: (context, isConfirming) {
            return CalendarDayContent(
              selectedDay: overviewData.selectedDay,
              deliveryItems: overviewData.deliveryItems,
              showBottomSpace: showBottomSpace,
              onSelectRestaurant: onSelectRestaurant,
              onChangeMeal: onChangeMeal,
              onMealTap: onMealTap,
              onTrackDelivery: (deliveryItem) {
                final subscriptionDayId = deliveryItem.subscriptionDayId ??
                    overviewData.selectedDay?.id ??
                    '';
                if (subscriptionDayId.isNotEmpty) {
                  unawaited(
                    Navigator.of(context).pushNamed(
                      AppRoutes.calendarDeliveryDetails,
                      arguments: subscriptionDayId,
                    ),
                  );
                }
              },
              onConfirmSelections:
                  onConfirmSelections ??
                  () {
                    try {
                      unawaited(
                        context.read<CalendarFlowViewModel>().confirmMeals(
                          localeName: locale.localeName,
                        ),
                      );
                    } catch (_) {
                      unawaited(
                        context.read<MealSelectionViewModel>().confirm(
                          localeName: locale.localeName,
                        ),
                      );
                    }
                  },
              isConfirming: isConfirming,
              canConfirm: overviewData.canConfirm,
              isLoading: overviewData.isSelectedDayLoading,
            );
          },
        );
      },
    );
  }
}
