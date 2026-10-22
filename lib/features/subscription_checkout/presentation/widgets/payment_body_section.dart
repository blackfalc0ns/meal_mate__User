import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_content_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_loading_skeleton.dart';

/// Orchestrates body states (loading skeleton, api error, empty methods, content view).
class PaymentBodySection extends StatelessWidget {
  const PaymentBodySection({
    super.key,
    required this.paymentArgs,
    required this.state,
  });

  final SubscriptionCheckoutArgs paymentArgs;
  final SubscriptionCheckoutState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    if (state.isLoading && !state.hasContent) {
      return const PaymentLoadingSkeleton();
    }

    if (state.methodsFailure != null && !state.hasContent) {
      return ApiErrorWidget(
        exception: state.methodsFailure!.exception,
        onRetry: () => context.read<SubscriptionCheckoutViewModel>().doIntent(
          LoadSubscriptionCheckoutEvent(paymentArgs),
        ),
      );
    }

    if (state.methods.isEmpty) {
      return EmptyStateWidget(
        title: l10n.payment_method_section_title,
        description: l10n.payment_secure_label,
        icon: Icons.payment_rounded,
      );
    }

    return PaymentContentSection(paymentArgs: paymentArgs, state: state);
  }
}
