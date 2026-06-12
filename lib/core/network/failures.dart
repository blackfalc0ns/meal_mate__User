import 'package:dio/dio.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';

class Failure {
  Failure({
    required this.errorMessage,
    this.code = 'unknown',
    ApiException? exception,
  }) : exception =
           exception ??
           ApiException(errorType: ApiErrorType.unknown, message: errorMessage);

  Failure.fromException(ApiException exception)
    : this(errorMessage: exception.message, exception: exception);

  final String errorMessage;
  final String code;
  final ApiException exception;
}

class ServerFailure extends Failure {
  ServerFailure({
    required super.errorMessage,
    super.code,
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
      exception: exception,
    );
  }
}
