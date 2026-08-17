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
      programNameAr: programNameAr ?? '',
      programNameEn: programNameEn ?? '',
      bundleNameAr: bundleNameAr ?? '',
      bundleNameEn: bundleNameEn ?? '',
      tier: tier ?? '',
      tierNameAr: tierNameAr ?? '',
      tierNameEn: tierNameEn ?? '',
      tierLogoUrl: tierLogoUrl ?? '',
      imageUrl: imageUrl ?? '',
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
      messageAr: messageAr ?? '',
      messageEn: messageEn ?? '',
    );
  }
}
