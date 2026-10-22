import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_checkout_error_banner.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_method_selector.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_order_summary_section.dart';

/// Scrollable content displaying the order summary, available payment methods, and error banner.
class PaymentContentSection extends StatelessWidget {
  const PaymentContentSection({
    super.key,
    required this.paymentArgs,
    required this.state,
  });

  final SubscriptionCheckoutArgs paymentArgs;
  final SubscriptionCheckoutState state;

  @override
  Widget build(BuildContext context) {
    final selectedMethodId = state.selectedMethod?.id;

    final hasVisibleCheckoutError =
        state.checkoutFailure != null &&
        state.checkoutFailure!.code !=
            SubscriptionErrorCodes.existingSubscription;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: Spacing.sm, bottom: Spacing.lg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              PaymentOrderSummarySection(paymentArgs: paymentArgs),
              const SizedBox(height: Spacing.base),
              PaymentMethodSelector(
                methods: state.methods,
                selectedMethodId: selectedMethodId,
                onMethodSelected: (method) => context
                    .read<SubscriptionCheckoutViewModel>()
                    .doIntent(SelectCheckoutPaymentMethodEvent(method)),
              ),
              if (hasVisibleCheckoutError)
                PaymentCheckoutErrorBanner(
                  paymentArgs: paymentArgs,
                  state: state,
                ),
              const SizedBox(height: Spacing.base),
            ]),
          ),
        ),
      ],
    );
  }
}
