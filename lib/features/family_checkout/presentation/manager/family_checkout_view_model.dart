import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/checkout_family_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/get_family_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/get_family_summary_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_event.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilyCheckoutViewModel extends Cubit<FamilyPlanState> {
  FamilyCheckoutViewModel(
    this._getFamilyFlowCurrentUseCase,
    this._getFamilySummaryUseCase,
    this._getFamilyPaymentMethodsUseCase,
    this._checkoutFamilySubscriptionUseCase,
  ) : super(const FamilyPlanState());

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final GetFamilySummaryUseCase _getFamilySummaryUseCase;
  final GetFamilyPaymentMethodsUseCase _getFamilyPaymentMethodsUseCase;
  final CheckoutFamilySubscriptionUseCase _checkoutFamilySubscriptionUseCase;

  void doIntent(FamilyPlanEvent event) {
    switch (event) {
      case GetFamilySubscriptionCurrentEvent():
        _getFamilySubscriptionCurrent();
      case GetFamilySummaryEvent():
        _getFamilySummary(memberId: event.memberId);
      case SelectFamilyPaymentMethodEvent():
        emit(state.copyWith(selectedPaymentMethod: event.paymentMethod));
      case CheckoutFamilySubscriptionEvent():
        _checkoutFamilySubscription(
          callbackUrl: event.callbackUrl,
          errorUrl: event.errorUrl,
          paymentMethodId: event.paymentMethodId,
        );
    }
  }

  Future<void> _getFamilySubscriptionCurrent() async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _getFamilySummary({String? memberId}) async {
    emit(
      state.copyWith(
        isSummaryLoading: true,
        selectedSummaryMemberId: memberId ?? state.selectedSummaryMemberId,
        clearFailure: true,
      ),
    );
    final result = await _getFamilySummaryUseCase(memberId: memberId);
    switch (result) {
      case ApiSuccessResult():
        final summary = result.data;
        final activeMemberId =
            memberId ??
            summary.selectedMember?.memberId ??
            state.selectedSummaryMemberId;
        emit(
          state.copyWith(
            isSummaryLoading: false,
            summary: summary,
            selectedSummaryMemberId: activeMemberId,
          ),
        );
        _getFamilyPaymentMethods();
      case ApiErrorResult():
        emit(state.copyWith(isSummaryLoading: false, failure: result.failure));
    }
  }

  Future<void> _getFamilyPaymentMethods() async {
    final amount = state.summary?.finalPrice ?? 0.0;
    final result = await _getFamilyPaymentMethodsUseCase(amount);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            paymentMethods: result.data,
            selectedPaymentMethod:
                state.selectedPaymentMethod ??
                (result.data.isNotEmpty ? result.data.first : null),
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(failure: result.failure));
    }
  }

  Future<void> _checkoutFamilySubscription({
    required String callbackUrl,
    required String errorUrl,
    required int paymentMethodId,
  }) async {
    emit(state.copyWith(isCheckoutLoading: true, clearFailure: true));
    final result = await _checkoutFamilySubscriptionUseCase(
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      paymentMethodId: paymentMethodId,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCheckoutLoading: false, checkoutResult: result.data),
        );
      case ApiErrorResult():
        emit(state.copyWith(isCheckoutLoading: false, failure: result.failure));
    }
  }
}
