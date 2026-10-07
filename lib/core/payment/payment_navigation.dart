import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Validates that an initial payment URL is a safe, absolute HTTPS URL.
bool isValidInitialPaymentUrl(String url) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return false;

  final uri = Uri.tryParse(trimmed);
  if (uri == null) return false;
  if (!uri.isAbsolute) return false;
  if (uri.scheme.toLowerCase() != 'https') return false;
  if (uri.host.isEmpty) return false;
  if (uri.userInfo.isNotEmpty) return false;

  return true;
}

class PaymentNavigationDecisionResult {
  const PaymentNavigationDecisionResult({
    required this.decision,
    this.paymentReturn,
  });

  final NavigationDecision decision;
  final PaymentReturn? paymentReturn;
}

/// Evaluates navigation requests in the payment WebView.
///
/// Rules:
/// - Custom `mealmate://` URLs are parsed via [parsePaymentReturn]. If recognized,
///   a [PaymentReturn] is emitted and navigation is prevented. If unrecognized,
///   navigation is prevented safely without emitting a return.
/// - Unrelated custom schemes (not https/http) are prevented without emitting a return.
/// - Legitimate HTTPS/HTTP URLs (including Payzah redirects and backend returns like
///   `/api/v1/payments/payzah/return`) are allowed to navigate normally so GET/POST
///   reaches the server. No client-side interception is performed on backend URLs.
PaymentNavigationDecisionResult handlePaymentNavigation(Uri? uri) {
  if (uri == null) {
    return const PaymentNavigationDecisionResult(
      decision: NavigationDecision.prevent,
    );
  }

  if (uri.scheme == 'mealmate') {
    final paymentReturn = parsePaymentReturn(uri);
    return PaymentNavigationDecisionResult(
      decision: NavigationDecision.prevent,
      paymentReturn: paymentReturn,
    );
  }

  // Prevent unknown custom schemes (e.g. intent:, tel:, sms:)
  if (uri.scheme != 'https' && uri.scheme != 'http') {
    return const PaymentNavigationDecisionResult(
      decision: NavigationDecision.prevent,
    );
  }

  // Allow standard web navigation
  return const PaymentNavigationDecisionResult(
    decision: NavigationDecision.navigate,
  );
}
