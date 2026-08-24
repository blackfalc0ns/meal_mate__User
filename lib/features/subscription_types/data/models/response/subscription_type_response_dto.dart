import 'package:json_annotation/json_annotation.dart';

part 'subscription_type_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionTypeResponseDto {
  const SubscriptionTypeResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.maxMembers,
    this.isAvailable,
    this.membersConfiguredAfterPayment,
    this.disabledReason,
    this.requiresConversion,
    this.conversionEndpoint,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final int? maxMembers;
  final bool? isAvailable;
  final bool? membersConfiguredAfterPayment;
  final String? disabledReason;
  final bool? requiresConversion;
  final String? conversionEndpoint;

  factory SubscriptionTypeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTypeResponseDtoFromJson(json);
}
