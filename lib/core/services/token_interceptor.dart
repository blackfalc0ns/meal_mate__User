import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';
import 'package:meal_meat_user/core/services/auth_refresh_service.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_view_model.dart';

typedef AuthRefreshServiceProvider = AuthRefreshService Function();

@lazySingleton
class TokenInterceptor extends QueuedInterceptor {
  TokenInterceptor({
    required this._tokenService,
    required this._navigatorService,
  }) : _authRefreshServiceProvider = null;

  TokenInterceptor.withDependencies({
    required this._tokenService,
    required this._navigatorService,
    this._authRefreshServiceProvider,
    this._dio,
  });

  static const String skipAuthKey = 'skipAuth';
  static const String noAutoRetryKey = 'noAutoRetry';
  static const String _refreshRetryKey = 'refreshRetry';

  final TokenService _tokenService;
  final AppNavigatorService _navigatorService;
  AuthRefreshServiceProvider? _authRefreshServiceProvider;
  Dio? _dio;
  bool _sessionExpired = false;

  void attachDio(Dio dio) {
    _dio = dio;
  }

  void attachAuthRefreshServiceProvider(
    AuthRefreshServiceProvider authRefreshServiceProvider,
  ) {
    _authRefreshServiceProvider = authRefreshServiceProvider;
  }

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
        _sessionExpired = false;
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
    final isCheckout = options.path.contains('/subscriptions/checkout') ||
        options.extra[noAutoRetryKey] == true;

    if (!isUnauthorized || shouldSkipAuth) {
      handler.next(err);
      return;
    }

    if (isCheckout) {
      // Re-authenticate session in background, but NEVER auto-replay a checkout POST
      _refreshAccessToken();
      handler.next(err);
      return;
    }

    if (alreadyRetried) {
      await _expireSession();
      handler.next(err);
      return;
    }

    try {
      final newAccessToken = await _refreshAccessToken();
      if (newAccessToken == null || newAccessToken.isEmpty) {
        await _expireSession();
        handler.next(err);
        return;
      }

      options.extra[_refreshRetryKey] = true;
      options.headers[NetworkConstants.authorization] =
          '${NetworkConstants.bearer} $newAccessToken';

      final client = _dio ?? Dio();
      final response = await client.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    } catch (_) {
      handler.next(err);
    }
  }

  Future<void> _expireSession() async {
    if (_sessionExpired) return;
    _sessionExpired = true;
    if (getIt.isRegistered<NotificationBadgeViewModel>()) {
      getIt<NotificationBadgeViewModel>().resetForAccountChange();
    }
    await _tokenService.clearSession();
    await _navigatorService.replaceAllWithNamedWhenReady(AppRoutes.login);
  }

  Future<String?> _refreshAccessToken() async {
    final provider =
        _authRefreshServiceProvider ??
        (getIt.isRegistered<AuthRefreshService>()
            ? getIt.call<AuthRefreshService>
            : null);

    if (provider == null) {
      final fallbackRefreshToken = await _tokenService.getRefreshToken();
      if (fallbackRefreshToken == null || fallbackRefreshToken.isEmpty) {
        return null;
      }
      return null;
    }

    final refreshService = provider();
    final result = await refreshService.refreshSession();
    if (result is ApiSuccessResult<RefreshTokenEntity>) {
      return result.data.accessToken;
    }
    return null;
  }
}
