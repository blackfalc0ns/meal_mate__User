import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:meal_meat_user/core/services/auth_refresh_service.dart';
import 'package:meal_meat_user/core/services/language_interceptor.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/refresh_token_usecase.dart';

import '../services/token_interceptor.dart';
import 'network_constants.dart';

@module
abstract class ExternalModules {
  @lazySingleton
  Dio provideDio(
    PrettyDioLogger prettyDioLogger,
    TokenInterceptor tokenInterceptor,
    LanguageInterceptor languageInterceptor,
  ) {
    final dio = Dio(
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

    tokenInterceptor.attachDio(dio);

    dio.interceptors.add(languageInterceptor);

    dio.interceptors.add(tokenInterceptor);

    dio.interceptors.add(prettyDioLogger);

    return dio;
  }

  @lazySingleton
  PrettyDioLogger providePrettyDioLogger() {
    return PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 120,
      enabled: kDebugMode,
      // logPrint: (object) {
      //  // final sanitized = SensitiveDataSanitizer.sanitize(object);
      //   developer.log(object, name: 'DIO');
      // },
    );
  }

  @preResolve
  Future<SharedPreferences> get provideSharedPreferences async {
    return SharedPreferences.getInstance();
  }

  @lazySingleton
  FlutterSecureStorage flutterSecureStorage() {
    return const FlutterSecureStorage();
  }

  @lazySingleton
  LocalAuthentication provideLocalAuthentication() {
    return LocalAuthentication();
  }

  @lazySingleton
  FirebaseMessaging provideFirebaseMessaging() {
    return FirebaseMessaging.instance;
  }

  @lazySingleton
  FlutterLocalNotificationsPlugin provideFlutterLocalNotificationsPlugin() {
    return FlutterLocalNotificationsPlugin();
  }

  @lazySingleton
  AuthRefreshService provideAuthRefreshService(TokenService tokenService) {
    return AuthRefreshService(
      tokenService: tokenService,
      refreshTokenUseCaseProvider: () => GetIt.instance<RefreshTokenUseCase>(),
    );
  }
}
