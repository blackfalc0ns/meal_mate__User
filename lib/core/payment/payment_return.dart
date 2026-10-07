import 'package:flutter/foundation.dart';

enum PaymentReturnDestination { success, error, pending, review }

@immutable
class PaymentReturn {
  const PaymentReturn({required this.destination, required this.paymentId});

  final PaymentReturnDestination destination;
  final String paymentId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentReturn &&
          runtimeType == other.runtimeType &&
          destination == other.destination &&
          paymentId == other.paymentId;

  @override
  int get hashCode => destination.hashCode ^ paymentId.hashCode;

  @override
  String toString() =>
      'PaymentReturn(destination: $destination, paymentId: $paymentId)';
}

/// Parses a payment return URI.
///
/// Strictly enforces:
/// - Exact scheme `mealmate`
/// - Host `checkout`
/// - Path matching one of: `/success`, `/error`, `/pending`, `/review`
/// - No userinfo, explicit port, or fragment
/// - Exactly one `paymentId` query parameter with `pz-` prefix and nonempty suffix
/// - Bounded length and no control characters
///
/// Returns [PaymentReturn] if valid, or `null` otherwise.
PaymentReturn? parsePaymentReturn(Uri uri) {
  if (uri.scheme != 'mealmate') return null;
  if (uri.host != 'checkout') return null;
  if (uri.userInfo.isNotEmpty) return null;
  if (uri.hasPort) return null;
  if (uri.hasFragment || uri.fragment.isNotEmpty) return null;

  // Path must be exactly one segment: success, error, pending, or review
  final segments = uri.pathSegments;
  if (segments.length != 1) return null;

  final destination = switch (segments.first) {
    'success' => PaymentReturnDestination.success,
    'error' => PaymentReturnDestination.error,
    'pending' => PaymentReturnDestination.pending,
    'review' => PaymentReturnDestination.review,
    _ => null,
  };

  if (destination == null) return null;

  final paymentIds = uri.queryParametersAll['paymentId'];
  if (paymentIds == null || paymentIds.length != 1) return null;

  final paymentId = paymentIds.first;
  if (!paymentId.startsWith('pz-') || paymentId.length <= 3) return null;
  if (paymentId.length > 256) return null;

  // Reject control characters (0x00 - 0x1F, 0x7F)
  for (var i = 0; i < paymentId.length; i++) {
    final codeUnit = paymentId.codeUnitAt(i);
    if (codeUnit <= 0x1F || codeUnit == 0x7F) return null;
  }

  return PaymentReturn(destination: destination, paymentId: paymentId);
}
