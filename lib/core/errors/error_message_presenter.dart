import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/network/failures.dart';

class ErrorMessagePresenter {
  const ErrorMessagePresenter._();

  static String fromFailure(BuildContext context, Failure failure) {
    final couponMessage = _tryExtractCouponMessage(context, failure.exception);
    if (couponMessage != null) {
      return couponMessage;
    }

    for (final candidate in [
      failure.code,
      failure.exception.backendErrorCode,
      failure.errorMessage,
      failure.exception.message,
    ]) {
      if (candidate != null &&
          candidate.trim().isNotEmpty &&
          candidate.trim() != 'unknown') {
        final mapped = mapFailureMessage(context, candidate.trim());
        if (mapped != candidate.trim()) {
          return mapped;
        }
      }
    }

    return userFacingMessage(context, failure.exception);
  }

  static String snackBarMessage(BuildContext context, ApiException exception) {
    return userFacingMessage(context, exception);
  }

  static String userFacingMessage(
    BuildContext context,
    ApiException exception,
  ) {
    final couponMessage = _tryExtractCouponMessage(context, exception);
    if (couponMessage != null) {
      return couponMessage;
    }

    final backendCodeMessage = localizedBackendCodeMessage(context, exception);
    if (backendCodeMessage != null) {
      return backendCodeMessage;
    }

    final backendMessage = tryGetUserFacingBackendMessage(exception);
    if (backendMessage != null) {
      return backendMessage;
    }

    return mapFailureMessage(context, exception.errorType.translationKey);
  }

  static String? _tryExtractCouponMessage(
    BuildContext context,
    ApiException exception,
  ) {
    final res = exception.response;
    if (res is! Map) return null;

    final coupon = res['coupon'];
    if (coupon is! Map) return null;

    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == 'ar';

    final preferredKey = isArabic ? 'messageAr' : 'messageEn';
    final fallbackKey = isArabic ? 'messageEn' : 'messageAr';

    final message = coupon[preferredKey] ??
        coupon[isArabic ? 'message_ar' : 'message_en'] ??
        coupon[fallbackKey] ??
        coupon[isArabic ? 'message_en' : 'message_ar'];

    if (message is String && message.trim().isNotEmpty) {
      final sanitized = sanitizeBackendMessage(message);
      if (sanitized != null) return sanitized;
    }

    final status = coupon['status'];
    if (status is String && status.trim().isNotEmpty) {
      final mapped = mapFailureMessage(context, status.trim());
      if (mapped != status.trim()) return mapped;
    }

    return null;
  }

  static String? localizedBackendCodeMessage(
    BuildContext context,
    ApiException exception,
  ) {
    for (final code in [exception.backendErrorCode, exception.message]) {
      if (code == null || code.trim().isEmpty) {
        continue;
      }
      final trimmedCode = code.trim();
      final message = mapFailureMessage(context, trimmedCode);
      if (message != trimmedCode) {
        return message;
      }
    }

    return null;
  }

  static String? tryGetUserFacingBackendMessage(ApiException exception) {
    if (exception.isTranslationKey) return null;
    return sanitizeBackendMessage(exception.message);
  }

  static String? sanitizeBackendMessage(String? message) {
    if (message == null) return null;

    final trimmed = message.trim();
    if (trimmed.isEmpty) return null;
    if (_looksTechnical(trimmed)) return null;

    return trimmed;
  }

  static bool hasUserFacingBackendMessage(ApiException exception) {
    return tryGetUserFacingBackendMessage(exception) != null;
  }

  static bool _looksTechnical(String message) {
    final lower = message.toLowerCase();

    // Detect HTML tags or server redirect response bodies
    if (lower.contains('<html') ||
        lower.contains('<!doctype') ||
        lower.contains('<head') ||
        lower.contains('<body') ||
        lower.contains('<title') ||
        lower.contains('document moved') ||
        lower.contains('object moved') ||
        RegExp(r'<[a-zA-Z\/][^>]*>').hasMatch(message)) {
      return true;
    }

    const technicalFragments = <String>[
      'sql',
      'mysql',
      'postgres',
      'sqlite',
      'database',
      'query',
      'exception',
      'stack trace',
      'trace:',
      'nullreference',
      'typeerror',
      'syntaxerror',
      'laravel',
      'eloquent',
      'sqlstate',
      'pdo',
      'select ',
      'insert ',
      'update ',
      'delete ',
      ' from ',
      ' where ',
      '.php',
      '.dart',
      '.kt',
      '.java',
      '.cs',
      '.swift',
      '/var/',
      '/usr/',
      'c:\\',
      'd:\\',
      'stacktrace',
      'api key',
      'api_key',
      'statuscode',
      'validation_error',
      'traceid',
      'trace_id',
      'errorcode',
      'error_code',
    ];

    if (technicalFragments.any(lower.contains)) {
      return true;
    }

    // Detect embedded JSON objects
    if (message.contains('{') && message.contains('}')) {
      return true;
    }

    final pathPattern = RegExp(r'([a-zA-Z]:\\|/).+');
    final stackLinePattern = RegExp(r'^\s*#?\d+\s+', multiLine: true);
    final sqlKeywordPattern = RegExp(
      r'\b(select|insert|update|delete|from|where|join)\b',
    );

    return pathPattern.hasMatch(message) ||
        stackLinePattern.hasMatch(message) ||
        sqlKeywordPattern.hasMatch(lower);
  }
}
