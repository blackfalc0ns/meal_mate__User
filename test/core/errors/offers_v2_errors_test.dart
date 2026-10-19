import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

void main() {
  Widget buildTestContextWidget({
    required Locale locale,
    required Widget Function(BuildContext context) builder,
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: builder),
    );
  }

  group('Offers and Promotions v2 Error Handling Tests', () {
    const v2Codes = [
      SubscriptionErrorCodes.notFound,
      SubscriptionErrorCodes.inactive,
      SubscriptionErrorCodes.notStarted,
      SubscriptionErrorCodes.expired,
      SubscriptionErrorCodes.usageExhausted,
      SubscriptionErrorCodes.ineligible,
      SubscriptionErrorCodes.selfReferral,
      SubscriptionErrorCodes.alreadyAttributed,
      SubscriptionErrorCodes.checkoutCouponFullDiscountUnsupported,
      SubscriptionErrorCodes.checkoutCapacityUnavailable,
      SubscriptionErrorCodes.offersCustomerUnavailable,
    ];

    test('ApiExceptionMapper extracts code from {code, message, errors} format', () {
      for (final code in v2Codes) {
        final response = Response<dynamic>(
          requestOptions: RequestOptions(path: '/api/v1/customer/offers/validate-discount'),
          statusCode: 400,
          data: {
            'code': code,
            'message': 'Technical backend message: $code',
            'errors': ['Sample error detail'],
          },
        );

        final exception = ApiExceptionMapper.fromResponse(response);
        expect(exception.statusCode, equals(400));
        expect(exception.backendErrorCode, equals(code));

        final failure = Failure.fromException(exception);
        expect(failure.code, equals(code));
      }
    });

    test('HTTP 404 retains code in ApiException and Failure', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/api/v1/customer/offers/999'),
        statusCode: 404,
        data: {
          'code': SubscriptionErrorCodes.notFound,
          'message': 'Offer was not found',
        },
      );

      final exception = ApiExceptionMapper.fromResponse(response);
      expect(exception.statusCode, equals(404));
      expect(exception.errorType, equals(ApiErrorType.notFound));
      expect(exception.backendErrorCode, equals(SubscriptionErrorCodes.notFound));

      final failure = Failure.fromException(exception);
      expect(failure.code, equals(SubscriptionErrorCodes.notFound));
    });

    testWidgets('ErrorMessagePresenter presents localized Arabic message without raw code', (tester) async {
      for (final code in v2Codes) {
        final response = Response<dynamic>(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'code': code, 'message': code},
        );

        final exception = ApiExceptionMapper.fromResponse(response);
        final failure = Failure.fromException(exception);

        String? displayedMessage;
        await tester.pumpWidget(
          buildTestContextWidget(
            locale: const Locale('ar'),
            builder: (context) {
              displayedMessage = ErrorMessagePresenter.fromFailure(context, failure);
              return const SizedBox();
            },
          ),
        );

        expect(displayedMessage, isNotNull);
        expect(displayedMessage, isNotEmpty);
        // Ensure raw technical code is NOT displayed
        expect(displayedMessage, isNot(equals(code)));
        expect(displayedMessage!.contains('checkout.'), isFalse);
        expect(displayedMessage!.contains('offers.'), isFalse);
      }
    });

    testWidgets('ErrorMessagePresenter presents localized English message without raw code', (tester) async {
      for (final code in v2Codes) {
        final response = Response<dynamic>(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'code': code, 'message': code},
        );

        final exception = ApiExceptionMapper.fromResponse(response);
        final failure = Failure.fromException(exception);

        String? displayedMessage;
        await tester.pumpWidget(
          buildTestContextWidget(
            locale: const Locale('en'),
            builder: (context) {
              displayedMessage = ErrorMessagePresenter.fromFailure(context, failure);
              return const SizedBox();
            },
          ),
        );

        expect(displayedMessage, isNotNull);
        expect(displayedMessage, isNotEmpty);
        // Ensure raw technical code is NOT displayed
        expect(displayedMessage, isNot(equals(code)));
        expect(displayedMessage!.contains('checkout.'), isFalse);
        expect(displayedMessage!.contains('offers.'), isFalse);
      }
    });

    testWidgets('Prefers backend messageAr when present in Arabic locale', (tester) async {
      const customAr = 'هذا العرض غير متاح لحسابك حالياً';
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 400,
        data: {
          'code': SubscriptionErrorCodes.ineligible,
          'message': 'Customer not eligible',
          'messageAr': customAr,
          'messageEn': 'Customer not eligible for this offer',
        },
      );

      final exception = ApiExceptionMapper.fromResponse(response);
      final failure = Failure.fromException(exception);

      String? displayedMessage;
      await tester.pumpWidget(
        buildTestContextWidget(
          locale: const Locale('ar'),
          builder: (context) {
            displayedMessage = ErrorMessagePresenter.fromFailure(context, failure);
            return const SizedBox();
          },
        ),
      );

      expect(displayedMessage, equals(customAr));
    });

    testWidgets('Prefers backend messageEn when present in English locale', (tester) async {
      const customEn = 'Customer is not eligible for this promotional campaign';
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 400,
        data: {
          'code': SubscriptionErrorCodes.ineligible,
          'message': 'Customer not eligible',
          'messageAr': 'هذا العرض غير متاح لحسابك حالياً',
          'messageEn': customEn,
        },
      );

      final exception = ApiExceptionMapper.fromResponse(response);
      final failure = Failure.fromException(exception);

      String? displayedMessage;
      await tester.pumpWidget(
        buildTestContextWidget(
          locale: const Locale('en'),
          builder: (context) {
            displayedMessage = ErrorMessagePresenter.fromFailure(context, failure);
            return const SizedBox();
          },
        ),
      );

      expect(displayedMessage, equals(customEn));
    });
  });
}
