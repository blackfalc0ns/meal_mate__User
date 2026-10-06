import 'package:json_annotation/json_annotation.dart';

part 'subscription_upgrade_request_response_dto.g.dart';

@JsonSerializable()
class SubscriptionUpgradeRequestResponseDto {
  const SubscriptionUpgradeRequestResponseDto({
    this.upgradeId,
    this.subscriptionId,
    this.fromTier,
    this.toTier,
    this.amount,
    this.currencyCode,
    this.paymentUrl,
    this.isPaid,
    this.status,
    this.remainingServiceDays,
  });

  final String? upgradeId;
  final String? subscriptionId;
  final String? fromTier;
  final String? toTier;
  final double? amount;
  final String? currencyCode;
  final String? paymentUrl;
  final bool? isPaid;
  final String? status;
  final int? remainingServiceDays;

  factory SubscriptionUpgradeRequestResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradeRequestResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradeRequestResponseDtoToJson(this);
}
