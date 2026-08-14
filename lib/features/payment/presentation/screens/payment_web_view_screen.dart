import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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
          onPageStarted: (_) => setState(() => _isPageLoading = true),
          onPageFinished: (_) => setState(() => _isPageLoading = false),
          onNavigationRequest: _handleNavigationRequest,
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
            previous.isFulfillmentSuccess != current.isFulfillmentSuccess,
        listener: (context, state) {
          if (state.isFulfillmentSuccess) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.calendar, (route) => false);
          }
        },
        builder: (context, state) {
          if (state.fulfillmentFailure != null) {
            return Scaffold(
              appBar: CustomAppBar(title: locale.payment_title),
              body: ApiErrorWidget(
                exception: state.fulfillmentFailure!.exception,
                onRetry: () => _viewModel.doIntent(
                  VerifyPaymentFulfillmentEvent(args.checkout.subscriptionId),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: CustomAppBar(title: locale.payment_title),
            body: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (_isPageLoading || state.isFulfillmentLoading)
                  ColoredBox(
                    color: color.surface.withValues(alpha: 0.72),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    if (uri == null || uri.scheme != 'mealmate' || uri.host != 'payment') {
      return NavigationDecision.navigate;
    }

    if (uri.path == '/success') {
      _viewModel.doIntent(
        VerifyPaymentFulfillmentEvent(
          widget.args?.checkout.subscriptionId ?? '',
        ),
      );
      return NavigationDecision.prevent;
    }

    if (uri.path == '/error') {
      Navigator.maybePop(context);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.prevent;
  }
}
