import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/services/language_service.dart';
import 'package:meal_meat_user/core/services/token_service.dart';

@lazySingleton
class TokenInterceptor extends QueuedInterceptor {
  static const String skipAuthKey = 'skipAuth';
  static const String _refreshRetryKey = 'refreshRetry';

  final TokenService _tokenService = getIt<TokenService>();
  final LanguageService _languageService = getIt<LanguageService>();
  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<String?>? _inFlightRefresh;

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
      handler.reject(DioException(requestOptions: options, error: e));
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final shouldSkipAuth = options.extra[skipAuthKey] == true;
    final alreadyRetried = options.extra[_refreshRetryKey] == true;

    if (!isUnauthorized || shouldSkipAuth || alreadyRetried) {
      handler.next(err);
      return;
    }

    try {
      final newAccessToken = await _refreshAccessToken();
      if (newAccessToken == null || newAccessToken.isEmpty) {
        handler.next(err);
        return;
      }

      options.extra[_refreshRetryKey] = true;
      options.headers[NetworkConstants.authorization] =
          '${NetworkConstants.bearer} $newAccessToken';

      final response = await Dio().fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (_) {
      await _tokenService.clearTokens();
      handler.next(err);
    } catch (_) {
      await _tokenService.clearTokens();
      handler.next(err);
    }
  }

  Future<String?> _refreshAccessToken() {
    _inFlightRefresh ??= _doRefreshAccessToken().whenComplete(() {
      _inFlightRefresh = null;
    });
    return _inFlightRefresh!;
  }

  Future<String?> _doRefreshAccessToken() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final response = await _refreshDio.post<Map<String, dynamic>>(
      EndPoints.refresh,
      data: <String, dynamic>{'refreshToken': refreshToken},
      options: Options(
        headers: <String, dynamic>{
          'Accept-Language': _languageService.getLanguageCode(),
        },
      ),
    );

    final tokens = _parseTokens(
      response.data,
      fallbackRefreshToken: refreshToken,
    );
    final accessToken = tokens.$1;
    final nextRefreshToken = tokens.$2;

    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    await _tokenService.saveAccessToken(accessToken);
    await _tokenService.saveRefreshToken(nextRefreshToken);

    return accessToken;
  }

  (String?, String?) _parseTokens(
    Map<String, dynamic>? data, {
    required String fallbackRefreshToken,
  }) {
    if (data == null) {
      return (null, fallbackRefreshToken);
    }

    final dynamic nestedTokens = data['tokens'];
    if (nestedTokens is Map<String, dynamic>) {
      return (
        nestedTokens['accessToken'] as String?,
        nestedTokens['refreshToken'] as String? ?? fallbackRefreshToken,
      );
    }

    return (
      data['accessToken'] as String?,
      data['refreshToken'] as String? ?? fallbackRefreshToken,
    );
  }
}
