import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferCalendarEntryEntity {
  const OfferCalendarEntryEntity({
    this.id,
    required this.offerId,
    required this.scheduledDate,
    this.status = 1,
    this.offer,
    this.createdAtUtc,
  });

  final String? id;
  final String offerId;
  final String scheduledDate;
  final int status; // 1 = Active, 2 = Completed
  final OfferEntity? offer;
  final DateTime? createdAtUtc;

  bool get isCompleted => status == 2;
  bool get isActive => status == 1;
}
