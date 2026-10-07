import 'package:json_annotation/json_annotation.dart';

part 'subscription_billing_response_dto.g.dart';

@JsonSerializable()
class SubscriptionBillingUncompletedSubscriptionResponseDto {
  const SubscriptionBillingUncompletedSubscriptionResponseDto({
    this.subscriptionId,
    this.status,
    this.statusNameAr,
    this.programId,
    this.programNameAr,
    this.programNameEn,
    this.bundleId,
    this.bundleNameAr,
    this.bundleNameEn,
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.tierLogoUrl,
    this.mealsPerDay,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.durationDays,
    this.includeFriday,
    this.amount,
    this.currencyCode,
    this.deliveryAddress,
    this.createdAtUtc,
    this.isHoldActive,
    this.holdRemainingSeconds,
    this.holdExpiresAtUtc,
    this.actions,
  });

  final String? subscriptionId;
  final String? status;
  final String? statusNameAr;
  final String? programId;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleId;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? tier;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? tierLogoUrl;
  final int? mealsPerDay;
  final String? imageUrl;
  final String? startDate;
  final String? endDate;
  final int? durationDays;
  final bool? includeFriday;
  final double? amount;
  final String? currencyCode;
  final String? deliveryAddress;
  final DateTime? createdAtUtc;
  final bool? isHoldActive;
  final int? holdRemainingSeconds;
  final DateTime? holdExpiresAtUtc;
  final SubscriptionBillingUncompletedActionsResponseDto? actions;

  factory SubscriptionBillingUncompletedSubscriptionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingUncompletedSubscriptionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingUncompletedSubscriptionResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingUncompletedActionsResponseDto {
  const SubscriptionBillingUncompletedActionsResponseDto({
    this.canDelete,
    this.canResume,
    this.deleteEndpoint,
    this.resumeEndpoint,
  });

  final bool? canDelete;
  final bool? canResume;
  final String? deleteEndpoint;
  final String? resumeEndpoint;

  factory SubscriptionBillingUncompletedActionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingUncompletedActionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingUncompletedActionsResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingResumePreviewResponseDto {
  const SubscriptionBillingResumePreviewResponseDto({
    this.subscriptionId,
    this.status,
    this.statusNameAr,
    this.programId,
    this.programNameAr,
    this.bundleNameAr,
    this.tier,
    this.tierNameAr,
    this.durationDays,
    this.amount,
    this.currencyCode,
    this.canPayDirectly,
    this.reason,
    this.holdRemainingSeconds,
    this.holdExpiresAtUtc,
    this.suggestedStartDate,
    this.resumeEndpoint,
  });

  final String? subscriptionId;
  final String? status;
  final String? statusNameAr;
  final String? programId;
  final String? programNameAr;
  final String? bundleNameAr;
  final String? tier;
  final String? tierNameAr;
  final int? durationDays;
  final double? amount;
  final String? currencyCode;
  final bool? canPayDirectly;
  final String? reason;
  final int? holdRemainingSeconds;
  final DateTime? holdExpiresAtUtc;
  final String? suggestedStartDate;
  final String? resumeEndpoint;

  factory SubscriptionBillingResumePreviewResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingResumePreviewResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingResumePreviewResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingResumeResponseDto {
  const SubscriptionBillingResumeResponseDto({
    this.subscriptionId,
    this.paymentUrl,
    this.holdExpiresAtUtc,
    this.finalPrice,
    this.paymentStatus,
  });

  final String? subscriptionId;
  final String? paymentUrl;
  final DateTime? holdExpiresAtUtc;
  final double? finalPrice;
  final String? paymentStatus;

  factory SubscriptionBillingResumeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingResumeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingResumeResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingCurrentResponseDto {
  const SubscriptionBillingCurrentResponseDto({
    this.subscription,
    this.emptyStateCode,
  });

  final SubscriptionBillingSubscriptionResponseDto? subscription;
  final String? emptyStateCode;

  factory SubscriptionBillingCurrentResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingCurrentResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingCurrentResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingSubscriptionResponseDto {
  const SubscriptionBillingSubscriptionResponseDto({
    this.subscriptionId,
    this.status,
    this.statusNameAr,
    this.programId,
    this.programNameAr,
    this.programNameEn,
    this.bundleId,
    this.bundleNameAr,
    this.bundleNameEn,
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.tierLogoUrl,
    this.mealsPerDay,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.nextRenewalDate,
    this.totalServiceDays,
    this.completedServiceDays,
    this.remainingServiceDays,
    this.progressPercentage,
    this.paidAmount,
    this.currencyCode,
    this.restaurant,
    this.pendingFreeze,
    this.activeFreeze,
    this.pendingUpgrade,
    this.actions,
  });

  final String? subscriptionId;
  final String? status;
  final String? statusNameAr;
  final String? programId;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleId;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? tier;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? tierLogoUrl;
  final int? mealsPerDay;
  final String? imageUrl;
  final String? startDate;
  final String? endDate;
  final String? nextRenewalDate;
  final int? totalServiceDays;
  final int? completedServiceDays;
  final int? remainingServiceDays;
  final double? progressPercentage;
  final double? paidAmount;
  final String? currencyCode;
  final SubscriptionBillingRestaurantResponseDto? restaurant;
  final SubscriptionBillingPendingFreezeResponseDto? pendingFreeze;
  final SubscriptionBillingActiveFreezeResponseDto? activeFreeze;
  final SubscriptionBillingPendingUpgradeResponseDto? pendingUpgrade;
  final SubscriptionBillingActionsResponseDto? actions;

  factory SubscriptionBillingSubscriptionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingSubscriptionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingSubscriptionResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingRestaurantResponseDto {
  const SubscriptionBillingRestaurantResponseDto({
    this.restaurantId,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
  });

  final String? restaurantId;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;

  factory SubscriptionBillingRestaurantResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingRestaurantResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingRestaurantResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingActionsResponseDto {
  const SubscriptionBillingActionsResponseDto({
    this.canRenew,
    this.canFreeze,
    this.canCancel,
    this.canUpgrade,
    this.renewUnavailableReason,
    this.freezeUnavailableReason,
    this.cancelUnavailableReason,
    this.upgradeUnavailableReason,
    this.freezeStartDelayDays,
    this.maximumFreezeDays,
    this.freezeExtendsSubscriptionEnd,
    this.earliestFreezeStartDate,
    this.renewalEndpoint,
    this.freezeEndpoint,
    this.cancellationEndpoint,
    this.upgradeEndpoint,
    this.cancellationQuoteEndpoint,
    this.freezeDetailsEndpoint,
    this.freezeNotice,
    this.freezeNoticeAr,
  });

  final bool? canRenew;
  final bool? canFreeze;
  final bool? canCancel;
  final bool? canUpgrade;
  final String? renewUnavailableReason;
  final String? freezeUnavailableReason;
  final String? cancelUnavailableReason;
  final String? upgradeUnavailableReason;
  final int? freezeStartDelayDays;
  final int? maximumFreezeDays;
  final bool? freezeExtendsSubscriptionEnd;
  final String? earliestFreezeStartDate;
  final String? renewalEndpoint;
  final String? freezeEndpoint;
  final String? cancellationEndpoint;
  final String? upgradeEndpoint;
  final String? cancellationQuoteEndpoint;
  final String? freezeDetailsEndpoint;
  final String? freezeNotice;
  final String? freezeNoticeAr;

  factory SubscriptionBillingActionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingActionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingActionsResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingActiveFreezeResponseDto {
  const SubscriptionBillingActiveFreezeResponseDto({
    this.requestId,
    this.startDate,
    this.endDate,
    this.freezeDays,
    this.frozenServiceDaysCount,
    this.status,
    this.statusNameAr,
    this.isCurrentlyActive,
    this.isUpcoming,
    this.reason,
    this.createdAtUtc,
    this.processedAtUtc,
    this.frozenServiceDates,
    this.compensationDates,
    this.subscriptionEndDate,
    this.summaryAr,
    this.summaryEn,
  });

  final String? requestId;
  final String? startDate;
  final String? endDate;
  final int? freezeDays;
  final int? frozenServiceDaysCount;
  final String? status;
  final String? statusNameAr;
  final bool? isCurrentlyActive;
  final bool? isUpcoming;
  final String? reason;
  final String? createdAtUtc;
  final String? processedAtUtc;
  final List<String>? frozenServiceDates;
  final List<String>? compensationDates;
  final String? subscriptionEndDate;
  final String? summaryAr;
  final String? summaryEn;

  factory SubscriptionBillingActiveFreezeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingActiveFreezeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingActiveFreezeResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingFreezeHistoryResponseDto {
  const SubscriptionBillingFreezeHistoryResponseDto({
    this.requestId,
    this.startDate,
    this.endDate,
    this.freezeDays,
    this.status,
    this.statusNameAr,
    this.reason,
    this.createdAtUtc,
    this.processedAtUtc,
  });

  final String? requestId;
  final String? startDate;
  final String? endDate;
  final int? freezeDays;
  final String? status;
  final String? statusNameAr;
  final String? reason;
  final String? createdAtUtc;
  final String? processedAtUtc;

  factory SubscriptionBillingFreezeHistoryResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingFreezeHistoryResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingFreezeHistoryResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingFreezeDetailsResponseDto {
  const SubscriptionBillingFreezeDetailsResponseDto({
    this.subscriptionId,
    this.subscriptionStatus,
    this.subscriptionStatusNameAr,
    this.hasFreeze,
    this.isCurrentlyFrozen,
    this.currentFreeze,
    this.freezeHistory,
    this.noticeAr,
    this.noticeEn,
  });

  final String? subscriptionId;
  final String? subscriptionStatus;
  final String? subscriptionStatusNameAr;
  final bool? hasFreeze;
  final bool? isCurrentlyFrozen;
  final SubscriptionBillingActiveFreezeResponseDto? currentFreeze;
  final List<SubscriptionBillingFreezeHistoryResponseDto>? freezeHistory;
  final String? noticeAr;
  final String? noticeEn;

  factory SubscriptionBillingFreezeDetailsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingFreezeDetailsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingFreezeDetailsResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingPendingFreezeResponseDto {
  const SubscriptionBillingPendingFreezeResponseDto({
    this.requestId,
    this.startDate,
    this.endDate,
    this.freezeDays,
    this.status,
  });

  final String? requestId;
  final String? startDate;
  final String? endDate;
  final int? freezeDays;
  final String? status;

  factory SubscriptionBillingPendingFreezeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingPendingFreezeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingPendingFreezeResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingPendingUpgradeResponseDto {
  const SubscriptionBillingPendingUpgradeResponseDto({
    this.requestId,
    this.fromTier,
    this.toTier,
    this.priceDifference,
    this.status,
  });

  final String? requestId;
  final String? fromTier;
  final String? toTier;
  final double? priceDifference;
  final String? status;

  factory SubscriptionBillingPendingUpgradeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingPendingUpgradeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingPendingUpgradeResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingPaymentMethodResponseDto {
  const SubscriptionBillingPaymentMethodResponseDto({
    this.hasSavedMethod,
    this.brand,
    this.last4,
    this.expiry,
    this.gateway,
    this.emptyStateCode,
  });

  final bool? hasSavedMethod;
  final String? brand;
  final String? last4;
  final String? expiry;
  final String? gateway;
  final String? emptyStateCode;

  factory SubscriptionBillingPaymentMethodResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingPaymentMethodResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingPaymentMethodResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingInvoiceResponseDto {
  const SubscriptionBillingInvoiceResponseDto({
    this.receiptId,
    this.subscriptionId,
    this.invoiceNumber,
    this.paymentId,
    this.issuedAtUtc,
    this.amount,
    this.currencyCode,
    this.status,
    this.statusNameAr,
    this.gateway,
    this.maskedCardNumber,
    this.canDownload,
    this.downloadUnavailableReason,
  });

  final String? receiptId;
  final String? subscriptionId;
  final String? invoiceNumber;
  final String? paymentId;
  final String? issuedAtUtc;
  final double? amount;
  final String? currencyCode;
  final String? status;
  final String? statusNameAr;
  final String? gateway;
  final String? maskedCardNumber;
  final bool? canDownload;
  final String? downloadUnavailableReason;

  factory SubscriptionBillingInvoiceResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingInvoiceResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingInvoiceResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingFreezePolicyResponseDto {
  const SubscriptionBillingFreezePolicyResponseDto({
    this.defaultDurationDays,
    this.startDelayDays,
    this.extendSubscriptionEnd,
    this.earliestAllowedStartDate,
    this.messageAr,
    this.messageEn,
    this.message,
    this.noticeAr,
    this.notice,
  });

  final int? defaultDurationDays;
  final int? startDelayDays;
  final bool? extendSubscriptionEnd;
  final String? earliestAllowedStartDate;
  final String? messageAr;
  final String? messageEn;
  final String? message;
  final String? noticeAr;
  final String? notice;

  factory SubscriptionBillingFreezePolicyResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingFreezePolicyResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingFreezePolicyResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingCancellationQuoteResponseDto {
  const SubscriptionBillingCancellationQuoteResponseDto({
    this.subscriptionId,
    this.totalServiceDays,
    this.deliveredDays,
    this.lockedKitchenDays,
    this.refundableDays,
    this.dailyBoxPrice,
    this.refundAmount,
    this.currencyCode,
    this.effectiveCancellationDate,
    this.policyMessageAr,
  });

  final String? subscriptionId;
  final int? totalServiceDays;
  final int? deliveredDays;
  final int? lockedKitchenDays;
  final int? refundableDays;
  final double? dailyBoxPrice;
  final double? refundAmount;
  final String? currencyCode;
  final String? effectiveCancellationDate;
  final String? policyMessageAr;

  factory SubscriptionBillingCancellationQuoteResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingCancellationQuoteResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingCancellationQuoteResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingCancellationResultResponseDto {
  const SubscriptionBillingCancellationResultResponseDto({
    this.requestId,
    this.subscriptionId,
    this.status,
    this.statusNameAr,
    this.totalServiceDays,
    this.deliveredDays,
    this.lockedKitchenDays,
    this.refundableDays,
    this.dailyBoxPrice,
    this.refundAmount,
    this.currencyCode,
    this.effectiveCancellationDate,
    this.messageAr,
    this.timestampUtc,
  });

  final String? requestId;
  final String? subscriptionId;
  final String? status;
  final String? statusNameAr;
  final int? totalServiceDays;
  final int? deliveredDays;
  final int? lockedKitchenDays;
  final int? refundableDays;
  final double? dailyBoxPrice;
  final double? refundAmount;
  final String? currencyCode;
  final String? effectiveCancellationDate;
  final String? messageAr;
  final String? timestampUtc;

  factory SubscriptionBillingCancellationResultResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingCancellationResultResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingCancellationResultResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingFreezeResponseDto {
  const SubscriptionBillingFreezeResponseDto({
    this.id,
    this.subscriptionId,
    this.freezeStartDate,
    this.freezeEndDate,
    this.freezeDays,
    this.reason,
    this.status,
    this.approvedByUserId,
    this.processedAtUtc,
    this.createdAtUtc,
  });

  final String? id;
  final String? subscriptionId;
  final String? freezeStartDate;
  final String? freezeEndDate;
  final int? freezeDays;
  final String? reason;
  final String? status;
  final String? approvedByUserId;
  final String? processedAtUtc;
  final String? createdAtUtc;

  factory SubscriptionBillingFreezeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingFreezeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingFreezeResponseDtoToJson(this);
}
