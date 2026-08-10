import 'package:json_annotation/json_annotation.dart';

part 'calling_code_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CallingCodeResponseDto {
  const CallingCodeResponseDto({
    this.countryCode,
    this.nameAr,
    this.nameEn,
    this.dialCode,
    this.flagEmoji,
  });

  final String? countryCode;
  final String? nameAr;
  final String? nameEn;
  final String? dialCode;
  final String? flagEmoji;

  factory CallingCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CallingCodeResponseDtoFromJson(json);
}
