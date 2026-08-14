import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';

class SubscriptionRestaurantDetailsState {
  const SubscriptionRestaurantDetailsState({
    this.isLoading = false,
    this.details,
    this.failure,
  });

  final bool isLoading;
  final SubscriptionRestaurantDetailsEntity? details;
  final Failure? failure;

  SubscriptionRestaurantDetailsState copyWith({
    bool? isLoading,
    SubscriptionRestaurantDetailsEntity? details,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return SubscriptionRestaurantDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
