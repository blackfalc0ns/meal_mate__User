import 'package:json_annotation/json_annotation.dart';

part 'compensation_choice_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CompensationChoiceResponseDto {
  const CompensationChoiceResponseDto({
    this.compensationId,
    this.status,
    this.selectedAlternativeDate,
  });
  final String? compensationId, status, selectedAlternativeDate;
  factory CompensationChoiceResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CompensationChoiceResponseDtoFromJson(json);
}
