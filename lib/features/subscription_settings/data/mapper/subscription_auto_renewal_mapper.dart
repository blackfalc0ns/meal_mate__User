import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_auto_renewal_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_auto_renewal_entity.dart';

extension SubscriptionAutoRenewalMapper on SubscriptionAutoRenewalDto {
  SubscriptionAutoRenewalEntity toEntity() => SubscriptionAutoRenewalEntity(
    subscriptionId: subscriptionId,
    consentActive: consentActive,
    consentVersion: consentVersion,
    consentAmount: consentAmount,
    currency: currency,
    consentActorUserId: consentActorUserId,
    withdrawnByUserId: withdrawnByUserId,
    consentedAtUtc: consentedAtUtc,
    withdrawnAtUtc: withdrawnAtUtc,
    billingStatus: billingStatus,
    requiresPaymentSetup: requiresPaymentSetup,
    autoChargeEnabled: autoChargeEnabled,
  );
}
