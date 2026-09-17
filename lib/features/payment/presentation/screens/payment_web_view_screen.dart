import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/payment_redirect_web_view.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key, this.args});

  final PaymentWebViewArgs? args;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final PaymentViewModel _viewModel;
  bool _hasStartedVerification = false;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<PaymentViewModel>();
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final args = widget.args;

    if (args == null || args.checkout.paymentUrl.isEmpty) {
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
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            Navigator.of(context).pushNamed(AppRoutes.profileBilling);
            return;
          }

          if (state.isPaymentFailed) {
            Navigator.maybePop(context);
          }
        },
        builder: (context, state) {
          final failure = state.fulfillmentFailure ?? state.calendarFailure;
          if (failure != null) {
            return Scaffold(
              appBar: CustomAppBar(title: locale.payment_title),
              body: ApiErrorWidget(
                exception: failure.exception,
                onRetry: () => _viewModel.doIntent(
                  state.isFulfillmentSuccess
                      ? PollSubscriptionCalendarEvent(
                          args.checkout.subscriptionId,
                        )
                      : VerifyPaymentFulfillmentEvent(
                          args.checkout.subscriptionId,
                        ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: CustomAppBar(title: locale.payment_title),
            body: PaymentRedirectWebView(
              paymentUrl: args.checkout.paymentUrl,
              isProcessing:
                  state.isFulfillmentLoading || state.isCalendarLoading,
              processingMessage: state.isCalendarLoading
                  ? locale.payment_calendar_preparing
                  : null,
              onSuccessRedirect: _verifyPayment,
              onErrorRedirect: _markPaymentFailed,
            ),
          );
        },
      ),
    );
  }

  void _verifyPayment() {
    if (_hasStartedVerification) return;
    _hasStartedVerification = true;

    final subscriptionId = widget.args?.checkout.subscriptionId ?? '';
    if (subscriptionId.isNotEmpty) {
      _viewModel.doIntent(VerifyPaymentFulfillmentEvent(subscriptionId));
    } else {
      _viewModel.doIntent(const MarkPaymentFailedEvent());
    }
  }

  void _markPaymentFailed() {
    if (_hasStartedVerification) return;
    _hasStartedVerification = true;
    _viewModel.doIntent(const MarkPaymentFailedEvent());
  }
}
