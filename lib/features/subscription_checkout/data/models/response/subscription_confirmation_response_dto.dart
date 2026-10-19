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
  });

  final String? subscriptionId;
  final String? status;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? startDate;
  final String? endDate;
  final double? paidAmount;
  final double? appliedDiscount;
  final String? currency;
  final String? referralShareCode;
  final String? referralShareMessage;
  final String? referralShareUrl;

  factory SubscriptionConfirmationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SubscriptionConfirmationResponseDtoFromJson(json);
}
