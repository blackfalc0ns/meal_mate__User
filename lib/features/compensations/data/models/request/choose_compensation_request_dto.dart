import 'package:json_annotation/json_annotation.dart';

part 'choose_compensation_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: true)
class ChooseCompensationRequestDto {
  const ChooseCompensationRequestDto({required this.choice, this.targetDate});
  final String choice;
  final String? targetDate;
  Map<String, dynamic> toJson() => _$ChooseCompensationRequestDtoToJson(this);
}
