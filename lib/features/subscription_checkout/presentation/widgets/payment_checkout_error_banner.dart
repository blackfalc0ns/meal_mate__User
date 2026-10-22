import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_view_model.dart';

/// In-line error banner for checkout errors displayed on the payment screen.
class PaymentCheckoutErrorBanner extends StatelessWidget {
  const PaymentCheckoutErrorBanner({
    super.key,
    required this.paymentArgs,
    required this.state,
  });

  final SubscriptionCheckoutArgs paymentArgs;
  final SubscriptionCheckoutState state;

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
            : () => context.read<SubscriptionCheckoutViewModel>().doIntent(
                SubmitSubscriptionCheckoutEvent(paymentArgs),
              ),
      ),
    );
  }
}
