import 'package:dio/dio.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';

import 'failures.dart';

sealed class ApiResult<T> {}

class ApiSuccessResult<T> extends ApiResult<T> {
  ApiSuccessResult({required this.data});
  final T data;
}

class ApiErrorResult<T> extends ApiResult<T> {
  ApiErrorResult({required this.failure});
  final Failure failure;
}

Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final result = await apiCall();
    return ApiSuccessResult<T>(data: result);
  } on DioException catch (dioError) {
    return ApiErrorResult<T>(
      failure: ServerFailure.fromDioError(dioException: dioError),
    );
  } catch (error) {
    return ApiErrorResult<T>(
      failure: Failure.fromException(ApiExceptionMapper.fromError(error)),
    );
  }
}

Future<ApiResult<T>> safeLocalCall<T>(Future<T> Function() localCall) async {
  try {
    final result = await localCall();
    return ApiSuccessResult<T>(data: result);
  } catch (error) {
    return ApiErrorResult<T>(
      failure: Failure.fromException(ApiExceptionMapper.fromError(error)),
    );
  }
}
