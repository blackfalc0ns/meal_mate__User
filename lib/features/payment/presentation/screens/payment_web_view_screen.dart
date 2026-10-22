import 'package:meal_meat_user/features/payment/domain/entities/payment_hold_clock.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_hold_notice.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
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

  PaymentHoldClock? _holdClock;
  PaymentCheckoutEntity? _activeCheckout;
  bool _canLaunch = false;
  bool _gatewayLaunched = false;
  final ValueNotifier<bool> _paymentBlocked = ValueNotifier(false);

  void _anchorHold(PaymentCheckoutEntity checkout) {
    _activeCheckout = checkout;
    final expiry = DateTime.tryParse(checkout.holdExpiresAtUtc);
    final server = checkout.serverTimeUtc ?? DateTime.now().toUtc();
    _holdClock = expiry != null
        ? PaymentHoldClock(expiresAtUtc: expiry, serverTimeUtc: server)
        : null;
    _canLaunch = _holdClock?.isExpired != true;
    _paymentBlocked.value = !_canLaunch;
  }

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<PaymentViewModel>();
    final checkout = widget.args?.checkout;
    if (checkout != null) {
      _anchorHold(checkout);
      _viewModel.doIntent(
        InitCheckoutSessionEvent(
          checkout,
          flowType: widget.args?.flowType ?? 'individual',
          batchId: widget.args?.batchId,
          batchVersion: widget.args?.batchVersion,
        ),
      );
    }
  }

  @override
  void dispose() {
    _paymentBlocked.dispose();
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
            previous.isPaymentFailed != current.isPaymentFailed ||
            previous.checkout != current.checkout ||
            previous.checkoutFailure != current.checkoutFailure ||
            previous.isSessionReady != current.isSessionReady,
        listener: (context, state) {
          if (state.checkout != null && state.checkout != _activeCheckout) {
            _anchorHold(state.checkout!);
            _gatewayLaunched = false;
          }
          if (state.isSessionReady &&
              !state.isReviewRequired &&
              !_gatewayLaunched &&
              _canLaunch &&
              (state.checkout?.paymentUrl.isNotEmpty ?? false)) {
            _gatewayLaunched = true;
            _viewModel.doIntent(const MarkPaymentLaunchedEvent());
          }
          if (state.checkoutFailure != null) {
            final failure = state.checkoutFailure!;
            final message =
                failure.code == 'checkout.quote_changed' ||
                    failure.exception.backendErrorCode ==
                        'checkout.quote_changed'
                ? locale.compensations_capacity_error
                : ErrorMessagePresenter.fromFailure(context, failure);
            if (state.isAvailabilityChangedFailure) {
              Navigator.of(context).pop(message);
              return;
            }
            CustomSnackbar.showError(context: context, message: message);
          }

          if (state.isFulfillmentSuccess) {
            final checkout = args.checkout;
            final subId = state.checkout?.subscriptionId.isNotEmpty == true
                ? state.checkout!.subscriptionId
                : checkout.subscriptionId;
            final isFamily = args.isFamily || state.isFamily;
            final conf = state.confirmation;
            final successArgs = PaymentSuccessArgs(
              subscriptionId: subId,
              packageName: conf?.bundleName(locale.localeName),
              durationDays: conf?.durationDays,
              restaurantTier: conf?.tierName(locale.localeName),
              paymentDate: conf?.paymentDate ??
                  DateTime.now().toIso8601String().split('T').first,
              startDate: (conf?.startDate?.isNotEmpty == true)
                  ? conf!.startDate!
                  : (checkout.startDate.isNotEmpty
                      ? checkout.startDate
                      : checkout.chosenStartDate),
              endDate: conf?.endDate,
              includeFriday: conf?.includeFriday ?? false,
              isFamily: isFamily,
              confirmation: conf,
              members: args.familyMembers,
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
            unawaited(
              Navigator.maybePop(context, PaymentSessionOutcome.failed),
            );
          }
        },
        builder: (context, state) {
          if (!state.isSessionReady) {
            final failure = state.checkoutFailure;
            return Scaffold(
              appBar: CustomAppBar(title: locale.payment_title),
              body: failure == null
                  ? const Center(child: CircularProgressIndicator())
                  : ApiErrorWidget(
                      exception: failure.exception,
                      onRetry: () => _viewModel.doIntent(
                        InitCheckoutSessionEvent(
                          args.checkout,
                          flowType: args.flowType,
                          batchId: args.batchId,
                          batchVersion: args.batchVersion,
                        ),
                      ),
                    ),
            );
          }
          final checkout = _activeCheckout ?? args.checkout;
          final isExpired = _holdClock?.isExpired == true;
          final holdNotice = _holdClock == null
              ? null
              : PaymentHoldNotice(
                  key: ObjectKey(_holdClock),
                  clock: _holdClock!,
                  isRenewing: state.isHoldRenewing,
                  isFullScreen: !_canLaunch || isExpired,
                  onExpired: () {
                    _paymentBlocked.value = true;
                    if (mounted) setState(() {});
                  },
                  onCancel: () => Navigator.of(context).maybePop(),
                  onRenew:
                      state.isReviewRequired ||
                          state.isFulfillmentLoading ||
                          state.isPaidProcessing ||
                          state.isPaymentPending
                      ? null
                      : () {
                          if (args.isFamily && !_gatewayLaunched) {
                            Navigator.of(context).pop();
                          } else {
                            _viewModel.doIntent(const RenewPaymentHoldEvent());
                          }
                        },
                );
          if ((!_canLaunch || isExpired) &&
              !state.isFulfillmentLoading &&
              !state.isReviewRequired &&
              !state.isPaymentPending) {
            return Scaffold(
              appBar: CustomAppBar(
                title: locale.payment_title,
                onBackPressed: () => Navigator.of(context).maybePop(),
              ),
              body: holdNotice,
            );
          }
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
              checkout.paymentUrl.isEmpty) {
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
            bottomNavigationBar: holdNotice,
            body: ValueListenableBuilder<bool>(
              valueListenable: _paymentBlocked,
              builder: (context, blocked, child) =>
                  IgnorePointer(ignoring: blocked, child: child),
              child: PaymentRedirectWebView(
                key: ValueKey(checkout.paymentUrl),
                paymentUrl: checkout.paymentUrl,
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
            ),
          );
        },
      ),
    );
  }
}
