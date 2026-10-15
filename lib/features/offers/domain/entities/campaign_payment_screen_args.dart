import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class CampaignPaymentScreenArgs {
  const CampaignPaymentScreenArgs({
    required this.sessionId,
    this.paymentId,
    this.callbackStatus,
    this.amount,
    this.currency = 'KWD',
    this.offer,
  });

  final String sessionId;
  final String? paymentId;
  final String? callbackStatus;
  final double? amount;
  final String currency;
  final OfferEntity? offer;
}
