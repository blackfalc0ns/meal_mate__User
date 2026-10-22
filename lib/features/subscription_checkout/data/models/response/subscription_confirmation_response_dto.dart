import 'package:json_annotation/json_annotation.dart';

part 'subscription_confirmation_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionConfirmationResponseDto {
  const SubscriptionConfirmationResponseDto({
    this.subscriptionId,
    this.status,
    this.programNameAr,
    this.programNameEn,
    this.bundleNameAr,
    this.bundleNameEn,
    this.startDate,
    this.endDate,
    this.paidAmount,
    this.appliedDiscount,
    this.currency,
    this.referralShareCode,
    this.referralShareMessage,
    this.referralShareUrl,
    this.durationDays,
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.paymentDate,
  });

  final String? subscriptionId;
  final String? status;
  @JsonKey(readValue: _readProgramNameAr)
  final String? programNameAr;
  final String? programNameEn;
  @JsonKey(readValue: _readBundleNameAr)
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? startDate;
  final String? endDate;
  @JsonKey(readValue: _readPaidAmount)
  final double? paidAmount;
  @JsonKey(readValue: _readAppliedDiscount)
  final double? appliedDiscount;
  @JsonKey(readValue: _readCurrency)
  final String? currency;
  @JsonKey(readValue: _readReferralShareCode)
  final String? referralShareCode;
  @JsonKey(readValue: _readReferralShareMessage)
  final String? referralShareMessage;
  @JsonKey(readValue: _readReferralShareUrl)
  final String? referralShareUrl;
  final int? durationDays;
  final String? tier;
  @JsonKey(readValue: _readTierNameAr)
  final String? tierNameAr;
  final String? tierNameEn;
  @JsonKey(readValue: _readPaymentDate)
  final String? paymentDate;

  factory SubscriptionConfirmationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SubscriptionConfirmationResponseDtoFromJson(json);
}

Object? _readPaidAmount(Map<dynamic, dynamic> json, String key) {
  return json['paidAmount'] ?? json['amountPaidKwd'];
}

Object? _readAppliedDiscount(Map<dynamic, dynamic> json, String key) {
  return json['appliedDiscount'] ?? json['discount'];
}

Object? _readCurrency(Map<dynamic, dynamic> json, String key) {
  return json['currency'] ?? json['currencyCode'];
}

Object? _readProgramNameAr(Map<dynamic, dynamic> json, String key) {
  return json['programNameAr'] ?? json['programName'];
}

Object? _readBundleNameAr(Map<dynamic, dynamic> json, String key) {
  return json['bundleNameAr'] ?? json['bundleName'];
}

Object? _readTierNameAr(Map<dynamic, dynamic> json, String key) {
  return json['tierNameAr'] ?? json['tierName'] ?? json['tier'];
}

Object? _readReferralShareCode(Map<dynamic, dynamic> json, String key) {
  if (json[key] != null) return json[key];
  final ref = json['referralShare'];
  if (ref is Map) return ref['code'] ?? ref['referralCode'];
  return null;
}

Object? _readReferralShareMessage(Map<dynamic, dynamic> json, String key) {
  if (json[key] != null) return json[key];
  final ref = json['referralShare'];
  if (ref is Map) return ref['message'];
  return null;
}

Object? _readReferralShareUrl(Map<dynamic, dynamic> json, String key) {
  if (json[key] != null) return json[key];
  final ref = json['referralShare'];
  if (ref is Map) return ref['shareUrl'] ?? ref['url'];
  return null;
}

Object? _readPaymentDate(Map<dynamic, dynamic> json, String key) {
  if (json[key] != null) return json[key];
  final utc = json['paymentVerifiedAtUtc'] as String?;
  if (utc != null && utc.contains('T')) {
    return utc.split('T').first;
  }
  return json['paymentDate'];
}
