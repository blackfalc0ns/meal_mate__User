import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_checkout_error_banner.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_method_selector.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_order_summary_section.dart';

/// Scrollable content displaying the order summary, available payment methods, and error banner.
class PaymentContentSection extends StatelessWidget {
  const PaymentContentSection({
    super.key,
    required this.paymentArgs,
    required this.state,
  });

  final PaymentArgs paymentArgs;
  final PaymentState state;

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
                    .read<PaymentViewModel>()
                    .doIntent(SelectPaymentMethodEvent(method)),
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
