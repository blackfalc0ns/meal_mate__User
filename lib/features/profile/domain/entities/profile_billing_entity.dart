class ProfileBillingEntity {
  const ProfileBillingEntity({
    required this.current,
    required this.invoices,
    required this.paymentMethod,
    required this.freezePolicy,
  });

  final ProfileBillingCurrentEntity current;
  final List<ProfileBillingInvoiceEntity> invoices;
  final ProfileBillingPaymentMethodEntity paymentMethod;
  final ProfileBillingFreezePolicyEntity freezePolicy;
}

class ProfileBillingCurrentEntity {
  const ProfileBillingCurrentEntity({
    required this.emptyStateCode,
    this.subscription,
  });

  final ProfileBillingSubscriptionEntity? subscription;
  final String emptyStateCode;
}

class ProfileBillingSubscriptionEntity {
  const ProfileBillingSubscriptionEntity({
    required this.subscriptionId,
    required this.status,
    required this.statusNameAr,
    required this.programId,
    required this.programNameAr,
    required this.programNameEn,
    required this.bundleId,
    required this.bundleNameAr,
    required this.bundleNameEn,
    required this.tier,
    required this.tierNameAr,
    required this.tierNameEn,
    required this.tierLogoUrl,
    required this.mealsPerDay,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.nextRenewalDate,
    required this.totalServiceDays,
    required this.completedServiceDays,
    required this.remainingServiceDays,
    required this.progressPercentage,
    required this.paidAmount,
    required this.currencyCode,
    required this.restaurant,
    required this.actions,
    this.pendingFreeze,
    this.activeFreeze,
    this.pendingUpgrade,
  });

  final String subscriptionId;
  final String status;
  final String statusNameAr;
  final String programId;
  final String programNameAr;
  final String programNameEn;
  final String bundleId;
  final String bundleNameAr;
  final String bundleNameEn;
  final String tier;
  final String tierNameAr;
  final String tierNameEn;
  final String tierLogoUrl;
  final int mealsPerDay;
  final String imageUrl;
  final String startDate;
  final String endDate;
  final String nextRenewalDate;
  final int totalServiceDays;
  final int completedServiceDays;
  final int remainingServiceDays;
  final double progressPercentage;
  final double paidAmount;
  final String currencyCode;
  final ProfileBillingRestaurantEntity restaurant;
  final ProfileBillingActionsEntity actions;
  final ProfileBillingPendingFreezeEntity? pendingFreeze;
  final ProfileBillingActiveFreezeEntity? activeFreeze;
  final ProfileBillingPendingUpgradeEntity? pendingUpgrade;
}

class ProfileBillingRestaurantEntity {
  const ProfileBillingRestaurantEntity({
    required this.restaurantId,
    required this.nameAr,
    required this.nameEn,
    required this.logoUrl,
  });

  final String restaurantId;
  final String nameAr;
  final String nameEn;
  final String logoUrl;
}

class ProfileBillingActionsEntity {
  const ProfileBillingActionsEntity({
    required this.canRenew,
    required this.canFreeze,
    required this.canCancel,
    required this.canUpgrade,
    required this.renewUnavailableReason,
    required this.freezeUnavailableReason,
    required this.cancelUnavailableReason,
    required this.upgradeUnavailableReason,
    required this.freezeStartDelayDays,
    required this.maximumFreezeDays,
    required this.freezeExtendsSubscriptionEnd,
    required this.earliestFreezeStartDate,
    required this.renewalEndpoint,
    required this.freezeEndpoint,
    required this.cancellationEndpoint,
    required this.upgradeEndpoint,
    required this.cancellationQuoteEndpoint,
    this.freezeDetailsEndpoint = '',
  });

  final bool canRenew;
  final bool canFreeze;
  final bool canCancel;
  final bool canUpgrade;
  final String renewUnavailableReason;
  final String freezeUnavailableReason;
  final String cancelUnavailableReason;
  final String upgradeUnavailableReason;
  final int freezeStartDelayDays;
  final int maximumFreezeDays;
  final bool freezeExtendsSubscriptionEnd;
  final String earliestFreezeStartDate;
  final String renewalEndpoint;
  final String freezeEndpoint;
  final String cancellationEndpoint;
  final String upgradeEndpoint;
  final String cancellationQuoteEndpoint;
  final String freezeDetailsEndpoint;
}

class ProfileBillingPendingFreezeEntity {
  const ProfileBillingPendingFreezeEntity({
    required this.requestId,
    required this.startDate,
    required this.endDate,
    required this.freezeDays,
    required this.status,
  });

  final String requestId;
  final String startDate;
  final String endDate;
  final int freezeDays;
  final String status;
}

class ProfileBillingActiveFreezeEntity {
  const ProfileBillingActiveFreezeEntity({
    required this.requestId,
    required this.startDate,
    required this.endDate,
    required this.freezeDays,
    required this.frozenServiceDaysCount,
    required this.status,
    required this.statusNameAr,
    required this.isCurrentlyActive,
    required this.isUpcoming,
    required this.reason,
    required this.createdAtUtc,
    required this.processedAtUtc,
    required this.frozenServiceDates,
    required this.compensationDates,
    required this.subscriptionEndDate,
    required this.summaryAr,
    required this.summaryEn,
  });

  final String requestId;
  final String startDate;
  final String endDate;
  final int freezeDays;
  final int frozenServiceDaysCount;
  final String status;
  final String statusNameAr;
  final bool isCurrentlyActive;
  final bool isUpcoming;
  final String reason;
  final String createdAtUtc;
  final String processedAtUtc;
  final List<String> frozenServiceDates;
  final List<String> compensationDates;
  final String subscriptionEndDate;
  final String summaryAr;
  final String summaryEn;
}

class ProfileBillingFreezeHistoryEntity {
  const ProfileBillingFreezeHistoryEntity({
    required this.requestId,
    required this.startDate,
    required this.endDate,
    required this.freezeDays,
    required this.status,
    required this.statusNameAr,
    required this.reason,
    required this.createdAtUtc,
    required this.processedAtUtc,
  });

  final String requestId;
  final String startDate;
  final String endDate;
  final int freezeDays;
  final String status;
  final String statusNameAr;
  final String reason;
  final String createdAtUtc;
  final String processedAtUtc;
}

class ProfileBillingFreezeDetailsEntity {
  const ProfileBillingFreezeDetailsEntity({
    required this.subscriptionId,
    required this.subscriptionStatus,
    required this.subscriptionStatusNameAr,
    required this.hasFreeze,
    required this.isCurrentlyFrozen,
    required this.freezeHistory,
    required this.noticeAr,
    required this.noticeEn,
    this.currentFreeze,
  });

  final String subscriptionId;
  final String subscriptionStatus;
  final String subscriptionStatusNameAr;
  final bool hasFreeze;
  final bool isCurrentlyFrozen;
  final ProfileBillingActiveFreezeEntity? currentFreeze;
  final List<ProfileBillingFreezeHistoryEntity> freezeHistory;
  final String noticeAr;
  final String noticeEn;
}

class ProfileBillingPendingUpgradeEntity {
  const ProfileBillingPendingUpgradeEntity({
    required this.requestId,
    required this.fromTier,
    required this.toTier,
    required this.priceDifference,
    required this.status,
  });

  final String requestId;
  final String fromTier;
  final String toTier;
  final double priceDifference;
  final String status;
}

class ProfileBillingPaymentMethodEntity {
  const ProfileBillingPaymentMethodEntity({
    required this.hasSavedMethod,
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.gateway,
    required this.emptyStateCode,
  });

  final bool hasSavedMethod;
  final String brand;
  final String last4;
  final String expiry;
  final String gateway;
  final String emptyStateCode;
}

class ProfileBillingInvoiceEntity {
  const ProfileBillingInvoiceEntity({
    required this.receiptId,
    required this.subscriptionId,
    required this.invoiceNumber,
    required this.paymentId,
    required this.issuedAtUtc,
    required this.amount,
    required this.currencyCode,
    required this.status,
    required this.statusNameAr,
    required this.gateway,
    required this.maskedCardNumber,
    required this.canDownload,
    required this.downloadUnavailableReason,
  });

  final String receiptId;
  final String subscriptionId;
  final String invoiceNumber;
  final String paymentId;
  final String issuedAtUtc;
  final double amount;
  final String currencyCode;
  final String status;
  final String statusNameAr;
  final String gateway;
  final String maskedCardNumber;
  final bool canDownload;
  final String downloadUnavailableReason;

  String get displayNumber {
    if (invoiceNumber.isNotEmpty) {
      return invoiceNumber;
    }
    if (paymentId.isNotEmpty) {
      return paymentId;
    }
    return receiptId;
  }
}

class ProfileBillingFreezePolicyEntity {
  const ProfileBillingFreezePolicyEntity({
    required this.defaultDurationDays,
    required this.startDelayDays,
    required this.extendSubscriptionEnd,
    required this.earliestAllowedStartDate,
    required this.messageAr,
    required this.messageEn,
    this.message = '',
    this.noticeAr = '',
    this.notice = '',
  });

  final int defaultDurationDays;
  final int startDelayDays;
  final bool extendSubscriptionEnd;
  final String earliestAllowedStartDate;
  final String messageAr;
  final String messageEn;
  final String message;
  final String noticeAr;
  final String notice;
}

class ProfileBillingFreezeRequestEntity {
  const ProfileBillingFreezeRequestEntity({
    required this.startDate,
    required this.endDate,
    this.reason,
    this.acknowledgeLostSelections = false,
  });

  final String startDate;
  final String endDate;
  final String? reason;
  final bool acknowledgeLostSelections;
}

class ProfileBillingFreezeDatePolicy {
  const ProfileBillingFreezeDatePolicy._();

  static DateTime minimumStartDate({
    required DateTime now,
    required int freezeStartDelayDays,
    String earliestFreezeStartDate = '',
  }) {
    if (earliestFreezeStartDate.isNotEmpty) {
      final parsedDate = DateTime.tryParse(earliestFreezeStartDate);
      if (parsedDate != null) {
        return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      }
    }
    final today = DateTime(now.year, now.month, now.day);
    return today.add(Duration(days: freezeStartDelayDays + 1));
  }
}

class ProfileBillingCancellationRequestEntity {
  const ProfileBillingCancellationRequestEntity({
    this.reason,
    this.requestedEffectiveDate,
  });

  final String? reason;
  final String? requestedEffectiveDate;
}

class ProfileBillingCancellationQuoteEntity {
  const ProfileBillingCancellationQuoteEntity({
    required this.subscriptionId,
    required this.totalServiceDays,
    required this.deliveredDays,
    required this.lockedKitchenDays,
    required this.refundableDays,
    required this.dailyBoxPrice,
    required this.refundAmount,
    required this.currencyCode,
    required this.effectiveCancellationDate,
    required this.policyMessageAr,
  });

  final String subscriptionId;
  final int totalServiceDays;
  final int deliveredDays;
  final int lockedKitchenDays;
  final int refundableDays;
  final double dailyBoxPrice;
  final double refundAmount;
  final String currencyCode;
  final String effectiveCancellationDate;
  final String policyMessageAr;
}

class ProfileBillingCancellationResultEntity {
  const ProfileBillingCancellationResultEntity({
    required this.requestId,
    required this.subscriptionId,
    required this.status,
    required this.statusNameAr,
    required this.totalServiceDays,
    required this.deliveredDays,
    required this.lockedKitchenDays,
    required this.refundableDays,
    required this.dailyBoxPrice,
    required this.refundAmount,
    required this.currencyCode,
    required this.effectiveCancellationDate,
    required this.messageAr,
    required this.timestampUtc,
  });

  final String requestId;
  final String subscriptionId;
  final String status;
  final String statusNameAr;
  final int totalServiceDays;
  final int deliveredDays;
  final int lockedKitchenDays;
  final int refundableDays;
  final double dailyBoxPrice;
  final double refundAmount;
  final String currencyCode;
  final String effectiveCancellationDate;
  final String messageAr;
  final String timestampUtc;
}

class ProfileBillingFreezeResponseEntity {
  const ProfileBillingFreezeResponseEntity({
    required this.id,
    required this.subscriptionId,
    required this.freezeStartDate,
    required this.freezeEndDate,
    required this.freezeDays,
    required this.reason,
    required this.status,
    this.approvedByUserId,
    required this.processedAtUtc,
    required this.createdAtUtc,
  });

  final String id;
  final String subscriptionId;
  final String freezeStartDate;
  final String freezeEndDate;
  final int freezeDays;
  final String reason;
  final String status;
  final String? approvedByUserId;
  final String processedAtUtc;
  final String createdAtUtc;
}
