import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

void main() {
  for (final language in ['ar', 'en']) {
    testWidgets('invalid login credentials are localized in $language', (
      tester,
    ) async {
      final failure = Failure.fromException(
        ApiExceptionMapper.fromResponse(
          Response<dynamic>(
            requestOptions: RequestOptions(path: '/auth/customers/login'),
            statusCode: 401,
            data: {
              'title': 'Authentication required',
              'status': 401,
              'detail': 'رقم الهاتف أو كلمة المرور غير صحيحة.',
              'code': 'auth.invalid_credentials',
            },
          ),
        ),
      );
      String? actual;
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              actual = ErrorMessagePresenter.fromFailure(context, failure);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(
        actual,
        language == 'ar'
            ? 'رقم الهاتف أو كلمة المرور غير صحيحة.'
            : 'The phone number or password is incorrect.',
      );
    });
  }

  testWidgets('unmapped backend code preserves a readable detail', (
    tester,
  ) async {
    final failure = Failure.fromException(
      ApiExceptionMapper.fromResponse(
        Response<dynamic>(
          requestOptions: RequestOptions(path: '/auth/customers/login'),
          statusCode: 401,
          data: {
            'detail': 'Please check your login details.',
            'code': 'auth.future_login_error',
          },
        ),
      ),
    );
    String? actual;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            actual = ErrorMessagePresenter.fromFailure(context, failure);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(actual, 'Please check your login details.');
  });
  testWidgets('unmapped technical detail falls back to localized status', (
    tester,
  ) async {
    final failure = Failure.fromException(
      ApiExceptionMapper.fromResponse(
        Response<dynamic>(
          requestOptions: RequestOptions(path: '/auth/customers/login'),
          statusCode: 401,
          data: {
            'detail': 'SQL exception in /srv/auth',
            'code': 'auth.future_login_error',
          },
        ),
      ),
    );
    String? actual;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            actual = ErrorMessagePresenter.fromFailure(context, failure);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(actual, "Unauthorized");
  });
}
