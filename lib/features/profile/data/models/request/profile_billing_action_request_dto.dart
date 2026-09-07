import 'package:json_annotation/json_annotation.dart';

part 'profile_billing_action_request_dto.g.dart';

@JsonSerializable()
class ProfileBillingFreezeRequestDto {
  const ProfileBillingFreezeRequestDto({
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

  factory ProfileBillingFreezeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileBillingFreezeRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileBillingFreezeRequestDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingCancellationRequestDto {
  const ProfileBillingCancellationRequestDto({
    this.reason,
    this.requestedEffectiveDate,
  });

  final String? reason;
  final String? requestedEffectiveDate;

  factory ProfileBillingCancellationRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileBillingCancellationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileBillingCancellationRequestDtoToJson(this);
}

@JsonSerializable()
class ProfileBillingResumeRequestDto {
  const ProfileBillingResumeRequestDto({
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

  factory ProfileBillingResumeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileBillingResumeRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileBillingResumeRequestDtoToJson(this);
}
