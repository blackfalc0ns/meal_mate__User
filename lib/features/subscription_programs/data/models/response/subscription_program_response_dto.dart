import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';

part 'subscription_program_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionProgramResponseDto {
  const SubscriptionProgramResponseDto({
    this.programId,
    this.code,
    this.shortCode,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.keywordsAr,
    this.keywordsEn,
    this.imageUrl,
    this.bundleCount,
    this.supportedSlots,
    this.isAvailable,
    this.disabledReason,
    this.availability,
    this.option,
  });

  final String? programId;
  final String? code;
  final String? shortCode;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final List<String>? keywordsAr;
  final List<String>? keywordsEn;
  final String? imageUrl;
  final int? bundleCount;
  final List<String>? supportedSlots;
  final bool? isAvailable;
  final String? disabledReason;
  final SubscriptionAvailabilityResponseDto? availability;
  final SubscriptionProgramResponseDto? option;

  factory SubscriptionProgramResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionProgramResponseDtoFromJson(json);
}
