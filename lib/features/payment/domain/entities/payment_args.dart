import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';

enum PaymentSessionOutcome { failed }

class PaymentWebViewArgs {
  const PaymentWebViewArgs({
    required this.checkout,
    this.flowType = 'individual',
    this.batchId,
    this.batchVersion,
    this.familyMembers = const [],
  });

  final PaymentCheckoutEntity checkout;
  final String flowType;
  final String? batchId;
  final int? batchVersion;
  final List<PaymentSuccessMemberArgs> familyMembers;

  bool get isFamily => flowType == 'family';
}
