import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';

@injectable
class SubscriptionSummaryViewModel extends Cubit<SubscriptionSummaryState> {
  SubscriptionSummaryViewModel(this._getSubscriptionSummaryUseCase)
    : super(const SubscriptionSummaryState());

  final GetSubscriptionSummaryUseCase _getSubscriptionSummaryUseCase;

  void doIntent(SubscriptionSummaryEvent event) {
    switch (event) {
      case GetSubscriptionSummaryEvent():
        _getSummary(event.request);
    }
  }

  Future<void> _getSummary(SubscriptionSummaryRequestEntity request) async {
    emit(
      state.copyWith(isLoading: true, clearSummary: true, clearFailure: true),
    );

    final result = await _getSubscriptionSummaryUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            summary: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }
}
