/// Structured client advice derived from backend contract v3.1 errors.
class ApiErrorAdvice {
  const ApiErrorAdvice({
    this.retryable = false,
    this.refreshSummaryRequired = false,
    this.refreshAvailabilityRequired = false,
    this.additionalData = const {},
  });

  /// Whether the operation is safe to retry with the same or updated parameters.
  final bool retryable;

  /// Whether the client must refresh the checkout/subscription summary before proceeding.
  final bool refreshSummaryRequired;

  /// Whether the client must refresh restaurant/menu availability before proceeding.
  final bool refreshAvailabilityRequired;

  /// Retains any extra unmapped advice fields to ensure no server data is lost.
  final Map<String, dynamic> additionalData;

  /// Constructs [ApiErrorAdvice] by inspecting server response data, HTTP status code, and error code.
  factory ApiErrorAdvice.fromData(
    dynamic data, {
    int? statusCode,
    String? code,
  }) {
    bool? explicitRetryable;
    bool? explicitRefreshSummary;
    bool? explicitRefreshAvailability;
    final extra = <String, dynamic>{};

    if (data is Map) {
      final adviceMap = data['advice'];
      if (adviceMap is Map) {
        for (final entry in adviceMap.entries) {
          final key = entry.key.toString();
          if (key == 'retryable' && entry.value is bool) {
            explicitRetryable = entry.value as bool;
          } else if (key == 'refreshSummaryRequired' && entry.value is bool) {
            explicitRefreshSummary = entry.value as bool;
          } else if (key == 'refreshAvailabilityRequired' && entry.value is bool) {
            explicitRefreshAvailability = entry.value as bool;
          } else {
            extra[key] = entry.value;
          }
        }
      }
    }

    // Default heuristics based on HTTP status code and documented client actions:
    bool defaultRetryable = false;
    bool defaultRefreshSummary = false;
    bool defaultRefreshAvailability = false;

    final normalizedCode = code?.trim().toLowerCase() ?? '';

    switch (statusCode) {
      case 400:
        // Bad request / Validation / Coupon rejection
        if (normalizedCode.contains('coupon') ||
            normalizedCode.contains('summary') ||
            normalizedCode.contains('quote') ||
            normalizedCode.contains('batch')) {
          defaultRefreshSummary = true;
        }
        if (normalizedCode.contains('restaurant') ||
            normalizedCode.contains('availability') ||
            normalizedCode.contains('address') ||
            normalizedCode.contains('friday')) {
          defaultRefreshAvailability = true;
        }
        break;
      case 404:
        // Not found - expired session or missing quote/invoice
        if (normalizedCode.contains('summary') ||
            normalizedCode.contains('quote') ||
            normalizedCode.contains('batch') ||
            normalizedCode.contains('subscription')) {
          defaultRefreshSummary = true;
        }
        break;
      case 409:
        // Conflict - permissions, version, capacity, quote, Friday availability
        defaultRefreshSummary = true;
        defaultRefreshAvailability = true;
        break;
      case 410:
        // Gone - hold expired, quote expired
        defaultRetryable = true;
        defaultRefreshSummary = true;
        defaultRefreshAvailability = true;
        break;
      case 422:
        // Unprocessable entity - semantic validation
        if (normalizedCode.contains('capacity') ||
            normalizedCode.contains('availability') ||
            normalizedCode.contains('selection')) {
          defaultRefreshAvailability = true;
          defaultRefreshSummary = true;
        }
        break;
      case 502:
        // Bad gateway - payment gateway temporary failure
        defaultRetryable = true;
        break;
      case 503:
      case 504:
        defaultRetryable = true;
        break;
    }

    // Explicit documented error codes:
    if (normalizedCode == 'checkout.capacity_hold_expired' ||
        normalizedCode == 'capacity_hold_expired' ||
        normalizedCode == 'hold_expired') {
      defaultRetryable = true;
      defaultRefreshSummary = true;
      defaultRefreshAvailability = true;
    } else if (normalizedCode == 'family.coupon_rejected' ||
        normalizedCode == 'checkout.coupon_rejected' ||
        normalizedCode == 'family.coupon_context_unavailable' ||
        normalizedCode == 'checkout.coupon_no_longer_valid' ||
        normalizedCode == 'family.quote_changed') {
      defaultRefreshSummary = true;
    } else if (normalizedCode == 'no_restaurants_for_address' ||
        normalizedCode == 'no_restaurants_for_selection' ||
        normalizedCode == 'subscription_flow.no_restaurants_for_selection' ||
        normalizedCode == 'subscription_flow.no_restaurants_for_address' ||
        normalizedCode == 'subscription_flow.no_prepared_restaurants' ||
        normalizedCode == 'subscription_flow.friday_unavailable' ||
        normalizedCode == 'friday_unavailable') {
      defaultRefreshAvailability = true;
    }

    return ApiErrorAdvice(
      retryable: explicitRetryable ?? defaultRetryable,
      refreshSummaryRequired:
          explicitRefreshSummary ?? defaultRefreshSummary,
      refreshAvailabilityRequired:
          explicitRefreshAvailability ?? defaultRefreshAvailability,
      additionalData: extra,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiErrorAdvice &&
          runtimeType == other.runtimeType &&
          retryable == other.retryable &&
          refreshSummaryRequired == other.refreshSummaryRequired &&
          refreshAvailabilityRequired == other.refreshAvailabilityRequired;

  @override
  int get hashCode =>
      retryable.hashCode ^
      refreshSummaryRequired.hashCode ^
      refreshAvailabilityRequired.hashCode;

  @override
  String toString() =>
      'ApiErrorAdvice(retryable: $retryable, refreshSummaryRequired: $refreshSummaryRequired, refreshAvailabilityRequired: $refreshAvailabilityRequired, additionalData: $additionalData)';
}
