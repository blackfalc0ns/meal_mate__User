import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_deadline_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_current_restaurant_card.dart';

class FamilyDayMealsRestaurantSection extends StatelessWidget {
  const FamilyDayMealsRestaurantSection({
    super.key,
    required this.onOpenRestaurants,
  });

  final VoidCallback onOpenRestaurants;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      FamilyCalendarViewModel,
      FamilyCalendarState,
      ({
        String restaurantName,
        CalendarDayEntity? day,
        bool canChangeRestaurant,
      })
    >(
      selector: (state) => (
        restaurantName: state.selectedDay?.restaurant?.name ?? '',
        day: state.selectedDay,
        canChangeRestaurant: state.canSelectRestaurant,
      ),
      builder: (context, data) => CalendarDeadlineBuilder(
        day: data.day,
        builder: (context) {
          return FamilyDayCurrentRestaurantCard(
            restaurantName: data.restaurantName,
            onChangeRestaurant:
                data.canChangeRestaurant && data.day?.isEditable == true
                ? onOpenRestaurants
                : null,
          );
        },
      ),
    );
  }
}
