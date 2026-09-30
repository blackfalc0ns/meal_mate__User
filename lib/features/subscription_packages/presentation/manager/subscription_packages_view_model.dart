import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/usecase/get_subscription_packages_usecase.dart';
import 'subscription_packages_event.dart';
import 'subscription_packages_state.dart';

@injectable
class SubscriptionPackagesViewModel extends Cubit<SubscriptionPackagesState> {
  SubscriptionPackagesViewModel(
    this._getSubscriptionPackagesUseCase,
  ) : super(const SubscriptionPackagesState());

  final GetSubscriptionPackagesUseCase _getSubscriptionPackagesUseCase;

  void doIntent(SubscriptionPackagesEvent event) {
    switch (event) {
      case GetSubscriptionPackagesEvent():
        unawaited(_getSubscriptionPackages(event.programId));
    }
  }

  Future<void> _getSubscriptionPackages(String programId) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, clearFailure: true));

    final result = await _getSubscriptionPackagesUseCase(programId);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            bundles: result.data.bundles
                .where((bundle) => bundle.bundleId.isNotEmpty)
                .toList(),
            hasDeliveryAddress: result.data.hasDeliveryAddress,
            hasAllergies: result.data.hasAllergies,
            hasDietaryPreferences: result.data.hasDietaryPreferences,
            isProfileComplete: result.data.isProfileComplete,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }
}
