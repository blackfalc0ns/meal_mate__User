import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_body_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_footer.dart';

class SubscriptionCheckoutScreen extends StatelessWidget {
  const SubscriptionCheckoutScreen({super.key, this.args});

  final SubscriptionCheckoutArgs? args;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final paymentArgs = args;

    if (paymentArgs == null) {
      return Scaffold(
        appBar: CustomAppBar(title: l10n.payment_title),
        body: EmptyStateWidget(
          title: l10n.payment_title,
          description: l10n.subscription_program_subtitle,
          icon: Icons.payment_rounded,
        ),
      );
    }

    return BlocProvider<SubscriptionCheckoutViewModel>(
      create: (_) =>
          getIt<SubscriptionCheckoutViewModel>()
            ..doIntent(LoadSubscriptionCheckoutEvent(paymentArgs)),
      child:
          BlocConsumer<
            SubscriptionCheckoutViewModel,
            SubscriptionCheckoutState
          >(
            listenWhen: (previous, current) =>
                previous.checkout != current.checkout ||
                previous.checkoutFailure != current.checkoutFailure ||
                previous.pendingSubscriptionId != current.pendingSubscriptionId,
            listener: (context, state) =>
                _handleStateTransitions(context, paymentArgs, state),
            builder: (context, state) {
              return Scaffold(
                appBar: CustomAppBar(title: l10n.payment_title),
                body: PaymentBodySection(
                  paymentArgs: paymentArgs,
                  state: state,
                ),
                bottomNavigationBar: PaymentFooter(
                  totalAmount: paymentArgs.summary.finalPrice,
                  isLoading: state.isCheckoutLoading,
                  onPayNow: _canPayNow(state)
                      ? () => _handlePayNow(context, paymentArgs, state)
                      : null,
                ),
              );
            },
          ),
    );
  }

  void _handleStateTransitions(
    BuildContext context,
    SubscriptionCheckoutArgs paymentArgs,
    SubscriptionCheckoutState state,
  ) {
    final checkout =
        state.checkout ??
        (state.pendingSubscriptionId == null
            ? null
            : PaymentCheckoutEntity.recovery(
                subscriptionId: state.pendingSubscriptionId!,
                paymentId: '',
              ));
    if (checkout != null) {
      unawaited(
        Navigator.of(context)
            .pushNamed(
              AppRoutes.paymentWebView,
              arguments: PaymentWebViewArgs(checkout: checkout),
            )
            .then((result) {
              if (context.mounted &&
                  (ModalRoute.of(context)?.isCurrent ?? false)) {
                if (result == PaymentSessionOutcome.failed) {
                  if (checkout.paymentUrl.isEmpty) {
                    Navigator.of(
                      context,
                    ).pop(context.localization.payment_failed_card_title);
                    return;
                  }
                  final viewModel = context
                      .read<SubscriptionCheckoutViewModel>();
                  viewModel.doIntent(
                    const ResetSubscriptionCheckoutAfterFailureEvent(),
                  );
                  viewModel.doIntent(
                    LoadSubscriptionCheckoutEvent(paymentArgs),
                  );
                  return;
                }
                if (result is String && result.isNotEmpty) {
                  Navigator.of(context).pop(result);
                  return;
                }
              }
            }),
      );
      return;
    }

    final checkoutFailure = state.checkoutFailure;
    if (checkoutFailure != null &&
        checkoutFailure.code != SubscriptionErrorCodes.existingSubscription) {
      final message =
          checkoutFailure.code == 'checkout.quote_changed' ||
              checkoutFailure.exception.backendErrorCode ==
                  'checkout.quote_changed'
          ? context.localization.compensations_capacity_error
          : ErrorMessagePresenter.fromFailure(context, checkoutFailure);
      if (state.isCouponCheckoutFailure || state.isAvailabilityChangedFailure) {
        Navigator.of(context).pop(message);
        return;
      }
      CustomSnackbar.showError(context: context, message: message);
    }
  }

  void _handlePayNow(
    BuildContext context,
    SubscriptionCheckoutArgs args,
    SubscriptionCheckoutState state,
  ) {
    if (state.isCheckoutLoading) return;
    if (state.checkout != null || state.pendingSubscriptionId != null) {
      _handleStateTransitions(context, args, state);
      return;
    }
    if (args.summary.finalPrice <= 0) {
      final message =
          context.localization.coupon_error_full_discount_unsupported;
      CustomSnackbar.showError(context: context, message: message);
      return;
    }
    context.read<SubscriptionCheckoutViewModel>().doIntent(
      SubmitSubscriptionCheckoutEvent(args),
    );
  }

  bool _canPayNow(SubscriptionCheckoutState state) {
    if (state.checkout != null || state.pendingSubscriptionId != null) {
      return !state.isCheckoutLoading;
    }
    return !state.isCheckoutLoading &&
        state.selectedMethod != null &&
        state.selectedMethod!.isAvailable &&
        state.selectedMethod!.id != null &&
        state.selectedMethod!.id! > 0;
  }
}
