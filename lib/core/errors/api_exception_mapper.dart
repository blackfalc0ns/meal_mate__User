import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/location_exception.dart';
import 'package:meal_meat_user/core/network/failures.dart';

class ApiExceptionMapper {
  const ApiExceptionMapper._();

  static ApiException fromFailure(Failure failure) => failure.exception;

  static Object unwrapError(Object error) {
    if (error is ParallelWaitError) {
      final errs = error.errors;
      if (errs is Iterable) {
        for (final e in errs) {
          if (e != null) {
            final real = e is AsyncError ? e.error : e;
            return unwrapError(real);
          }
        }
      } else if (errs is Record) {
        final dyn = errs as dynamic;
        final getters = <Object? Function()>[
          () => dyn.$1,
          () => dyn.$2,
          () => dyn.$3,
          () => dyn.$4,
          () => dyn.$5,
          () => dyn.$6,
          () => dyn.$7,
          () => dyn.$8,
          () => dyn.$9,
          () => dyn.$10,
        ];
        for (final getter in getters) {
          try {
            final val = getter();
            if (val != null) {
              final real = val is AsyncError ? val.error : val;
              return unwrapError(real);
            }
          } on NoSuchMethodError {
            break;
          } catch (_) {}
        }
      }
    }
    return error;
  }

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
      case DioExceptionType.transformTimeout:
        return _translationKeyException(ApiErrorType.requestTimeout);
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
    final unwrapped = unwrapError(error);

    if (unwrapped is ApiException) {
      return unwrapped;
    }

    if (unwrapped is Failure) {
      return fromFailure(unwrapped);
    }

    if (unwrapped is DioException) {
      return fromDioException(unwrapped);
    }

    if (unwrapped is LocationServiceException) {
      return switch (unwrapped.type) {
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

    return unknown(unwrapped);
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
    if (statusCode != null && statusCode >= 300) {
      return ApiErrorType.serverError;
    }
    return ApiErrorType.unknown;
  }

  static bool _isHtml(String text) {
    final lower = text.toLowerCase();
    return lower.contains('<html') ||
        lower.contains('<!doctype') ||
        lower.contains('<head') ||
        lower.contains('<body') ||
        lower.contains('<title') ||
        lower.contains('document moved') ||
        lower.contains('object moved') ||
        RegExp(r'<[a-zA-Z\/][^>]*>').hasMatch(text);
  }

  static String? _extractBackendMessage(dynamic data) {
    if (data is Map) {
      final fridayAvailabilityMessage = _extractMessageFromMap(
        data['fridayAvailability'],
      );
      if (fridayAvailabilityMessage != null) {
        return fridayAvailabilityMessage;
      }

      final backendMessage = _extractMessageFromMap(data);
      if (backendMessage != null) {
        return backendMessage;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      final trimmed = data.trim();
      if (!_isHtml(trimmed)) {
        return trimmed;
      }
    }

    return null;
  }

  static String? _extractMessageFromMap(dynamic data) {
    if (data is Map) {
      // 1. Check ASP.NET Core Problem Details validation errors dictionary
      final errors = data['errors'];
      if (errors is Map) {
        for (final value in errors.values) {
          if (value is List && value.isNotEmpty) {
            final first = value.first;
            if (first is String && first.trim().isNotEmpty && !_isHtml(first)) {
              return first.trim();
            }
          } else if (value is String &&
              value.trim().isNotEmpty &&
              !_isHtml(value)) {
            return value.trim();
          }
        }
      } else if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is String && first.trim().isNotEmpty && !_isHtml(first)) {
          return first.trim();
        } else if (first is Map) {
          final msg = _extractMessageFromMap(first);
          if (msg != null) return msg;
        }
      }

      final errorObj = data['error'];
      if (errorObj is Map) {
        final msg = _extractMessageFromMap(errorObj);
        if (msg != null) return msg;
      }

      // 2. Check standard keys
      for (final key in const [
        'detail',
        'message',
        'message_en',
        'message_ar',
        'errorMessage',
        'error_description',
        'description',
        'msg',
        'error',
        'title',
      ]) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          final trimmed = value.trim();
          if (!_isHtml(trimmed)) {
            return trimmed;
          }
        }
      }
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
