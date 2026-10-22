import 'package:json_annotation/json_annotation.dart';

part 'alternative_date_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class AlternativeDateResponseDto {
  const AlternativeDateResponseDto({this.date, this.isAvailable});
  final String? date;
  final bool? isAvailable;
  factory AlternativeDateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AlternativeDateResponseDtoFromJson(json);
}
