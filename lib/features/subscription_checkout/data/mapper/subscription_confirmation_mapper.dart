import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_confirmation_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_confirmation_entity.dart';

extension SubscriptionConfirmationResponseDtoMapper
    on SubscriptionConfirmationResponseDto {
  SubscriptionConfirmationEntity toEntity() {
    return SubscriptionConfirmationEntity(
      subscriptionId: subscriptionId ?? '',
      status: status ?? 'Active',
      programNameAr: programNameAr ?? '',
      programNameEn: programNameEn ?? '',
      bundleNameAr: bundleNameAr ?? '',
      bundleNameEn: bundleNameEn ?? '',
      startDate: startDate,
      endDate: endDate,
      paidAmount: paidAmount ?? 0.0,
      appliedDiscount: appliedDiscount ?? 0.0,
      currency: currency ?? 'KWD',
      referralShareCode: referralShareCode,
      referralShareMessage: referralShareMessage,
      referralShareUrl: referralShareUrl,
    );
  }
}
