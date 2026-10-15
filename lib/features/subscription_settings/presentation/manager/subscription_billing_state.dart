import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_action_type.dart';

class SubscriptionBillingState {
  const SubscriptionBillingState({
    this.billing = const SubscriptionBillingDataState(),
    this.billingAction = const SubscriptionBillingActionState(),
  });

  final SubscriptionBillingDataState billing;
  final SubscriptionBillingActionState billingAction;

  SubscriptionBillingState copyWith({
    SubscriptionBillingDataState? billing,
    SubscriptionBillingActionState? billingAction,
  }) {
    return SubscriptionBillingState(
      billing: billing ?? this.billing,
      billingAction: billingAction ?? this.billingAction,
    );
  }
}

class SubscriptionBillingDataState {
  const SubscriptionBillingDataState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final SubscriptionBillingEntity? data;
  final Failure? failure;

  SubscriptionBillingDataState copyWith({
    bool? isLoading,
    bool? isSuccess,
    SubscriptionBillingEntity? data,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return SubscriptionBillingDataState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class SubscriptionBillingActionState {
  const SubscriptionBillingActionState({
    this.type,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.failure,
    this.cancellationQuote,
    this.cancellationResult,
    this.freezeResult,
    this.pendingFreezeRequest,
    this.pendingFreezeSubscriptionId,
    this.resumePreview,
    this.resumeResult,
    this.subscriptionId,
  });

  final SubscriptionBillingActionType? type;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Failure? failure;
  final SubscriptionBillingCancellationQuoteEntity? cancellationQuote;
  final SubscriptionBillingCancellationResultEntity? cancellationResult;
  final SubscriptionBillingFreezeResponseEntity? freezeResult;
  final SubscriptionBillingFreezeRequestEntity? pendingFreezeRequest;
  final String? pendingFreezeSubscriptionId;
  final SubscriptionBillingResumePreviewEntity? resumePreview;
  final SubscriptionBillingResumeEntity? resumeResult;
  final String? subscriptionId;

  SubscriptionBillingActionState copyWith({
    SubscriptionBillingActionType? type,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Failure? failure,
    SubscriptionBillingCancellationQuoteEntity? cancellationQuote,
    SubscriptionBillingCancellationResultEntity? cancellationResult,
    SubscriptionBillingFreezeResponseEntity? freezeResult,
    SubscriptionBillingFreezeRequestEntity? pendingFreezeRequest,
    String? pendingFreezeSubscriptionId,
    SubscriptionBillingResumePreviewEntity? resumePreview,
    SubscriptionBillingResumeEntity? resumeResult,
    String? subscriptionId,
    bool clearError = false,
    bool clearQuote = false,
    bool clearResult = false,
    bool clearFreezeResult = false,
    bool clearType = false,
    bool clearPendingFreeze = false,
    bool clearResumePreview = false,
    bool clearResumeResult = false,
  }) {
    return SubscriptionBillingActionState(
      type: clearType ? null : type ?? this.type,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
      cancellationQuote: clearQuote
          ? null
          : cancellationQuote ?? this.cancellationQuote,
      cancellationResult: clearResult
          ? null
          : cancellationResult ?? this.cancellationResult,
      freezeResult: clearFreezeResult
          ? null
          : freezeResult ?? this.freezeResult,
      pendingFreezeRequest: clearPendingFreeze
          ? null
          : pendingFreezeRequest ?? this.pendingFreezeRequest,
      pendingFreezeSubscriptionId: clearPendingFreeze
          ? null
          : pendingFreezeSubscriptionId ?? this.pendingFreezeSubscriptionId,
      resumePreview: clearResumePreview
          ? null
          : resumePreview ?? this.resumePreview,
      resumeResult: clearResumeResult
          ? null
          : resumeResult ?? this.resumeResult,
      subscriptionId: subscriptionId ?? this.subscriptionId,
    );
  }
}
