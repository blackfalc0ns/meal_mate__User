import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_view_model.dart';

class FamilyMealSelectionArgs {
  const FamilyMealSelectionArgs({
    required this.subscriptionId,
    required this.date,
    required this.memberName,
    this.slot = '',
    this.restaurant,
    this.restaurantName = '',
    this.viewModel,
  });

  final String subscriptionId;
  final DateTime date;
  final String memberName;
  final String slot;
  final CalendarRestaurantOptionEntity? restaurant;
  final String restaurantName;
  final FamilyCalendarViewModel? viewModel;
}
