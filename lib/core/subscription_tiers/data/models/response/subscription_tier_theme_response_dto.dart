import 'package:json_annotation/json_annotation.dart';

part 'subscription_tier_theme_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionTierThemeResponseDto {
  const SubscriptionTierThemeResponseDto({this.designId, this.designName});

  final int? designId;
  final String? designName;

  factory SubscriptionTierThemeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionTierThemeResponseDtoFromJson(json);
}
