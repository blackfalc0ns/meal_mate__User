import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_entity.dart';

class MealDetailsState {
  const MealDetailsState({this.isLoading = false, this.meal, this.failure});

  final bool isLoading;
  final SubscriptionMealDetailsEntity? meal;
  final Failure? failure;

  MealDetailsState copyWith({
    bool? isLoading,
    SubscriptionMealDetailsEntity? meal,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return MealDetailsState(
      isLoading: isLoading ?? this.isLoading,
      meal: meal ?? this.meal,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
