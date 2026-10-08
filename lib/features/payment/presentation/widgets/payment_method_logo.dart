import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/logos/apple_pay_logo.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/logos/mada_payment_logo.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/logos/payzah_payment_logo.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/logos/visa_payment_logo.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/logos/wallet_payment_logo.dart';

class PaymentMethodLogo extends StatelessWidget {
  const PaymentMethodLogo({super.key, required this.type});

  final PaymentMethodType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PaymentMethodType.payzah:
        return const PayzahPaymentLogo();
      case PaymentMethodType.mada:
        return const MadaPaymentLogo();
      case PaymentMethodType.visa:
        return const VisaPaymentLogo();
      case PaymentMethodType.applePay:
        return const ApplePayLogo();
      case PaymentMethodType.wallet:
        return const WalletPaymentLogo();
      case PaymentMethodType.unknown:
        return const PayzahPaymentLogo();
    }
  }
}
