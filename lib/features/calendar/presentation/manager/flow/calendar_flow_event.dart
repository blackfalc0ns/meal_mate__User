import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

sealed class CalendarFlowEvent {
  const CalendarFlowEvent();
}

class StartRestaurantPickerFlowEvent extends CalendarFlowEvent {
  const StartRestaurantPickerFlowEvent(this.localeName);

  final String localeName;
}

class AcceptRestaurantFlowEvent extends CalendarFlowEvent {
  const AcceptRestaurantFlowEvent({
    required this.restaurant,
    required this.localeName,
  });

  final CalendarRestaurantOptionEntity restaurant;
  final String localeName;
}

class SaveMealsFlowEvent extends CalendarFlowEvent {
  const SaveMealsFlowEvent(this.localeName);

  final String localeName;
}

class ConfirmMealsFlowEvent extends CalendarFlowEvent {
  const ConfirmMealsFlowEvent(this.localeName);

  final String localeName;
}
