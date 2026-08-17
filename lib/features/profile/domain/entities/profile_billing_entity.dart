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
    required this.programNameAr,
    required this.programNameEn,
    required this.bundleNameAr,
    required this.bundleNameEn,
    required this.tier,
    required this.tierNameAr,
    required this.tierNameEn,
    required this.tierLogoUrl,
    required this.imageUrl,
    required this.nextRenewalDate,
    required this.totalServiceDays,
    required this.completedServiceDays,
    required this.remainingServiceDays,
    required this.progressPercentage,
    required this.paidAmount,
    required this.currencyCode,
    required this.restaurant,
    required this.actions,
  });

  final String subscriptionId;
  final String status;
  final String statusNameAr;
  final String programNameAr;
  final String programNameEn;
  final String bundleNameAr;
  final String bundleNameEn;
  final String tier;
  final String tierNameAr;
  final String tierNameEn;
  final String tierLogoUrl;
  final String imageUrl;
  final String nextRenewalDate;
  final int totalServiceDays;
  final int completedServiceDays;
  final int remainingServiceDays;
  final double progressPercentage;
  final double paidAmount;
  final String currencyCode;
  final ProfileBillingRestaurantEntity restaurant;
  final ProfileBillingActionsEntity actions;
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
    required this.messageAr,
    required this.messageEn,
  });

  final int defaultDurationDays;
  final int startDelayDays;
  final bool extendSubscriptionEnd;
  final String messageAr;
  final String messageEn;
}
