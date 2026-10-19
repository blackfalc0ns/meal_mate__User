import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OffersHubEntity {
  const OffersHubEntity({
    this.heroOffers = const [],
    this.availableOffers = const [],
    this.savedOffers = const [],
    this.serverTimeUtc,
  });

  final List<OfferEntity> heroOffers;
  final List<OfferEntity> availableOffers;
  final List<OfferEntity> savedOffers;
  final DateTime? serverTimeUtc;
}
