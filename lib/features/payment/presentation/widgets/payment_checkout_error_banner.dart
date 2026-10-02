import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';

/// In-line error banner for checkout errors displayed on the payment screen.
class PaymentCheckoutErrorBanner extends StatelessWidget {
  const PaymentCheckoutErrorBanner({
    super.key,
    required this.paymentArgs,
    required this.state,
  });

  final PaymentArgs paymentArgs;
  final PaymentState state;

  @override
  Widget build(BuildContext context) {
    final failure = state.checkoutFailure;
    if (failure == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.md,
      ),
      child: ApiErrorWidget(
        exception: failure.exception,
        onRetry: state.isCheckoutLoading
            ? null
            : () => context.read<PaymentViewModel>().doIntent(
                CheckoutPaymentEvent(paymentArgs),
              ),
      ),
    );
  }
}
