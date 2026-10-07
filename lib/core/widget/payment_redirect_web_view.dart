import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/payment/payment_navigation.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentRedirectWebView extends StatefulWidget {
  const PaymentRedirectWebView({
    super.key,
    required this.paymentUrl,
    required this.isProcessing,
    this.onPaymentReturn,
    this.onSuccessRedirect,
    this.onErrorRedirect,
    this.processingMessage,
  });

  final String paymentUrl;
  final bool isProcessing;

  /// Authoritative typed return callback for Payzah payment flows.
  final void Function(PaymentReturn)? onPaymentReturn;

  /// Backward-compatible success callback during transitional migration.
  final VoidCallback? onSuccessRedirect;

  /// Backward-compatible error callback during transitional migration.
  final VoidCallback? onErrorRedirect;

  final String? processingMessage;

  @override
  State<PaymentRedirectWebView> createState() => _PaymentRedirectWebViewState();
}

class _PaymentRedirectWebViewState extends State<PaymentRedirectWebView> {
  WebViewController? _controller;
  bool _isPageLoading = true;
  bool _hasHandledReturn = false;
  bool _isInvalidUrl = false;

  @override
  void initState() {
    super.initState();

    if (!isValidInitialPaymentUrl(widget.paymentUrl)) {
      _isInvalidUrl = true;
      _isPageLoading = false;
      return;
    }

    final controller = WebViewController();
    unawaited(controller.setJavaScriptMode(JavaScriptMode.unrestricted));
    unawaited(
      controller.setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isPageLoading = true);
            _checkUrl(url);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isPageLoading = false);
          },
          onNavigationRequest: _handleNavigationRequest,
          onUrlChange: (change) {
            final url = change.url;
            if (url != null) {
              _checkUrl(url);
            }
          },
        ),
      ),
    );
    unawaited(controller.loadRequest(Uri.parse(widget.paymentUrl.trim())));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (_isInvalidUrl || _controller == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: color.error),
              const SizedBox(height: Spacing.sm),
              Text(
                locale.error_other_desc,
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller!),
        if (_isPageLoading || widget.isProcessing)
          ColoredBox(
            color: color.surface.withValues(alpha: 0.72),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (widget.processingMessage != null) ...[
                    const SizedBox(height: Spacing.md),
                    Text(
                      widget.processingMessage!,
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
    );
  }

  void _checkUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (uri.scheme == 'mealmate') {
      final paymentReturn = parsePaymentReturn(uri);
      if (paymentReturn != null) {
        _dispatchReturn(paymentReturn);
      }
    }
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    final result = handlePaymentNavigation(uri);

    if (result.paymentReturn != null) {
      _dispatchReturn(result.paymentReturn!);
    }

    return result.decision;
  }

  void _dispatchReturn(PaymentReturn paymentReturn) {
    if (_hasHandledReturn) return;
    _hasHandledReturn = true;

    if (widget.onPaymentReturn != null) {
      widget.onPaymentReturn!(paymentReturn);
      return;
    }

    if (paymentReturn.destination == PaymentReturnDestination.success) {
      widget.onSuccessRedirect?.call();
    } else {
      widget.onErrorRedirect?.call();
    }
  }
}
