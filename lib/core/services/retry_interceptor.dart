import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/di/di.dart';

/// Interceptor that retries requests on 429 (Too Many Requests) with
/// exponential backoff.
///
/// Respects the `Retry-After` header if present, otherwise uses exponential
/// backoff starting at 1 second with a maximum of 3 retries.
@injectable
class RetryInterceptor extends Interceptor {
  RetryInterceptor();

  static const String _retryCountKey = '_retryCount';
  static const int _maxRetries = 3;
  static const Duration _baseDelay = Duration(seconds: 1);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 429) {
      handler.next(err);
      return;
    }

    final currentRetry = err.requestOptions.extra[_retryCountKey] as int? ?? 0;
    if (currentRetry >= _maxRetries) {
      handler.next(err);
      return;
    }

    final delay = _calculateDelay(err.response, currentRetry);
    await Future<void>.delayed(delay);

    final options = err.requestOptions;
    options.extra[_retryCountKey] = currentRetry + 1;

    try {
      final response = await getIt<Dio>().fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Duration _calculateDelay(Response<dynamic>? response, int retryCount) {
    // Check Retry-After header.
    final retryAfter = response?.headers.value('retry-after');
    if (retryAfter != null) {
      final seconds = int.tryParse(retryAfter);
      if (seconds != null && seconds > 0) {
        return Duration(seconds: min(seconds, 30));
      }
    }

    // Exponential backoff: 1s, 2s, 4s...
    final delayMs = _baseDelay.inMilliseconds * pow(2, retryCount);
    return Duration(milliseconds: delayMs.toInt());
  }
}
