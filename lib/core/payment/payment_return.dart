import 'package:flutter/foundation.dart';

enum PaymentReturnDestination { success, error, pending, review }

@immutable
class PaymentReturn {
  const PaymentReturn({
    required this.destination,
    required this.paymentId,
    this.sessionId,
    this.callbackStatus,
    this.isCampaign = false,
  });

  final PaymentReturnDestination destination;
  final String paymentId;
  final String? sessionId;
  final String? callbackStatus;
  final bool isCampaign;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentReturn &&
          runtimeType == other.runtimeType &&
          destination == other.destination &&
          paymentId == other.paymentId &&
          sessionId == other.sessionId &&
          callbackStatus == other.callbackStatus &&
          isCampaign == other.isCampaign;

  @override
  int get hashCode =>
      destination.hashCode ^
      paymentId.hashCode ^
      sessionId.hashCode ^
      callbackStatus.hashCode ^
      isCampaign.hashCode;

  @override
  String toString() =>
      'PaymentReturn(destination: $destination, paymentId: $paymentId, sessionId: $sessionId, callbackStatus: $callbackStatus, isCampaign: $isCampaign)';
}

/// Parses a payment return URI.
///
/// Supports:
/// - Standard subscription checkout: `mealmate://checkout/{destination}?paymentId=pz-...`
/// - Campaign checkout payment: `mealmate://campaign-payment/callback` or `mealmate://campaign-payment/error`
PaymentReturn? parsePaymentReturn(Uri uri) {
  if (uri.scheme != 'mealmate') return null;
  if (uri.userInfo.isNotEmpty) return null;
  if (uri.hasPort) return null;
  if (uri.hasFragment || uri.fragment.isNotEmpty) return null;

  if (uri.host == 'checkout') {
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

  if (uri.host == 'campaign-payment') {
    final segments = uri.pathSegments;
    if (segments.length != 1) return null;

    final segment = segments.first;
    final PaymentReturnDestination destination;
    if (segment == 'callback') {
      destination = PaymentReturnDestination.pending;
    } else if (segment == 'error') {
      destination = PaymentReturnDestination.error;
    } else {
      return null;
    }

    final sessionId = uri.queryParameters['sessionId'];
    final paymentId = uri.queryParameters['paymentId'] ?? '';
    final status = uri.queryParameters['status'];

    if (paymentId.isNotEmpty) {
      if (paymentId.length > 256) return null;
      for (var i = 0; i < paymentId.length; i++) {
        final codeUnit = paymentId.codeUnitAt(i);
        if (codeUnit <= 0x1F || codeUnit == 0x7F) return null;
      }
    }

    if (sessionId != null) {
      if (sessionId.length > 256) return null;
      for (var i = 0; i < sessionId.length; i++) {
        final codeUnit = sessionId.codeUnitAt(i);
        if (codeUnit <= 0x1F || codeUnit == 0x7F) return null;
      }
    }

    return PaymentReturn(
      destination: destination,
      paymentId: paymentId,
      sessionId: sessionId,
      callbackStatus: status,
      isCampaign: true,
    );
  }

  return null;
}
