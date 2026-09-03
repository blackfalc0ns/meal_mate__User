import 'package:meal_meat_user/features/profile/data/models/request/profile_billing_action_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/profile_billing_response_dto.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';

extension ProfileBillingCurrentResponseDtoMapper
    on ProfileBillingCurrentResponseDto {
  ProfileBillingCurrentEntity toEntity() {
    return ProfileBillingCurrentEntity(
      subscription: subscription?.toEntity(),
      emptyStateCode: emptyStateCode ?? '',
    );
  }
}

extension ProfileBillingSubscriptionResponseDtoMapper
    on ProfileBillingSubscriptionResponseDto {
  ProfileBillingSubscriptionEntity toEntity() {
    return ProfileBillingSubscriptionEntity(
      subscriptionId: subscriptionId ?? '',
      status: status ?? '',
      statusNameAr: statusNameAr ?? '',
      programId: programId ?? '',
      programNameAr: programNameAr ?? '',
      programNameEn: programNameEn ?? '',
      bundleId: bundleId ?? '',
      bundleNameAr: bundleNameAr ?? '',
      bundleNameEn: bundleNameEn ?? '',
      tier: tier ?? '',
      tierNameAr: tierNameAr ?? '',
      tierNameEn: tierNameEn ?? '',
      tierLogoUrl: tierLogoUrl ?? '',
      mealsPerDay: mealsPerDay ?? 0,
      imageUrl: imageUrl ?? '',
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      nextRenewalDate: nextRenewalDate ?? '',
      totalServiceDays: totalServiceDays ?? 0,
      completedServiceDays: completedServiceDays ?? 0,
      remainingServiceDays: remainingServiceDays ?? 0,
      progressPercentage: progressPercentage ?? 0,
      paidAmount: paidAmount ?? 0,
      currencyCode: currencyCode ?? '',
      restaurant:
          restaurant?.toEntity() ??
          const ProfileBillingRestaurantEntity(
            restaurantId: '',
            nameAr: '',
            nameEn: '',
            logoUrl: '',
          ),
      pendingFreeze: pendingFreeze?.toEntity(),
      pendingUpgrade: pendingUpgrade?.toEntity(),
      actions:
          actions?.toEntity() ??
          const ProfileBillingActionsEntity(
            canRenew: false,
            canFreeze: false,
            canCancel: false,
            canUpgrade: false,
            renewUnavailableReason: '',
            freezeUnavailableReason: '',
            cancelUnavailableReason: '',
            upgradeUnavailableReason: '',
      freezeStartDelayDays: 0,
      maximumFreezeDays: 0,
      freezeExtendsSubscriptionEnd: false,
      earliestFreezeStartDate: '',
      renewalEndpoint: '',
      freezeEndpoint: '',
      cancellationEndpoint: '',
            upgradeEndpoint: '',
            cancellationQuoteEndpoint: '',
          ),
    );
  }
}

extension ProfileBillingRestaurantResponseDtoMapper
    on ProfileBillingRestaurantResponseDto {
  ProfileBillingRestaurantEntity toEntity() {
    return ProfileBillingRestaurantEntity(
      restaurantId: restaurantId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      logoUrl: logoUrl ?? '',
    );
  }
}

extension ProfileBillingActionsResponseDtoMapper
    on ProfileBillingActionsResponseDto {
  ProfileBillingActionsEntity toEntity() {
    return ProfileBillingActionsEntity(
      canRenew: canRenew ?? false,
      canFreeze: canFreeze ?? false,
      canCancel: canCancel ?? false,
      canUpgrade: canUpgrade ?? false,
      renewUnavailableReason: renewUnavailableReason ?? '',
      freezeUnavailableReason: freezeUnavailableReason ?? '',
      cancelUnavailableReason: cancelUnavailableReason ?? '',
      upgradeUnavailableReason: upgradeUnavailableReason ?? '',
      freezeStartDelayDays: freezeStartDelayDays ?? 0,
      maximumFreezeDays: maximumFreezeDays ?? 0,
      freezeExtendsSubscriptionEnd: freezeExtendsSubscriptionEnd ?? false,
      earliestFreezeStartDate: earliestFreezeStartDate ?? '',
      renewalEndpoint: renewalEndpoint ?? '',
      freezeEndpoint: freezeEndpoint ?? '',
      cancellationEndpoint: cancellationEndpoint ?? '',
      upgradeEndpoint: upgradeEndpoint ?? '',
      cancellationQuoteEndpoint: cancellationQuoteEndpoint ?? '',
    );
  }
}

extension ProfileBillingPendingFreezeResponseDtoMapper
    on ProfileBillingPendingFreezeResponseDto {
  ProfileBillingPendingFreezeEntity toEntity() {
    return ProfileBillingPendingFreezeEntity(
      requestId: requestId ?? '',
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      freezeDays: freezeDays ?? 0,
      status: status ?? '',
    );
  }
}

extension ProfileBillingPendingUpgradeResponseDtoMapper
    on ProfileBillingPendingUpgradeResponseDto {
  ProfileBillingPendingUpgradeEntity toEntity() {
    return ProfileBillingPendingUpgradeEntity(
      requestId: requestId ?? '',
      fromTier: fromTier ?? '',
      toTier: toTier ?? '',
      priceDifference: priceDifference ?? 0,
      status: status ?? '',
    );
  }
}

extension ProfileBillingPaymentMethodResponseDtoMapper
    on ProfileBillingPaymentMethodResponseDto {
  ProfileBillingPaymentMethodEntity toEntity() {
    return ProfileBillingPaymentMethodEntity(
      hasSavedMethod: hasSavedMethod ?? false,
      brand: brand ?? '',
      last4: last4 ?? '',
      expiry: expiry ?? '',
      gateway: gateway ?? '',
      emptyStateCode: emptyStateCode ?? '',
    );
  }
}

extension ProfileBillingInvoiceResponseDtoMapper
    on ProfileBillingInvoiceResponseDto {
  ProfileBillingInvoiceEntity toEntity() {
    return ProfileBillingInvoiceEntity(
      receiptId: receiptId ?? '',
      subscriptionId: subscriptionId ?? '',
      invoiceNumber: invoiceNumber ?? '',
      paymentId: paymentId ?? '',
      issuedAtUtc: issuedAtUtc ?? '',
      amount: amount ?? 0,
      currencyCode: currencyCode ?? '',
      status: status ?? '',
      statusNameAr: statusNameAr ?? '',
      gateway: gateway ?? '',
      maskedCardNumber: maskedCardNumber ?? '',
      canDownload: canDownload ?? false,
      downloadUnavailableReason: downloadUnavailableReason ?? '',
    );
  }
}

extension ProfileBillingFreezePolicyResponseDtoMapper
    on ProfileBillingFreezePolicyResponseDto {
  ProfileBillingFreezePolicyEntity toEntity() {
    return ProfileBillingFreezePolicyEntity(
      defaultDurationDays: defaultDurationDays ?? 0,
      startDelayDays: startDelayDays ?? 0,
      extendSubscriptionEnd: extendSubscriptionEnd ?? false,
      earliestAllowedStartDate: earliestAllowedStartDate ?? '',
      messageAr: messageAr ?? '',
      messageEn: messageEn ?? '',
    );
  }
}

extension ProfileBillingFreezeRequestEntityMapper
    on ProfileBillingFreezeRequestEntity {
  ProfileBillingFreezeRequestDto toDto() {
    return ProfileBillingFreezeRequestDto(
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
  }
}

extension ProfileBillingCancellationRequestEntityMapper
    on ProfileBillingCancellationRequestEntity {
  ProfileBillingCancellationRequestDto toDto() {
    return ProfileBillingCancellationRequestDto(
      reason: reason,
      requestedEffectiveDate: requestedEffectiveDate,
    );
  }
}

extension ProfileBillingCancellationQuoteResponseDtoMapper
    on ProfileBillingCancellationQuoteResponseDto {
  ProfileBillingCancellationQuoteEntity toEntity() {
    return ProfileBillingCancellationQuoteEntity(
      subscriptionId: subscriptionId ?? '',
      totalServiceDays: totalServiceDays ?? 0,
      deliveredDays: deliveredDays ?? 0,
      lockedKitchenDays: lockedKitchenDays ?? 0,
      refundableDays: refundableDays ?? 0,
      dailyBoxPrice: dailyBoxPrice ?? 0,
      refundAmount: refundAmount ?? 0,
      currencyCode: currencyCode ?? '',
      effectiveCancellationDate: effectiveCancellationDate ?? '',
      policyMessageAr: policyMessageAr ?? '',
    );
  }
}

extension ProfileBillingCancellationResultResponseDtoMapper
    on ProfileBillingCancellationResultResponseDto {
  ProfileBillingCancellationResultEntity toEntity() {
    return ProfileBillingCancellationResultEntity(
      requestId: requestId ?? '',
      subscriptionId: subscriptionId ?? '',
      status: status ?? '',
      statusNameAr: statusNameAr ?? '',
      totalServiceDays: totalServiceDays ?? 0,
      deliveredDays: deliveredDays ?? 0,
      lockedKitchenDays: lockedKitchenDays ?? 0,
      refundableDays: refundableDays ?? 0,
      dailyBoxPrice: dailyBoxPrice ?? 0,
      refundAmount: refundAmount ?? 0,
      currencyCode: currencyCode ?? '',
      effectiveCancellationDate: effectiveCancellationDate ?? '',
      messageAr: messageAr ?? '',
      timestampUtc: timestampUtc ?? '',
    );
  }
}

extension ProfileBillingFreezeResponseDtoMapper
    on ProfileBillingFreezeResponseDto {
  ProfileBillingFreezeResponseEntity toEntity() {
    return ProfileBillingFreezeResponseEntity(
      id: id ?? '',
      subscriptionId: subscriptionId ?? '',
      freezeStartDate: freezeStartDate ?? '',
      freezeEndDate: freezeEndDate ?? '',
      freezeDays: freezeDays ?? 0,
      reason: reason ?? '',
      status: status ?? '',
      approvedByUserId: approvedByUserId,
      processedAtUtc: processedAtUtc ?? '',
      createdAtUtc: createdAtUtc ?? '',
    );
  }
}
