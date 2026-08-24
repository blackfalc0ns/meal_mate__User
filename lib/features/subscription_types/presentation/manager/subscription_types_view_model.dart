import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_types/domain/usecase/get_subscription_conversion_options_usecase.dart';
import 'package:meal_meat_user/features/subscription_types/domain/usecase/get_subscription_types_usecase.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_event.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_state.dart';

@injectable
class SubscriptionTypesViewModel extends Cubit<SubscriptionTypesState> {
  SubscriptionTypesViewModel(
    this._getSubscriptionTypesUseCase,
    this._getSubscriptionConversionOptionsUseCase,
  ) : super(const SubscriptionTypesState());

  final GetSubscriptionTypesUseCase _getSubscriptionTypesUseCase;
  final GetSubscriptionConversionOptionsUseCase
  _getSubscriptionConversionOptionsUseCase;

  void doIntent(SubscriptionTypesEvent event) {
    switch (event) {
      case GetSubscriptionTypesEvent():
        _getSubscriptionTypes();
      case GetSubscriptionConversionOptionsEvent():
        _getSubscriptionConversionOptions();
    }
  }

  Future<void> _getSubscriptionTypes() async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        isConversionSuccess: false,
        clearFailure: true,
      ),
    );

    final result = await _getSubscriptionTypesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            types: result.data.where((type) => type.code.isNotEmpty).toList(),
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

  Future<void> _getSubscriptionConversionOptions() async {
    emit(
      state.copyWith(
        isConversionLoading: true,
        isConversionSuccess: false,
        clearConversionFailure: true,
      ),
    );

    final result = await _getSubscriptionConversionOptionsUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isConversionLoading: false, isConversionSuccess: true),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isConversionLoading: false,
            isConversionSuccess: false,
            conversionFailure: result.failure,
          ),
        );
    }
  }
}
