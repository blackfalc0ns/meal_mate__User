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
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_body_section.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_footer.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, this.args});

  final PaymentArgs? args;

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

    return BlocProvider<PaymentViewModel>(
      create: (_) =>
          getIt<PaymentViewModel>()..doIntent(LoadPaymentEvent(paymentArgs)),
      child: BlocConsumer<PaymentViewModel, PaymentState>(
        listenWhen: (previous, current) =>
            previous.checkout != current.checkout ||
            previous.checkoutFailure != current.checkoutFailure ||
            previous.isFulfillmentSuccess != current.isFulfillmentSuccess,
        listener: (context, state) =>
            _handleStateTransitions(context, paymentArgs, state),
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: l10n.payment_title),
            body: PaymentBodySection(paymentArgs: paymentArgs, state: state),
            bottomNavigationBar: PaymentFooter(
              totalAmount: paymentArgs.summary.finalPrice,
              isLoading:
                  state.isCheckoutLoading ||
                  state.isFulfillmentLoading ||
                  state.isCalendarLoading,
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
    PaymentArgs paymentArgs,
    PaymentState state,
  ) {
    if (state.isFulfillmentSuccess) {
      final summary = paymentArgs.summary;
      final currentLocale = Localizations.localeOf(context).languageCode;
      final subscriptionId =
          state.pendingSubscriptionId ?? state.checkout?.subscriptionId ?? '';
      final successArgs = PaymentSuccessArgs(
        subscriptionId: subscriptionId,
        packageName: summary.bundleName(currentLocale).isNotEmpty
            ? summary.bundleName(currentLocale)
            : summary.programName(currentLocale),
        durationDays: summary.durationDays,
        restaurantTier: summary.tierName(currentLocale),
        paymentDate: DateTime.now().toIso8601String().split('T').first,
        startDate: summary.startDate.isNotEmpty
            ? summary.startDate
            : summary.chosenStartDate,
        endDate: summary.endDate,
      );
      unawaited(
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.paymentSuccess,
          (route) => false,
          arguments: successArgs,
        ),
      );
      return;
    }

    final checkout = state.checkout;
    if (checkout != null && checkout.paymentUrl.isNotEmpty) {
      unawaited(
        Navigator.of(context).pushNamed(
          AppRoutes.paymentWebView,
          arguments: PaymentWebViewArgs(checkout: checkout),
        ),
      );
      return;
    }

    final checkoutFailure = state.checkoutFailure;
    if (checkoutFailure != null &&
        checkoutFailure.code != SubscriptionErrorCodes.existingSubscription) {
      final message = ErrorMessagePresenter.fromFailure(
        context,
        checkoutFailure,
      );
      if (state.isCouponCheckoutFailure) {
        Navigator.of(context).pop(message);
        return;
      }
      CustomSnackbar.showError(context: context, message: message);
    }
  }

  void _handlePayNow(
    BuildContext context,
    PaymentArgs args,
    PaymentState state,
  ) {
    if (state.isCheckoutLoading) return;
    if (args.summary.finalPrice <= 0) {
      final message =
          context.localization.coupon_error_full_discount_unsupported;
      CustomSnackbar.showError(context: context, message: message);
      return;
    }
    context.read<PaymentViewModel>().doIntent(CheckoutPaymentEvent(args));
  }

  bool _canPayNow(PaymentState state) {
    if (state.checkoutFailure?.code ==
        SubscriptionErrorCodes.existingSubscription) {
      return false;
    }
    return !state.isCheckoutLoading &&
        !state.isFulfillmentLoading &&
        !state.isCalendarLoading &&
        state.methods.isNotEmpty;
  }
}
