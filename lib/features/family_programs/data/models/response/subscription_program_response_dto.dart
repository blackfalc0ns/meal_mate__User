import 'package:json_annotation/json_annotation.dart';

part 'subscription_program_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyProgramResponseDto {
  const FamilyProgramResponseDto({
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

  factory FamilyProgramResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyProgramResponseDtoFromJson(json);
}
