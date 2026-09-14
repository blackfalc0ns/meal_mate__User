import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';
import 'package:meal_meat_user/core/services/language_service.dart';
import 'package:meal_meat_user/core/services/token_interceptor.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'clears the session and opens login when refresh token is missing',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final tokenService = _FakeTokenService(preferences);
      final navigatorService = _RecordingNavigatorService();
      final interceptor = TokenInterceptor(
        tokenService: tokenService,
        languageService: LanguageService(preferences),
        navigatorService: navigatorService,
      );
      final request = RequestOptions(path: '/protected');
      final error = DioException(
        requestOptions: request,
        response: Response<void>(requestOptions: request, statusCode: 401),
        type: DioExceptionType.badResponse,
      );
      final handler = ErrorInterceptorHandler();

      interceptor.onError(error, handler);
      try {
        // Dio exposes interceptor completion only through this protected future.
        // ignore: invalid_use_of_protected_member
        await handler.future;
      } catch (_) {}

      expect(tokenService.didClearTokens, isTrue);
      expect(navigatorService.lastClearedRoute, AppRoutes.login);
    },
  );
}

class _FakeTokenService extends TokenService {
  _FakeTokenService(SharedPreferences preferences)
    : super(
        prefs: const FlutterSecureStorage(),
        sharedPreferences: preferences,
      );

  bool didClearTokens = false;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<void> clearTokens() async {
    didClearTokens = true;
  }
}

class _RecordingNavigatorService extends AppNavigatorService {
  String? lastClearedRoute;

  @override
  Future<void> replaceAllWithNamedWhenReady(String routeName) async {
    lastClearedRoute = routeName;
  }
}
