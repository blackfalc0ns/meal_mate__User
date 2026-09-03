import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentRedirectWebView extends StatefulWidget {
  const PaymentRedirectWebView({
    super.key,
    required this.paymentUrl,
    required this.isProcessing,
    required this.onSuccessRedirect,
    required this.onErrorRedirect,
    this.processingMessage,
  });

  final String paymentUrl;
  final bool isProcessing;
  final VoidCallback onSuccessRedirect;
  final VoidCallback onErrorRedirect;
  final String? processingMessage;

  @override
  State<PaymentRedirectWebView> createState() => _PaymentRedirectWebViewState();
}

class _PaymentRedirectWebViewState extends State<PaymentRedirectWebView> {
  late final WebViewController _controller;
  bool _isPageLoading = true;
  bool _hasHandledRedirect = false;

  @override
  void initState() {
    super.initState();

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
            final url = change.url;
            if (url != null) {
              _checkUrl(url);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Stack(
      children: [
        WebViewWidget(controller: _controller),
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
      _handleAppPaymentCallback(uri);
      return NavigationDecision.prevent;
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

    _markSuccess();
  }

  void _handleAppPaymentCallback(Uri uri) {
    final path = uri.path.toLowerCase();
    final host = uri.host.toLowerCase();

    if (path.contains('error') || host.contains('error')) {
      _markError();
      return;
    }

    _markSuccess();
  }

  void _markSuccess() {
    if (_hasHandledRedirect) return;
    _hasHandledRedirect = true;
    widget.onSuccessRedirect();
  }

  void _markError() {
    if (_hasHandledRedirect) return;
    _hasHandledRedirect = true;
    widget.onErrorRedirect();
  }
}
