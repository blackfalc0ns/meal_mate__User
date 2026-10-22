import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

enum PaymentSessionOutcome { failed }

class PaymentWebViewArgs {
  const PaymentWebViewArgs({
    required this.checkout,
    this.flowType = 'individual',
    this.batchId,
    this.batchVersion,
  });

  final PaymentCheckoutEntity checkout;
  final String flowType;
  final String? batchId;
  final int? batchVersion;

  bool get isFamily => flowType == 'family';
}
