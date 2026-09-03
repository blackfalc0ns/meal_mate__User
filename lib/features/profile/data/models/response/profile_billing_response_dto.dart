import 'package:json_annotation/json_annotation.dart';

part 'profile_billing_response_dto.g.dart';

@JsonSerializable()
class ProfileBillingCurrentResponseDto {
  const ProfileBillingCurrentResponseDto({
    this.subscription,
    this.emptyStateCode,
  });

  final ProfileBillingSubscriptionResponseDto? subscription;
  final String? emptyStateCode;

  factory ProfileBillingCurrentResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingCurrentResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingCurrentResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingSubscriptionResponseDto {
  const ProfileBillingSubscriptionResponseDto({
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
  final ProfileBillingRestaurantResponseDto? restaurant;
  final ProfileBillingPendingFreezeResponseDto? pendingFreeze;
  final ProfileBillingPendingUpgradeResponseDto? pendingUpgrade;
  final ProfileBillingActionsResponseDto? actions;

  factory ProfileBillingSubscriptionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingSubscriptionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingSubscriptionResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingRestaurantResponseDto {
  const ProfileBillingRestaurantResponseDto({
    this.restaurantId,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
  });

  final String? restaurantId;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;

  factory ProfileBillingRestaurantResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingRestaurantResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingRestaurantResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingActionsResponseDto {
  const ProfileBillingActionsResponseDto({
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

  factory ProfileBillingActionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingActionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingActionsResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingPendingFreezeResponseDto {
  const ProfileBillingPendingFreezeResponseDto({
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

  factory ProfileBillingPendingFreezeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingPendingFreezeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingPendingFreezeResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingPendingUpgradeResponseDto {
  const ProfileBillingPendingUpgradeResponseDto({
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

  factory ProfileBillingPendingUpgradeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingPendingUpgradeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingPendingUpgradeResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingPaymentMethodResponseDto {
  const ProfileBillingPaymentMethodResponseDto({
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

  factory ProfileBillingPaymentMethodResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingPaymentMethodResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingPaymentMethodResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingInvoiceResponseDto {
  const ProfileBillingInvoiceResponseDto({
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

  factory ProfileBillingInvoiceResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingInvoiceResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingInvoiceResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingFreezePolicyResponseDto {
  const ProfileBillingFreezePolicyResponseDto({
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

  factory ProfileBillingFreezePolicyResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingFreezePolicyResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingFreezePolicyResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingCancellationQuoteResponseDto {
  const ProfileBillingCancellationQuoteResponseDto({
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

  factory ProfileBillingCancellationQuoteResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingCancellationQuoteResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingCancellationQuoteResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingCancellationResultResponseDto {
  const ProfileBillingCancellationResultResponseDto({
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

  factory ProfileBillingCancellationResultResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingCancellationResultResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingCancellationResultResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingFreezeResponseDto {
  const ProfileBillingFreezeResponseDto({
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

  factory ProfileBillingFreezeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileBillingFreezeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingFreezeResponseDtoToJson(this);
}
