import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_billing_action_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';

extension SubscriptionBillingUncompletedSubscriptionResponseDtoMapper
    on SubscriptionBillingUncompletedSubscriptionResponseDto {
  SubscriptionBillingUncompletedSubscriptionEntity toEntity() {
    return SubscriptionBillingUncompletedSubscriptionEntity(
      kind: kind ?? 'INDIVIDUAL',
      familyGroupId: familyGroupId,
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
      durationDays: durationDays ?? 0,
      includeFriday: includeFriday ?? false,
      amount: amount ?? 0,
      currencyCode: currencyCode ?? '',
      deliveryAddress: deliveryAddress ?? '',
      createdAtUtc: createdAtUtc,
      isHoldActive: isHoldActive ?? false,
      holdRemainingSeconds: holdRemainingSeconds,
      holdExpiresAtUtc: holdExpiresAtUtc,
      actions:
          actions?.toEntity() ??
          const SubscriptionBillingUncompletedActionsEntity(
            canDelete: false,
            canResume: false,
            deleteEndpoint: '',
            resumeEndpoint: '',
          ),
    );
  }
}

extension SubscriptionBillingUncompletedActionsResponseDtoMapper
    on SubscriptionBillingUncompletedActionsResponseDto {
  SubscriptionBillingUncompletedActionsEntity toEntity() {
    return SubscriptionBillingUncompletedActionsEntity(
      canDelete: canDelete ?? false,
      canResume: canResume ?? false,
      deleteEndpoint: deleteEndpoint ?? '',
      resumeEndpoint: resumeEndpoint ?? '',
      nextScreen: nextScreen,
      retryPaymentEndpoint: retryPaymentEndpoint,
    );
  }
}

extension SubscriptionBillingResumePreviewResponseDtoMapper
    on SubscriptionBillingResumePreviewResponseDto {
  SubscriptionBillingResumePreviewEntity toEntity() {
    return SubscriptionBillingResumePreviewEntity(
      subscriptionId: subscriptionId ?? '',
      status: status ?? '',
      statusNameAr: statusNameAr ?? '',
      programId: programId ?? '',
      programNameAr: programNameAr ?? '',
      bundleNameAr: bundleNameAr ?? '',
      tier: tier ?? '',
      tierNameAr: tierNameAr ?? '',
      durationDays: durationDays ?? 0,
      amount: amount ?? 0,
      currencyCode: currencyCode ?? '',
      canPayDirectly: canPayDirectly ?? false,
      reason: reason,
      holdRemainingSeconds: holdRemainingSeconds,
      holdExpiresAtUtc: holdExpiresAtUtc,
      suggestedStartDate: suggestedStartDate ?? '',
      resumeEndpoint: resumeEndpoint ?? '',
    );
  }
}

extension SubscriptionBillingResumeResponseDtoMapper
    on SubscriptionBillingResumeResponseDto {
  SubscriptionBillingResumeEntity toEntity() {
    return SubscriptionBillingResumeEntity(
      subscriptionId: subscriptionId ?? '',
      paymentUrl: paymentUrl ?? '',
      holdExpiresAtUtc: holdExpiresAtUtc,
      serverTimeUtc: serverTimeUtc,
      finalPrice: finalPrice ?? 0,
      paymentStatus: paymentStatus ?? '',
    );
  }
}

extension SubscriptionBillingCurrentResponseDtoMapper
    on SubscriptionBillingCurrentResponseDto {
  SubscriptionBillingCurrentEntity toEntity() {
    return SubscriptionBillingCurrentEntity(
      subscription: subscription?.toEntity(),
      emptyStateCode: emptyStateCode ?? '',
    );
  }
}

extension SubscriptionBillingSubscriptionResponseDtoMapper
    on SubscriptionBillingSubscriptionResponseDto {
  SubscriptionBillingSubscriptionEntity toEntity() {
    return SubscriptionBillingSubscriptionEntity(
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
          const SubscriptionBillingRestaurantEntity(
            restaurantId: '',
            nameAr: '',
            nameEn: '',
            logoUrl: '',
          ),
      pendingFreeze: pendingFreeze?.toEntity(),
      activeFreeze: activeFreeze?.toEntity(),
      pendingUpgrade: pendingUpgrade?.toEntity(),
      actions:
          actions?.toEntity() ??
          const SubscriptionBillingActionsEntity(
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
            freezeDetailsEndpoint: '',
          ),
    );
  }
}

extension SubscriptionBillingRestaurantResponseDtoMapper
    on SubscriptionBillingRestaurantResponseDto {
  SubscriptionBillingRestaurantEntity toEntity() {
    return SubscriptionBillingRestaurantEntity(
      restaurantId: restaurantId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      logoUrl: logoUrl ?? '',
    );
  }
}

extension SubscriptionBillingActionsResponseDtoMapper
    on SubscriptionBillingActionsResponseDto {
  SubscriptionBillingActionsEntity toEntity() {
    return SubscriptionBillingActionsEntity(
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
      freezeDetailsEndpoint: freezeDetailsEndpoint ?? '',
      freezeNotice: (freezeNotice != null && freezeNotice!.trim().isNotEmpty)
          ? freezeNotice!.trim()
          : null,
      freezeNoticeAr:
          (freezeNoticeAr != null && freezeNoticeAr!.trim().isNotEmpty)
          ? freezeNoticeAr!.trim()
          : null,
    );
  }
}

extension SubscriptionBillingActiveFreezeResponseDtoMapper
    on SubscriptionBillingActiveFreezeResponseDto {
  SubscriptionBillingActiveFreezeEntity toEntity() {
    return SubscriptionBillingActiveFreezeEntity(
      requestId: requestId ?? '',
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      freezeDays: freezeDays ?? 0,
      frozenServiceDaysCount: frozenServiceDaysCount ?? 0,
      status: status ?? '',
      statusNameAr: statusNameAr ?? '',
      isCurrentlyActive: isCurrentlyActive ?? false,
      isUpcoming: isUpcoming ?? false,
      reason: reason ?? '',
      createdAtUtc: createdAtUtc ?? '',
      processedAtUtc: processedAtUtc ?? '',
      frozenServiceDates: frozenServiceDates ?? const [],
      compensationDates: compensationDates ?? const [],
      subscriptionEndDate: subscriptionEndDate ?? '',
      summaryAr: summaryAr ?? '',
      summaryEn: summaryEn ?? '',
    );
  }
}

extension SubscriptionBillingFreezeHistoryResponseDtoMapper
    on SubscriptionBillingFreezeHistoryResponseDto {
  SubscriptionBillingFreezeHistoryEntity toEntity() {
    return SubscriptionBillingFreezeHistoryEntity(
      requestId: requestId ?? '',
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      freezeDays: freezeDays ?? 0,
      status: status ?? '',
      statusNameAr: statusNameAr ?? '',
      reason: reason ?? '',
      createdAtUtc: createdAtUtc ?? '',
      processedAtUtc: processedAtUtc ?? '',
    );
  }
}

extension SubscriptionBillingFreezeDetailsResponseDtoMapper
    on SubscriptionBillingFreezeDetailsResponseDto {
  SubscriptionBillingFreezeDetailsEntity toEntity() {
    return SubscriptionBillingFreezeDetailsEntity(
      subscriptionId: subscriptionId ?? '',
      subscriptionStatus: subscriptionStatus ?? '',
      subscriptionStatusNameAr: subscriptionStatusNameAr ?? '',
      hasFreeze: hasFreeze ?? false,
      isCurrentlyFrozen: isCurrentlyFrozen ?? false,
      currentFreeze: currentFreeze?.toEntity(),
      freezeHistory:
          freezeHistory?.map((history) => history.toEntity()).toList() ??
          const [],
      noticeAr: noticeAr ?? '',
      noticeEn: noticeEn ?? '',
    );
  }
}

extension SubscriptionBillingPendingFreezeResponseDtoMapper
    on SubscriptionBillingPendingFreezeResponseDto {
  SubscriptionBillingPendingFreezeEntity toEntity() {
    return SubscriptionBillingPendingFreezeEntity(
      requestId: requestId ?? '',
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      freezeDays: freezeDays ?? 0,
      status: status ?? '',
    );
  }
}

extension SubscriptionBillingPendingUpgradeResponseDtoMapper
    on SubscriptionBillingPendingUpgradeResponseDto {
  SubscriptionBillingPendingUpgradeEntity toEntity() {
    return SubscriptionBillingPendingUpgradeEntity(
      requestId: requestId ?? '',
      fromTier: fromTier ?? '',
      toTier: toTier ?? '',
      priceDifference: priceDifference ?? 0,
      status: status ?? '',
    );
  }
}

extension SubscriptionBillingPaymentMethodResponseDtoMapper
    on SubscriptionBillingPaymentMethodResponseDto {
  SubscriptionBillingPaymentMethodEntity toEntity() {
    return SubscriptionBillingPaymentMethodEntity(
      hasSavedMethod: hasSavedMethod ?? false,
      brand: brand ?? '',
      last4: last4 ?? '',
      expiry: expiry ?? '',
      gateway: gateway ?? '',
      emptyStateCode: emptyStateCode ?? '',
    );
  }
}

extension SubscriptionBillingInvoiceResponseDtoMapper
    on SubscriptionBillingInvoiceResponseDto {
  SubscriptionBillingInvoiceEntity toEntity() {
    return SubscriptionBillingInvoiceEntity(
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

extension SubscriptionBillingFreezePolicyResponseDtoMapper
    on SubscriptionBillingFreezePolicyResponseDto {
  SubscriptionBillingFreezePolicyEntity toEntity() {
    return SubscriptionBillingFreezePolicyEntity(
      defaultDurationDays: defaultDurationDays ?? 0,
      startDelayDays: startDelayDays ?? 0,
      extendSubscriptionEnd: extendSubscriptionEnd ?? false,
      earliestAllowedStartDate: earliestAllowedStartDate ?? '',
      messageAr: messageAr ?? message ?? '',
      messageEn: messageEn ?? message ?? '',
      message: message ?? messageAr ?? '',
      noticeAr: noticeAr ?? notice ?? '',
      notice: notice ?? noticeAr ?? '',
    );
  }
}

extension SubscriptionBillingFreezeRequestEntityMapper
    on SubscriptionBillingFreezeRequestEntity {
  SubscriptionBillingFreezeRequestDto toDto() {
    return SubscriptionBillingFreezeRequestDto(
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      acknowledgeLostSelections: acknowledgeLostSelections ? true : null,
    );
  }
}

extension SubscriptionBillingCancellationRequestEntityMapper
    on SubscriptionBillingCancellationRequestEntity {
  SubscriptionBillingCancellationRequestDto toDto() {
    return SubscriptionBillingCancellationRequestDto(
      reason: reason,
      requestedEffectiveDate: requestedEffectiveDate,
    );
  }
}

extension SubscriptionBillingCancellationQuoteResponseDtoMapper
    on SubscriptionBillingCancellationQuoteResponseDto {
  SubscriptionBillingCancellationQuoteEntity toEntity() {
    return SubscriptionBillingCancellationQuoteEntity(
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
      cancellationFeeAmount: cancellationFeeAmount ?? 0.0,
      netRefundAmount: netRefundAmount ?? 0.0,
      refundToCashWallet: refundToCashWallet ?? true,
      policyMessageEn: policyMessageEn,
      messageCode: messageCode,
      payerCustomerUserId: payerCustomerUserId,
      batchId: batchId,
    );
  }
}

extension SubscriptionBillingCancellationResultResponseDtoMapper
    on SubscriptionBillingCancellationResultResponseDto {
  SubscriptionBillingCancellationResultEntity toEntity() {
    return SubscriptionBillingCancellationResultEntity(
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
      cancellationFeeAmount: cancellationFeeAmount ?? 0.0,
      netRefundAmount: netRefundAmount ?? 0.0,
      refundedToWallet: refundedToWallet ?? false,
      messageEn: messageEn,
      messageCode: messageCode,
      payerCustomerUserId: payerCustomerUserId,
      settlementId: settlementId,
      batchId: batchId,
    );
  }
}

extension SubscriptionBillingFreezeResponseDtoMapper
    on SubscriptionBillingFreezeResponseDto {
  SubscriptionBillingFreezeResponseEntity toEntity() {
    return SubscriptionBillingFreezeResponseEntity(
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
