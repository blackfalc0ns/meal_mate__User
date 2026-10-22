import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferCheckoutArgs {
  const OfferCheckoutArgs({
    required this.offer,
    required this.durationDays,
    required this.packageName,
    required this.mealsPerDay,
    required this.originalPriceKwd,
    required this.discountAmountKwd,
    required this.finalPriceKwd,
    this.programId,
    this.bundleId,
    this.tier,
    this.restaurantId,
    this.deliveryGovernorate,
  });

  final OfferEntity offer;
  final int durationDays;
  final String packageName;
  final int mealsPerDay;
  final double originalPriceKwd;
  final double discountAmountKwd;
  final double finalPriceKwd;
  final String? programId;
  final String? bundleId;
  final String? tier;
  final String? restaurantId;
  final String? deliveryGovernorate;
}
