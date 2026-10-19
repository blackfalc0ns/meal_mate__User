import 'package:json_annotation/json_annotation.dart';

part 'validate_discount_request_dto.g.dart';

@JsonSerializable()
class ValidateDiscountRequestDto {
  const ValidateDiscountRequestDto({
    required this.code,
    this.programId,
    this.bundleId,
  });

  final String code;
  final dynamic programId;
  final dynamic bundleId;

  Map<String, dynamic> toJson() => _$ValidateDiscountRequestDtoToJson(this);

  factory ValidateDiscountRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ValidateDiscountRequestDtoFromJson(json);
}
