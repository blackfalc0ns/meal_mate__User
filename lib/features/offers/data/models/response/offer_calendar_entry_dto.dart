import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';

part 'offer_calendar_entry_dto.g.dart';

@JsonSerializable(createToJson: false)
class OfferCalendarEntryDto {
  const OfferCalendarEntryDto({
    this.id,
    this.offerId,
    this.scheduledDate,
    this.status,
    this.offer,
    this.createdAtUtc,
  });

  final String? id;
  final String? offerId;
  final String? scheduledDate;
  final int? status;
  final OfferResponseDto? offer;
  final String? createdAtUtc;

  factory OfferCalendarEntryDto.fromJson(Map<String, dynamic> json) =>
      _$OfferCalendarEntryDtoFromJson(json);
}
