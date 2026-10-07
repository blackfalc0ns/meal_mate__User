import 'package:json_annotation/json_annotation.dart';

part 'subscription_billing_action_request_dto.g.dart';

@JsonSerializable()
class SubscriptionBillingFreezeRequestDto {
  const SubscriptionBillingFreezeRequestDto({
    required this.startDate,
    required this.endDate,
    this.reason,
    this.acknowledgeLostSelections,
  });

  final String startDate;
  final String endDate;
  final String? reason;
  @JsonKey(includeIfNull: false)
  final bool? acknowledgeLostSelections;

  factory SubscriptionBillingFreezeRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingFreezeRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingFreezeRequestDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingCancellationRequestDto {
  const SubscriptionBillingCancellationRequestDto({
    this.reason,
    this.requestedEffectiveDate,
  });

  final String? reason;
  final String? requestedEffectiveDate;

  factory SubscriptionBillingCancellationRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingCancellationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingCancellationRequestDtoToJson(this);
}

@JsonSerializable()
class SubscriptionBillingResumeRequestDto {
  const SubscriptionBillingResumeRequestDto({
    this.startDate,
    this.callbackUrl = 'mealmate://checkout/callback',
    this.errorUrl = 'mealmate://checkout/error',
    this.paymentMethodId,
  });

  @JsonKey(includeIfNull: false)
  final String? startDate;
  final String callbackUrl;
  final String errorUrl;
  @JsonKey(includeIfNull: false)
  final int? paymentMethodId;

  factory SubscriptionBillingResumeRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBillingResumeRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionBillingResumeRequestDtoToJson(this);
}
