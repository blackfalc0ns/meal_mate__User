import 'package:json_annotation/json_annotation.dart';

part 'subscription_upgrade_status_response_dto.g.dart';

@JsonSerializable()
class SubscriptionUpgradeStatusResponseDto {
  const SubscriptionUpgradeStatusResponseDto({
    this.upgradeId,
    this.subscriptionId,
    this.fromTier,
    this.toTier,
    this.amount,
    this.currencyCode,
    this.status,
    this.isPaid,
    this.isFailed,
    this.effectiveAtUtc,
    this.paymentUrl,
  });

  final String? upgradeId;
  final String? subscriptionId;
  final String? fromTier;
  final String? toTier;
  final double? amount;
  final String? currencyCode;
  final String? status;
  final bool? isPaid;
  final bool? isFailed;
  final String? effectiveAtUtc;
  final String? paymentUrl;

  factory SubscriptionUpgradeStatusResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradeStatusResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradeStatusResponseDtoToJson(this);
}
