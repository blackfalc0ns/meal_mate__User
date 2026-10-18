import 'package:dio/dio.dart';
import 'package:meal_meat_user/core/errors/api_error_advice.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';

class Failure {
  Failure({
    required this.errorMessage,
    this.code = 'unknown',
    this.statusCode,
    this.field,
    this.messageAr,
    this.messageEn,
    this.advice = const ApiErrorAdvice(),
    ApiException? exception,
  }) : exception =
           exception ??
           ApiException(
             errorType: ApiErrorType.unknown,
             message: errorMessage,
             statusCode: statusCode,
             backendErrorCode: code,
             field: field,
             messageAr: messageAr,
             messageEn: messageEn,
             advice: advice,
           );

  Failure.fromException(ApiException exception)
    : this(
        errorMessage: exception.message,
        code: exception.backendErrorCode ?? exception.errorType.translationKey,
        statusCode: exception.statusCode,
        field: exception.field,
        messageAr: exception.messageAr,
        messageEn: exception.messageEn,
        advice: exception.advice,
        exception: exception,
      );

  final String errorMessage;
  final String code;
  final int? statusCode;
  final String? field;
  final String? messageAr;
  final String? messageEn;
  final ApiErrorAdvice advice;
  final ApiException exception;

  String? get missingStep => exception.missingStep;
  String? get actionEndpoint => exception.actionEndpoint;
}

class ServerFailure extends Failure {
  ServerFailure({
    required super.errorMessage,
    super.code,
    super.statusCode,
    super.field,
    super.messageAr,
    super.messageEn,
    super.advice,
    required super.exception,
  });

  factory ServerFailure.fromDioError({required DioException dioException}) {
    return ServerFailure._fromApiException(
      ApiExceptionMapper.fromDioException(dioException),
    );
  }

  factory ServerFailure.fromResponse(Response? response) {
    return ServerFailure._fromApiException(
      ApiExceptionMapper.fromResponse(response),
    );
  }

  factory ServerFailure._fromApiException(ApiException exception) {
    return ServerFailure(
      errorMessage: exception.message,
      code: exception.backendErrorCode ?? exception.errorType.translationKey,
      statusCode: exception.statusCode,
      field: exception.field,
      messageAr: exception.messageAr,
      messageEn: exception.messageEn,
      advice: exception.advice,
      exception: exception,
    );
  }
}

class AddressOutOfBoundsFailure extends Failure {
  AddressOutOfBoundsFailure({
    super.errorMessage = 'address.out_of_kuwait_bounds',
    super.code = 'address.out_of_kuwait_bounds',
  });
}

class LocationServiceDisabledFailure extends Failure {
  LocationServiceDisabledFailure({
    super.errorMessage = 'location_service_disabled',
    super.code = 'location_service_disabled',
  });
}

class LocationPermissionDeniedFailure extends Failure {
  LocationPermissionDeniedFailure({
    super.errorMessage = 'location_permission_denied',
    super.code = 'location_permission_denied',
  });
}

class LocationPermissionDeniedForeverFailure extends Failure {
  LocationPermissionDeniedForeverFailure({
    super.errorMessage = 'location_permission_denied_forever',
    super.code = 'location_permission_denied_forever',
  });
}
