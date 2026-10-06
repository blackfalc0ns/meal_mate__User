import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

sealed class RestaurantPickerEvent {
  const RestaurantPickerEvent();
}

class LoadRestaurantsEvent extends RestaurantPickerEvent {
  const LoadRestaurantsEvent({
    required this.subscriptionId,
    required this.date,
    required this.localeName,
    this.query,
  });

  final String subscriptionId;
  final DateTime date;
  final String localeName;
  final String? query;
}

class SelectRestaurantEvent extends RestaurantPickerEvent {
  const SelectRestaurantEvent({
    required this.subscriptionId,
    required this.date,
    required this.restaurant,
    required this.localeName,
  });

  final String subscriptionId;
  final DateTime date;
  final CalendarRestaurantOptionEntity restaurant;
  final String localeName;
}

class ClearRestaurantPickerEvent extends RestaurantPickerEvent {
  const ClearRestaurantPickerEvent();
}

class LoadMoreRestaurantsEvent extends RestaurantPickerEvent {
  const LoadMoreRestaurantsEvent();
}

class RetryRestaurantsPageEvent extends RestaurantPickerEvent {
  const RetryRestaurantsPageEvent();
}
