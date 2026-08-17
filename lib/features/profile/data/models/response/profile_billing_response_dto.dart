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
    this.programNameAr,
    this.programNameEn,
    this.bundleNameAr,
    this.bundleNameEn,
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.tierLogoUrl,
    this.imageUrl,
    this.nextRenewalDate,
    this.totalServiceDays,
    this.completedServiceDays,
    this.remainingServiceDays,
    this.progressPercentage,
    this.paidAmount,
    this.currencyCode,
    this.restaurant,
    this.actions,
  });

  final String? subscriptionId;
  final String? status;
  final String? statusNameAr;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? tier;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? tierLogoUrl;
  final String? imageUrl;
  final String? nextRenewalDate;
  final int? totalServiceDays;
  final int? completedServiceDays;
  final int? remainingServiceDays;
  final double? progressPercentage;
  final double? paidAmount;
  final String? currencyCode;
  final ProfileBillingRestaurantResponseDto? restaurant;
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

  factory ProfileBillingActionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingActionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingActionsResponseDtoToJson(this);
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
    this.messageAr,
    this.messageEn,
  });

  final int? defaultDurationDays;
  final int? startDelayDays;
  final bool? extendSubscriptionEnd;
  final String? messageAr;
  final String? messageEn;

  factory ProfileBillingFreezePolicyResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingFreezePolicyResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingFreezePolicyResponseDtoToJson(this);
}
