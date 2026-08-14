import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_restaurant_details_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_restaurant_details_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_restaurant_details_state.dart';

@injectable
class SubscriptionRestaurantDetailsViewModel
    extends Cubit<SubscriptionRestaurantDetailsState> {
  SubscriptionRestaurantDetailsViewModel(
    this._getSubscriptionRestaurantDetailsUseCase,
  ) : super(const SubscriptionRestaurantDetailsState());

  final GetSubscriptionRestaurantDetailsUseCase
  _getSubscriptionRestaurantDetailsUseCase;

  void doIntent(SubscriptionRestaurantDetailsEvent event) {
    switch (event) {
      case GetSubscriptionRestaurantDetailsEvent():
        _getDetails(
          programId: event.programId,
          bundleId: event.bundleId,
          restaurantId: event.restaurantId,
        );
    }
  }

  Future<void> _getDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
  }) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));

    final result = await _getSubscriptionRestaurantDetailsUseCase(
      programId: programId,
      bundleId: bundleId,
      restaurantId: restaurantId,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isLoading: false, details: result.data));
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }
}
