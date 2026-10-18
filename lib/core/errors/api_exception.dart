import 'api_error_advice.dart';
import 'api_error_type.dart';

class ApiException implements Exception {
  const ApiException({
    required this.errorType,
    required this.message,
    this.statusCode,
    this.response,
    this.backendErrorCode,
    this.isTranslationKey = false,
    this.field,
    this.messageAr,
    this.messageEn,
    this.advice = const ApiErrorAdvice(),
  });

  final ApiErrorType errorType;
  final String message;
  final int? statusCode;
  final dynamic response;
  final String? backendErrorCode;
  final bool isTranslationKey;
  final String? field;
  final String? messageAr;
  final String? messageEn;
  final ApiErrorAdvice advice;

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

  /// Missing prerequisite step (e.g. 'ADDRESS', 'ALLERGIES')
  String? get missingStep {
    if (response is Map) {
      final step = (response as Map)['missingStep'];
      if (step is String && step.trim().isNotEmpty) return step.trim();
    }
    return null;
  }

  /// Target endpoint for missing prerequisite step
  String? get actionEndpoint {
    if (response is Map) {
      final endpoint = (response as Map)['actionEndpoint'];
      if (endpoint is String && endpoint.trim().isNotEmpty) return endpoint.trim();
    }
    return null;
  }

  @override
  String toString() {
    return message;
  }
}
