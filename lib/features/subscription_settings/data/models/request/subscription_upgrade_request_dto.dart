import 'package:json_annotation/json_annotation.dart';

part 'subscription_upgrade_request_dto.g.dart';

@JsonSerializable()
class SubscriptionUpgradeRequestDto {
  const SubscriptionUpgradeRequestDto({
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

  factory SubscriptionUpgradeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionUpgradeRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionUpgradeRequestDtoToJson(this);
}
