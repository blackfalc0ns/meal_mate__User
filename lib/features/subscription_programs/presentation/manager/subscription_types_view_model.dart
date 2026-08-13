import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_types_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_types_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_types_state.dart';

@injectable
class SubscriptionTypesViewModel extends Cubit<SubscriptionTypesState> {
  SubscriptionTypesViewModel(this._getSubscriptionTypesUseCase)
    : super(const SubscriptionTypesState());

  final GetSubscriptionTypesUseCase _getSubscriptionTypesUseCase;

  void doIntent(SubscriptionTypesEvent event) {
    switch (event) {
      case GetSubscriptionTypesEvent():
        _getSubscriptionTypes();
    }
  }

  Future<void> _getSubscriptionTypes() async {
    emit(state.copyWith(isLoading: true, isSuccess: false, clearFailure: true));

    final result = await _getSubscriptionTypesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            types: result.data
                .where((type) => type.code.isNotEmpty && type.isAvailable)
                .toList(),
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
