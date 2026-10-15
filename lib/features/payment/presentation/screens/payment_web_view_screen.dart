import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/payment_redirect_web_view.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_unresolved_status_view.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key, this.args});

  final PaymentWebViewArgs? args;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final PaymentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<PaymentViewModel>();
    final checkout = widget.args?.checkout;
    if (checkout != null) {
      _viewModel.doIntent(
        InitCheckoutSessionEvent(
          checkout,
          flowType: widget.args?.flowType ?? 'individual',
          batchId: widget.args?.batchId,
          batchVersion: widget.args?.batchVersion,
        ),
      );
      if (checkout.paymentUrl.isEmpty) {
        if (checkout.subscriptionId.isNotEmpty) {
          _viewModel.doIntent(
            VerifyPaymentFulfillmentEvent(checkout.subscriptionId),
          );
        } else if (checkout.paymentId != null &&
            checkout.paymentId!.isNotEmpty) {
          _viewModel.doIntent(
            HandlePaymentReturnEvent(
              PaymentReturn(
                destination: PaymentReturnDestination.pending,
                paymentId: checkout.paymentId!,
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    unawaited(_viewModel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final args = widget.args;

    if (args == null ||
        (args.checkout.paymentUrl.isEmpty &&
            (args.checkout.paymentId?.isEmpty ?? true) &&
            args.checkout.subscriptionId.isEmpty)) {
      return Scaffold(
        appBar: CustomAppBar(title: locale.payment_title),
        body: EmptyStateWidget(
          title: locale.payment_title,
          description: locale.payment_secure_label,
          icon: Icons.payment_rounded,
        ),
      );
    }

    return BlocProvider<PaymentViewModel>.value(
      value: _viewModel,
      child: BlocConsumer<PaymentViewModel, PaymentState>(
        listenWhen: (previous, current) =>
            previous.isFulfillmentSuccess != current.isFulfillmentSuccess ||
            previous.isPaymentFailed != current.isPaymentFailed,
        listener: (context, state) {
          if (state.isFulfillmentSuccess) {
            final checkout = args.checkout;
            final subId = state.checkout?.subscriptionId.isNotEmpty == true
                ? state.checkout!.subscriptionId
                : checkout.subscriptionId;
            final isFamily = args.isFamily || state.isFamily;
            final successArgs = PaymentSuccessArgs(
              subscriptionId: subId,
              paymentDate: DateTime.now().toIso8601String().split('T').first,
              startDate: checkout.startDate.isNotEmpty
                  ? checkout.startDate
                  : checkout.chosenStartDate,
              isFamily: isFamily,
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

          if (state.isPaymentFailed) {
            unawaited(Navigator.maybePop(context));
          }
        },
        builder: (context, state) {
          final failure = state.fulfillmentFailure ?? state.calendarFailure;
          if (failure != null) {
            final subId = args.checkout.subscriptionId.isNotEmpty
                ? args.checkout.subscriptionId
                : (state.checkout?.subscriptionId ?? '');
            return Scaffold(
              appBar: CustomAppBar(title: locale.payment_title),
              body: ApiErrorWidget(
                exception: failure.exception,
                onRetry: () => _viewModel.doIntent(
                  state.isFulfillmentSuccess
                      ? PollSubscriptionCalendarEvent(subId)
                      : VerifyPaymentFulfillmentEvent(subId),
                ),
              ),
            );
          }

          if (state.isReviewRequired ||
              state.isPaymentPending ||
              args.checkout.paymentUrl.isEmpty) {
            final subId = args.checkout.subscriptionId.isNotEmpty
                ? args.checkout.subscriptionId
                : (state.checkout?.subscriptionId ?? '');
            return Scaffold(
              appBar: CustomAppBar(title: locale.payment_title),
              body: PaymentUnresolvedStatusView(
                isReviewRequired: state.isReviewRequired,
                attemptHandle: state.attemptHandle ?? args.checkout.paymentId,
                isCheckingStatus: state.isFulfillmentLoading,
                onCheckStatus: () {
                  if (subId.isNotEmpty) {
                    _viewModel.doIntent(VerifyPaymentFulfillmentEvent(subId));
                  } else {
                    _viewModel.doIntent(
                      HandlePaymentReturnEvent(
                        PaymentReturn(
                          destination: PaymentReturnDestination.pending,
                          paymentId:
                              args.checkout.paymentId ??
                              state.attemptHandle ??
                              '',
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }

          return Scaffold(
            appBar: CustomAppBar(title: locale.payment_title),
            body: PaymentRedirectWebView(
              paymentUrl: args.checkout.paymentUrl,
              isProcessing:
                  state.isFulfillmentLoading ||
                  state.isCalendarLoading ||
                  state.isPaidProcessing,
              processingMessage:
                  (state.isCalendarLoading || state.isPaidProcessing)
                  ? locale.payment_calendar_preparing
                  : null,
              onPaymentReturn: (paymentReturn) {
                _viewModel.doIntent(HandlePaymentReturnEvent(paymentReturn));
              },
            ),
          );
        },
      ),
    );
  }
}
