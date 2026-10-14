import 'dart:io';
import 'package:dio/dio.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_management/shared/family_management_failure.dart';

FamilyManagementFailure mapFamilyManagementError(Object error) {
  final unwrapped = ApiExceptionMapper.unwrapError(error);

  if (unwrapped is FamilyManagementFailure) {
    return unwrapped;
  }

  int? statusCode;
  String? extractedCode;
  String? extractedMessage;
  int? currentVersion;
  int? batchVersion;
  bool isNetwork = false;
  ApiException? apiException;

  if (unwrapped is DioException) {
    statusCode = unwrapped.response?.statusCode;
    apiException = ApiExceptionMapper.fromDioException(unwrapped);

    if (unwrapped.type == DioExceptionType.connectionTimeout ||
        unwrapped.type == DioExceptionType.sendTimeout ||
        unwrapped.type == DioExceptionType.receiveTimeout ||
        unwrapped.type == DioExceptionType.connectionError ||
        unwrapped.error is SocketException) {
      isNetwork = true;
    }

    final data = unwrapped.response?.data;
    if (data is Map) {
      extractedCode = data['code']?.toString() ?? data['error']?.toString();
      extractedMessage = data['detail']?.toString() ??
          data['message']?.toString() ??
          data['title']?.toString();
      if (data['currentVersion'] is num) {
        currentVersion = (data['currentVersion'] as num).toInt();
      }
      if (data['batchVersion'] is num) {
        batchVersion = (data['batchVersion'] as num).toInt();
      }
    }
  } else if (unwrapped is ApiException) {
    apiException = unwrapped;
    statusCode = unwrapped.statusCode;
    extractedCode = unwrapped.backendErrorCode;
    extractedMessage = unwrapped.message;

    final data = unwrapped.response;
    if (data is Map) {
      extractedCode ??=
          data['code']?.toString() ?? data['error']?.toString();
      final detail = data['detail']?.toString() ??
          data['message']?.toString() ??
          data['title']?.toString();
      if (detail != null && detail.isNotEmpty) {
        extractedMessage = detail;
      }
      if (data['currentVersion'] is num) {
        currentVersion = (data['currentVersion'] as num).toInt();
      }
      if (data['batchVersion'] is num) {
        batchVersion = (data['batchVersion'] as num).toInt();
      }
    }
  } else if (unwrapped is Failure) {
    apiException = unwrapped.exception;
    statusCode = unwrapped.exception.statusCode;
    extractedCode = unwrapped.code != 'unknown'
        ? unwrapped.code
        : unwrapped.exception.backendErrorCode;
    extractedMessage = unwrapped.errorMessage;
  } else if (unwrapped is SocketException) {
    isNetwork = true;
    extractedCode = 'error_no_internet';
    extractedMessage = 'No internet connection';
  }

  // Derive final code and fallback
  final code = extractedCode?.trim().isNotEmpty == true
      ? extractedCode!.trim()
      : (statusCode == 401
          ? 'auth.unauthorized'
          : (statusCode == 403
              ? SubscriptionErrorCodes.authForbidden
              : (statusCode == 404
                  ? SubscriptionErrorCodes.commonNotFound
                  : (statusCode == 409
                      ? SubscriptionErrorCodes.familyPermissionsChanged
                      : (isNetwork ? 'error_no_internet' : 'unknown')))));

  final message = extractedMessage?.trim().isNotEmpty == true
      ? extractedMessage!.trim()
      : (apiException?.message ?? 'error_unknown');

  // Classification flags
  final requiresManager = code == SubscriptionErrorCodes.familyNotManager;
  final isPausedMember = code == SubscriptionErrorCodes.familyAccessPaused ||
      code == SubscriptionErrorCodes.familyMemberPaused;
  final isPermissionConflict =
      code == SubscriptionErrorCodes.familyPermissionsChanged ||
          code == SubscriptionErrorCodes.familyPermissionsVersionRequired;
  final isQuoteChanged = code == SubscriptionErrorCodes.familyQuoteChanged;
  final isAuthForbidden = statusCode == 403 ||
      code == SubscriptionErrorCodes.authForbidden ||
      code == SubscriptionErrorCodes.familyPermissionDenied;
  final isFulfillmentNotReady =
      code == SubscriptionErrorCodes.calendarFulfillmentNotReady ||
          code == 'fulfillment_not_ready';

  return FamilyManagementFailure(
    errorMessage: message,
    code: code,
    exception: apiException,
    statusCode: statusCode,
    currentVersion: currentVersion,
    batchVersion: batchVersion,
    requiresManager: requiresManager,
    isPausedMember: isPausedMember,
    isPermissionConflict: isPermissionConflict,
    isQuoteChanged: isQuoteChanged,
    isAuthForbidden: isAuthForbidden,
    isFulfillmentNotReady: isFulfillmentNotReady,
    isNetworkError: isNetwork,
  );
}
