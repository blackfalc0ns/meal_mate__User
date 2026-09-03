class SubscriptionUpgradeOptionsEntity {
  const SubscriptionUpgradeOptionsEntity({
    required this.canUpgrade,
    this.unavailableReason,
    required this.currentTier,
    required this.remainingServiceDays,
    required this.totalServiceDays,
    required this.upgradeEndpoint,
    required this.options,
    required this.paymentMethods,
  });

  final bool canUpgrade;
  final String? unavailableReason;
  final String currentTier;
  final int remainingServiceDays;
  final int totalServiceDays;
  final String upgradeEndpoint;
  final List<SubscriptionUpgradeOptionEntity> options;
  final List<SubscriptionUpgradePaymentMethodEntity> paymentMethods;
}

class SubscriptionUpgradePaymentMethodEntity {
  const SubscriptionUpgradePaymentMethodEntity({
    required this.id,
    required this.code,
    required this.title,
    required this.integrationType,
    required this.serviceCharge,
    required this.totalAmount,
    required this.currencyCode,
    required this.isAvailable,
    this.unavailableReason,
    this.imageUrl,
  });

  final int id;
  final String code;
  final String title;
  final String integrationType;
  final double serviceCharge;
  final double totalAmount;
  final String currencyCode;
  final bool isAvailable;
  final String? unavailableReason;
  final String? imageUrl;
}

class SubscriptionUpgradeOptionEntity {
  const SubscriptionUpgradeOptionEntity({
    required this.targetTier,
    required this.tierNameAr,
    required this.tierNameEn,
    this.logoUrl,
    required this.isCurrent,
    required this.selectable,
    required this.accessibleRestaurantCount,
    required this.currentRemainingCredit,
    required this.targetRemainingPrice,
    required this.gatewayRecovery,
    required this.priceDifference,
    required this.currencyCode,
  });

  final String targetTier;
  final String tierNameAr;
  final String tierNameEn;
  final String? logoUrl;
  final bool isCurrent;
  final bool selectable;
  final int accessibleRestaurantCount;
  final double currentRemainingCredit;
  final double targetRemainingPrice;
  final double gatewayRecovery;
  final double priceDifference;
  final String currencyCode;
}

class SubscriptionUpgradeRequestEntity {
  const SubscriptionUpgradeRequestEntity({
    required this.targetTier,
    this.callbackUrl,
    this.errorUrl,
    this.paymentMethodId,
    this.reason,
  });

  final String targetTier;
  final String? callbackUrl;
  final String? errorUrl;
  final int? paymentMethodId;
  final String? reason;
}

class SubscriptionUpgradeRequestResultEntity {
  const SubscriptionUpgradeRequestResultEntity({
    required this.upgradeId,
    required this.subscriptionId,
    required this.fromTier,
    required this.toTier,
    required this.amount,
    required this.currencyCode,
    this.paymentUrl,
    required this.isPaid,
    required this.status,
    required this.remainingServiceDays,
  });

  final String upgradeId;
  final String subscriptionId;
  final String fromTier;
  final String toTier;
  final double amount;
  final String currencyCode;
  final String? paymentUrl;
  final bool isPaid;
  final String status;
  final int remainingServiceDays;
}

class SubscriptionUpgradeStatusEntity {
  const SubscriptionUpgradeStatusEntity({
    required this.upgradeId,
    required this.subscriptionId,
    required this.fromTier,
    required this.toTier,
    required this.amount,
    required this.currencyCode,
    required this.status,
    required this.isPaid,
    required this.isFailed,
    this.effectiveAtUtc,
    this.paymentUrl,
  });

  final String upgradeId;
  final String subscriptionId;
  final String fromTier;
  final String toTier;
  final double amount;
  final String currencyCode;
  final String status;
  final bool isPaid;
  final bool isFailed;
  final String? effectiveAtUtc;
  final String? paymentUrl;
}
