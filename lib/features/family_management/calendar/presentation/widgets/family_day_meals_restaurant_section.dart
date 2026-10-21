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
      ({String restaurantName, bool canChangeRestaurant})
    >(
      selector: (state) => (
        restaurantName: state.selectedDay?.restaurant?.name ?? '',
        canChangeRestaurant:
            state.selectedDay?.isEditable == true && state.canSelectRestaurant,
      ),
      builder: (context, data) {
        return FamilyDayCurrentRestaurantCard(
          restaurantName: data.restaurantName,
          onChangeRestaurant: data.canChangeRestaurant
              ? onOpenRestaurants
              : null,
        );
      },
    );
  }
}
