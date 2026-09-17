import 'package:meal_meat_user/features/payment/domain/entities/offer_checkout_args.dart';

class ActivationSuccessArgs {
  const ActivationSuccessArgs({
    required this.subscriptionId,
    required this.checkoutArgs,
  });

  final String subscriptionId;
  final OfferCheckoutArgs checkoutArgs;
}
