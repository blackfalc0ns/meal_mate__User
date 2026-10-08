import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_meat_user/core/services/language_interceptor.dart';

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
      logPrint: (object) {
        final text = object.toString();
        final sanitized = text
            .replaceAll(
              RegExp(r'"password"\s*:\s*"[^"]*"'),
              '"password": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'"newPassword"\s*:\s*"[^"]*"'),
              '"newPassword": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'"currentPassword"\s*:\s*"[^"]*"'),
              '"currentPassword": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'"otp"\s*:\s*"[^"]*"'),
              '"otp": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'"code"\s*:\s*"[^"]*"'),
              '"code": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'"accessToken"\s*:\s*"[^"]*"'),
              '"accessToken": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'"refreshToken"\s*:\s*"[^"]*"'),
              '"refreshToken": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'"paymentUrl"\s*:\s*"[^"]*"'),
              '"paymentUrl": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'"cvv"\s*:\s*"[^"]*"', caseSensitive: false),
              '"cvv": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'"cardNumber"\s*:\s*"[^"]*"', caseSensitive: false),
              '"cardNumber": "[REDACTED]"',
            )
            .replaceAll(
              RegExp(r'Bearer\s+[A-Za-z0-9\-_.=]+'),
              'Bearer [REDACTED]',
            );
        developer.log(sanitized, name: 'DIO');
      },
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
}
