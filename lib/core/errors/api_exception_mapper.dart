import 'package:dio/dio.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/location_exception.dart';
import 'package:meal_meat_user/core/network/failures.dart';

class ApiExceptionMapper {
  const ApiExceptionMapper._();

  static ApiException fromFailure(Failure failure) => failure.exception;

  static ApiException fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return _translationKeyException(ApiErrorType.connectionTimeout);
      case DioExceptionType.sendTimeout:
        return _translationKeyException(ApiErrorType.sendTimeout);
      case DioExceptionType.receiveTimeout:
        return _translationKeyException(ApiErrorType.receiveTimeout);
      case DioExceptionType.badCertificate:
        return _translationKeyException(ApiErrorType.other);
      case DioExceptionType.cancel:
        return _translationKeyException(ApiErrorType.cancelled);
      case DioExceptionType.connectionError:
        return _translationKeyException(ApiErrorType.noInternetConnection);
      case DioExceptionType.unknown:
        return _translationKeyException(ApiErrorType.unknown);
      case DioExceptionType.badResponse:
        return fromResponse(dioException.response);
    }
  }

  static ApiException fromResponse(Response<dynamic>? response) {
    if (response == null) {
      return _translationKeyException(ApiErrorType.serverError);
    }

    final errorType = _mapStatusCode(response.statusCode);
    final backendMessage = _extractBackendMessage(response.data);

    return ApiException(
      errorType: errorType,
      message: backendMessage ?? errorType.translationKey,
      statusCode: response.statusCode,
      response: response.data,
      backendErrorCode: _extractBackendErrorCode(response.data),
      isTranslationKey: backendMessage == null,
    );
  }

  static ApiException unknown([Object? error]) {
    return ApiException(
      errorType: ApiErrorType.unknown,
      message: ApiErrorType.unknown.translationKey,
      response: error,
      isTranslationKey: true,
    );
  }

  static ApiException fromError(Object error) {
    if (error is ApiException) {
      return error;
    }

    if (error is LocationServiceException) {
      return switch (error.type) {
        LocationErrorType.serviceDisabled => _translationKeyException(
          ApiErrorType.locationServiceDisabled,
        ),
        LocationErrorType.permissionDenied => _translationKeyException(
          ApiErrorType.locationPermissionDenied,
        ),
        LocationErrorType.permissionDeniedForever => _translationKeyException(
          ApiErrorType.locationPermissionDeniedForever,
        ),
      };
    }

    return unknown(error);
  }

  static ApiException _translationKeyException(ApiErrorType errorType) {
    return ApiException(
      errorType: errorType,
      message: errorType.translationKey,
      isTranslationKey: true,
    );
  }

  static ApiErrorType _mapStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return ApiErrorType.badRequest;
      case 401:
        return ApiErrorType.unauthorized;
      case 403:
        return ApiErrorType.forbidden;
      case 404:
        return ApiErrorType.notFound;
      case 405:
        return ApiErrorType.methodNotAllowed;
      case 406:
        return ApiErrorType.notAcceptable;
      case 408:
        return ApiErrorType.requestTimeout;
      case 409:
        return ApiErrorType.conflict;
      case 410:
        return ApiErrorType.gone;
      case 411:
        return ApiErrorType.lengthRequired;
      case 412:
        return ApiErrorType.preconditionFailed;
      case 413:
        return ApiErrorType.payloadTooLarge;
      case 414:
        return ApiErrorType.uriTooLong;
      case 415:
        return ApiErrorType.unsupportedMediaType;
      case 416:
        return ApiErrorType.rangeNotSatisfiable;
      case 417:
        return ApiErrorType.expectationFailed;
      case 422:
        return ApiErrorType.validationError;
      case 429:
        return ApiErrorType.tooManyRequests;
      case 500:
        return ApiErrorType.internalServerError;
      case 502:
        return ApiErrorType.badGateway;
      case 503:
        return ApiErrorType.serviceUnavailable;
      case 504:
        return ApiErrorType.gatewayTimeout;
    }

    if (statusCode != null && statusCode >= 500) {
      return ApiErrorType.serverError;
    }
    if (statusCode != null && statusCode >= 400) {
      return ApiErrorType.badRequest;
    }
    return ApiErrorType.unknown;
  }

  static String? _extractBackendMessage(dynamic data) {
    if (data is Map) {
      for (final key in const [
        'detail',
        'message',
        'message_en',
        'message_ar',
        'error',
        'title',
      ]) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    return null;
  }

  static String? _extractBackendErrorCode(dynamic data) {
    if (data is Map) {
      for (final key in const ['errorCode', 'code', 'error_code', 'error']) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }

    return null;
  }
}
