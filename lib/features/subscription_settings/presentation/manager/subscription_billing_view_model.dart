import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/create_subscription_cancellation_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/create_subscription_freeze_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/create_subscription_renewal_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/delete_uncompleted_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_billing_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_cancellation_quote_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_resume_preview_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/resume_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_action_type.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';

@injectable
class SubscriptionBillingViewModel extends Cubit<SubscriptionBillingState> {
  SubscriptionBillingViewModel(
    this._getSubscriptionBillingUseCase,
    this._createSubscriptionRenewalRequestUseCase,
    this._createSubscriptionFreezeRequestUseCase,
    this._getSubscriptionCancellationQuoteUseCase,
    this._createSubscriptionCancellationRequestUseCase,
    this._deleteUncompletedSubscriptionUseCase,
    this._getSubscriptionResumePreviewUseCase,
    this._resumeSubscriptionUseCase,
  ) : super(const SubscriptionBillingState());

  final GetSubscriptionBillingUseCase _getSubscriptionBillingUseCase;
  final CreateSubscriptionRenewalRequestUseCase
  _createSubscriptionRenewalRequestUseCase;
  final CreateSubscriptionFreezeRequestUseCase
  _createSubscriptionFreezeRequestUseCase;
  final GetSubscriptionCancellationQuoteUseCase
  _getSubscriptionCancellationQuoteUseCase;
  final CreateSubscriptionCancellationRequestUseCase
  _createSubscriptionCancellationRequestUseCase;
  final DeleteUncompletedSubscriptionUseCase
  _deleteUncompletedSubscriptionUseCase;
  final GetSubscriptionResumePreviewUseCase
  _getSubscriptionResumePreviewUseCase;
  final ResumeSubscriptionUseCase _resumeSubscriptionUseCase;

  void doIntent(SubscriptionBillingEvent event) {
    switch (event) {
      case GetSubscriptionBillingEvent():
        unawaited(_getBilling());
      case RenewSubscriptionEvent():
        unawaited(_renewSubscription(event.subscriptionId));
      case FreezeSubscriptionEvent():
        unawaited(
          _freezeSubscription(
            subscriptionId: event.subscriptionId,
            request: event.request,
          ),
        );
      case GetCancellationQuoteEvent():
        unawaited(_getCancellationQuote(event.subscriptionId));
      case CancelSubscriptionEvent():
        unawaited(
          _cancelSubscription(
            subscriptionId: event.subscriptionId,
            request: event.request,
          ),
        );
      case ResetBillingActionEvent():
        emit(
          state.copyWith(billingAction: const SubscriptionBillingActionState()),
        );
      case DeleteUncompletedSubscriptionEvent():
        unawaited(_deleteUncompletedSubscription(event.subscriptionId));
      case GetSubscriptionResumePreviewEvent():
        unawaited(_getResumePreview(event.subscriptionId));
      case ResumeSubscriptionEvent():
        unawaited(
          _resumeSubscription(
            subscriptionId: event.subscriptionId,
            startDate: event.startDate,
            paymentMethodId: event.paymentMethodId,
          ),
        );
    }
  }

  Future<void> _getBilling() async {
    emit(
      state.copyWith(
        billing: state.billing.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getSubscriptionBillingUseCase();

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billing: state.billing.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            billing: state.billing.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _renewSubscription(String subscriptionId) async {
    await _runBillingAction(
      type: SubscriptionBillingActionType.renew,
      action: () => _createSubscriptionRenewalRequestUseCase(subscriptionId),
    );
    if (!isClosed && state.billingAction.isSuccess) {
      _getBilling();
    }
  }

  Future<void> _freezeSubscription({
    required String subscriptionId,
    required SubscriptionBillingFreezeRequestEntity request,
  }) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: SubscriptionBillingActionType.freeze,
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearFreezeResult: true,
          pendingFreezeRequest: request,
          pendingFreezeSubscriptionId: subscriptionId,
        ),
      ),
    );

    final result = await _createSubscriptionFreezeRequestUseCase(
      subscriptionId: subscriptionId,
      request: request,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.freeze,
              isLoading: false,
              isSuccess: true,
              freezeResult: result.data,
              clearPendingFreeze: true,
            ),
          ),
        );
        _getBilling();
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.freeze,
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getCancellationQuote(String subscriptionId) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: SubscriptionBillingActionType.quote,
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearQuote: true,
          clearResult: true,
        ),
      ),
    );

    final result = await _getSubscriptionCancellationQuoteUseCase(
      subscriptionId,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.quote,
              isLoading: false,
              isSuccess: true,
              cancellationQuote: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.quote,
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _cancelSubscription({
    required String subscriptionId,
    required SubscriptionBillingCancellationRequestEntity request,
  }) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: SubscriptionBillingActionType.cancel,
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearResult: true,
        ),
      ),
    );

    final result = await _createSubscriptionCancellationRequestUseCase(
      subscriptionId: subscriptionId,
      request: request,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.cancel,
              isLoading: false,
              isSuccess: true,
              cancellationResult: result.data,
            ),
          ),
        );
        _getBilling();
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.cancel,
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _runBillingAction({
    required SubscriptionBillingActionType type,
    required Future<ApiResult<void>> Function() action,
  }) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: type,
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearQuote: true,
          clearResult: true,
        ),
      ),
    );

    final result = await action();

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: type,
              isLoading: false,
              isSuccess: true,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: type,
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _deleteUncompletedSubscription(String subscriptionId) async {
    await _runBillingAction(
      type: SubscriptionBillingActionType.deleteUncompleted,
      action: () => _deleteUncompletedSubscriptionUseCase(subscriptionId),
    );
    if (!isClosed && state.billingAction.isSuccess) {
      _getBilling();
    }
  }

  Future<void> _getResumePreview(String subscriptionId) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: SubscriptionBillingActionType.resumePreview,
          subscriptionId: subscriptionId,
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearResumePreview: true,
          clearResumeResult: true,
        ),
      ),
    );
    final result = await _getSubscriptionResumePreviewUseCase(subscriptionId);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.resumePreview,
              isLoading: false,
              isSuccess: true,
              resumePreview: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.resumePreview,
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _resumeSubscription({
    required String subscriptionId,
    String? startDate,
    int? paymentMethodId,
  }) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: SubscriptionBillingActionType.resume,
          subscriptionId: subscriptionId,
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearResumeResult: true,
        ),
      ),
    );
    final result = await _resumeSubscriptionUseCase(
      subscriptionId: subscriptionId,
      startDate: startDate,
      paymentMethodId: paymentMethodId,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.resume,
              isLoading: false,
              isSuccess: true,
              resumeResult: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: SubscriptionBillingActionType.resume,
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }
}
