import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key, this.args});

  final PaymentWebViewArgs? args;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final PaymentViewModel _viewModel;
  WebViewController? _controller;
  bool _isPageLoading = true;
  bool _hasStartedVerification = false;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<PaymentViewModel>();

    final paymentUrl = widget.args?.checkout.paymentUrl;
    if (paymentUrl == null || paymentUrl.isEmpty) return;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isPageLoading = true);
            _checkUrl(url);
          },
          onPageFinished: (_) => setState(() => _isPageLoading = false),
          onNavigationRequest: _handleNavigationRequest,
          onUrlChange: (change) {
            if (change.url != null) {
              _checkUrl(change.url!);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final controller = _controller;
    final args = widget.args;

    if (args == null || controller == null) {
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
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
              arguments: 1,
            );
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
            body: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (_isPageLoading ||
                    state.isFulfillmentLoading ||
                    state.isCalendarLoading)
                  ColoredBox(
                    color: color.surface.withValues(alpha: 0.72),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          if (state.isCalendarLoading) ...[
                            const SizedBox(height: Spacing.md),
                            Text(
                              locale.payment_calendar_preparing,
                              textAlign: TextAlign.center,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.onSurface,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _checkUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (_isBackendPaymentCallback(uri)) {
      _handleBackendPaymentCallback(uri);
    } else if (uri.scheme == 'mealmate') {
      _handleAppPaymentCallback(uri);
    }
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    if (uri == null) {
      return NavigationDecision.navigate;
    }

    if (_isBackendPaymentCallback(uri)) {
      _handleBackendPaymentCallback(uri);
      return NavigationDecision.prevent;
    }

    if (uri.scheme == 'mealmate') {
      return _handleAppPaymentCallback(uri);
    }

    return NavigationDecision.navigate;
  }

  bool _isBackendPaymentCallback(Uri uri) {
    final baseHost = Uri.tryParse(NetworkConstants.baseUrl)?.host;
    return (uri.host == baseHost ||
            uri.host == 'maelmate.runasp.net' ||
            uri.host.contains('trycloudflare.com')) &&
        uri.path.contains('/api/v1/payments/myfatoorah');
  }

  void _handleBackendPaymentCallback(Uri uri) {
    final target = Uri.tryParse(uri.queryParameters['to'] ?? '');
    if (target != null && target.scheme == 'mealmate') {
      _handleAppPaymentCallback(target);
      return;
    }

    _verifyPayment();
  }

  NavigationDecision _handleAppPaymentCallback(Uri uri) {
    final path = uri.path.toLowerCase();
    final host = uri.host.toLowerCase();

    if (path.contains('success') || host.contains('success')) {
      _verifyPayment();
      return NavigationDecision.prevent;
    }

    if (path.contains('error') || host.contains('error')) {
      _markPaymentFailed();
      return NavigationDecision.prevent;
    }

    _verifyPayment();
    return NavigationDecision.prevent;
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
