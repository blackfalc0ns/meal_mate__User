import 'api_error_type.dart';

class ApiException implements Exception {
  const ApiException({
    required this.errorType,
    required this.message,
    this.statusCode,
    this.response,
    this.backendErrorCode,
    this.isTranslationKey = false,
  });

  final ApiErrorType errorType;
  final String message;
  final int? statusCode;
  final dynamic response;
  final String? backendErrorCode;
  final bool isTranslationKey;

  /// Extra metadata for ProblemDetails responses (e.g. delivery version conflict)
  int? get currentVersion {
    if (response is Map) {
      final v = (response as Map)['currentVersion'];
      if (v is int) return v;
      if (v is num) return v.toInt();
    }
    return null;
  }

  /// Extra metadata for price change responses
  num? get amount {
    if (response is Map) {
      final a = (response as Map)['amount'];
      if (a is num) return a;
    }
    return null;
  }

  /// Extra metadata for currency
  String? get currency {
    if (response is Map) {
      final c = (response as Map)['currency'];
      if (c is String) return c;
    }
    return null;
  }

  /// Request path or ProblemDetails instance
  String? get instance {
    if (response is Map) {
      final inst = (response as Map)['instance'];
      if (inst is String) return inst;
    }
    return null;
  }

  @override
  String toString() {
    return message;
  }
}

