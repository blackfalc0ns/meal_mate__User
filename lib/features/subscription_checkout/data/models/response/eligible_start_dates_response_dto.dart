import 'package:json_annotation/json_annotation.dart';
part 'eligible_start_dates_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class EligibleStartDatesResponseDto {
  const EligibleStartDatesResponseDto({
    this.eligibleFirstDeliveryDates,
    this.earliestEligibleDeliveryDate,
    this.operationalLeadHours,
    this.includeFriday,
    this.serverTimeUtc,
  });
  final List<String>? eligibleFirstDeliveryDates;
  final String? earliestEligibleDeliveryDate, serverTimeUtc;
  final int? operationalLeadHours;
  final bool? includeFriday;
  factory EligibleStartDatesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EligibleStartDatesResponseDtoFromJson(json);
}
