import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/services/token_service.dart';

@lazySingleton
class TokenInterceptor extends QueuedInterceptor {
  static const String skipAuthKey = 'skipAuth';

  final TokenService _tokenService = getIt<TokenService>();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (options.extra[skipAuthKey] == true) {
        options.headers.remove(NetworkConstants.authorization);
        handler.next(options);
        return;
      }

      final token = await _tokenService.getToken();

      if (token != null && token.isNotEmpty) {
        options.headers[NetworkConstants.authorization] =
            '${NetworkConstants.bearer} $token';
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
        ),
      );
    }
  }
}