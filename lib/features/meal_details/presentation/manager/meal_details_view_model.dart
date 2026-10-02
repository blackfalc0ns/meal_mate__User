import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/meal_details/domain/usecase/get_subscription_meal_details_usecase.dart';
import 'package:meal_meat_user/features/meal_details/presentation/manager/meal_details_event.dart';
import 'package:meal_meat_user/features/meal_details/presentation/manager/meal_details_state.dart';

@injectable
class MealDetailsViewModel extends Cubit<MealDetailsState> {
  MealDetailsViewModel(this._getSubscriptionMealDetailsUseCase)
    : super(const MealDetailsState());

  final GetSubscriptionMealDetailsUseCase _getSubscriptionMealDetailsUseCase;

  Future<void> doIntent(MealDetailsEvent event) async {
    switch (event) {
      case GetMealDetailsEvent():
        await _getDetails(
          programId: event.programId,
          bundleId: event.bundleId,
          restaurantId: event.restaurantId,
          mealId: event.mealId,
        );
    }
  }

  Future<void> _getDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
    required String mealId,
  }) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));

    final result = await _getSubscriptionMealDetailsUseCase(
      programId: programId,
      bundleId: bundleId,
      restaurantId: restaurantId,
      mealId: mealId,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isLoading: false, meal: result.data));
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }
}
