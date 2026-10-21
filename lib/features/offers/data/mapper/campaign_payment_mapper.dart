import 'package:meal_meat_user/features/offers/data/models/request/start_campaign_payment_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_payment_response_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';

extension StartCampaignPaymentRequestEntityMapper
    on StartCampaignPaymentRequestEntity {
  StartCampaignPaymentRequestDto toDto() {
    return StartCampaignPaymentRequestDto(
      idempotencyKey: idempotencyKey,
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      paymentMethodId: paymentMethodId,
    );
  }
}

extension CampaignPaymentResponseDtoMapper on CampaignPaymentResponseDto {
  CampaignPaymentEntity toEntity() {
    final raw = status ?? '';
    final normalized = raw.trim().toLowerCase();
    final CampaignPaymentStatus resolvedStatus;

    if (isPaid == true) {
      resolvedStatus = CampaignPaymentStatus.paid;
    } else if (isFailed == true ||
        (normalized == 'failed' || normalized == 'paymentfailed')) {
      resolvedStatus = CampaignPaymentStatus.failed;
    } else if (normalized == 'expired') {
      resolvedStatus = CampaignPaymentStatus.expired;
    } else if (normalized == 'cancelled' || normalized == 'canceled') {
      resolvedStatus = CampaignPaymentStatus.cancelled;
    } else if (normalized == 'pending' ||
        normalized == 'paymentpending' ||
        normalized == 'committing' ||
        normalized == 'paid' ||
        normalized == 'completed') {
      resolvedStatus = CampaignPaymentStatus.pending;
    } else {
      resolvedStatus = raw.isEmpty
          ? CampaignPaymentStatus.pending
          : CampaignPaymentStatus.unknown;
    }

    return CampaignPaymentEntity(
      sessionId: sessionId ?? '',
      status: resolvedStatus,
      rawStatus: raw,
      paymentId: paymentId,
      paymentUrl: paymentUrl,
      amount: amount,
      currency: currency ?? 'KWD',
      expiresAtUtc: expiresAtUtc != null
          ? DateTime.tryParse(expiresAtUtc!)
          : null,
      isPaid: isPaid,
      isFailed: isFailed,
      subscriptionId: subscriptionId,
    );
  }
}
