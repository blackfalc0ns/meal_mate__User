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
