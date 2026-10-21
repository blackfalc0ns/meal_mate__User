import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';

class CampaignPaymentState {
  const CampaignPaymentState({
    this.isLoading = false,
    this.isPolling = false,
    this.sessionId,
    this.paymentId,
    this.paymentUrl,
    this.amount,
    this.currency = 'KWD',
    this.expiresAtUtc,
    this.subscriptionId,
    this.status = CampaignPaymentStatus.pending,
    this.rawStatus,
    this.failure,
    this.serverErrorCode,
    this.idempotencyKey,
    this.paymentMethodId = 3,
    this.pollAttemptCount = 0,
  });

  final bool isLoading;
  final bool isPolling;
  final String? sessionId;
  final String? paymentId;
  final String? paymentUrl;
  final double? amount;
  final String currency;
  final DateTime? expiresAtUtc;
  final String? subscriptionId;
  final CampaignPaymentStatus status;
  final String? rawStatus;
  final Failure? failure;
  final String? serverErrorCode;
  final String? idempotencyKey;
  final int paymentMethodId;
  final int pollAttemptCount;

  bool get isSuccess =>
      status == CampaignPaymentStatus.paid &&
      subscriptionId?.isNotEmpty == true;
  bool get isFailed => status == CampaignPaymentStatus.failed;
  bool get isExpired => status == CampaignPaymentStatus.expired;
  bool get isCancelled => status == CampaignPaymentStatus.cancelled;
  bool get isTerminal =>
      status == CampaignPaymentStatus.paid ? isSuccess : status.isTerminal;
  bool get canRetry =>
      !isLoading &&
      !isPolling &&
      (failure != null || (isTerminal && !isSuccess));

  CampaignPaymentState copyWith({
    bool? isLoading,
    bool? isPolling,
    String? sessionId,
    String? paymentId,
    String? paymentUrl,
    double? amount,
    String? currency,
    DateTime? expiresAtUtc,
    String? subscriptionId,
    CampaignPaymentStatus? status,
    String? rawStatus,
    Failure? failure,
    bool clearFailure = false,
    String? serverErrorCode,
    bool clearServerErrorCode = false,
    String? idempotencyKey,
    int? paymentMethodId,
    int? pollAttemptCount,
  }) {
    return CampaignPaymentState(
      isLoading: isLoading ?? this.isLoading,
      isPolling: isPolling ?? this.isPolling,
      sessionId: sessionId ?? this.sessionId,
      paymentId: paymentId ?? this.paymentId,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      expiresAtUtc: expiresAtUtc ?? this.expiresAtUtc,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      status: status ?? this.status,
      rawStatus: rawStatus ?? this.rawStatus,
      failure: clearFailure ? null : (failure ?? this.failure),
      serverErrorCode: clearServerErrorCode
          ? null
          : (serverErrorCode ?? this.serverErrorCode),
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      pollAttemptCount: pollAttemptCount ?? this.pollAttemptCount,
    );
  }
}
