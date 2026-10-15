import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/errors/failure_mapper.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_coupon_mapper.dart';

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

  group('Subscription Coupon Error Handling Tests', () {
    test(
      'ApiExceptionMapper.fromResponse preserves backendErrorCode and nested coupon payload',
      () {
        final response = Response<dynamic>(
          requestOptions: RequestOptions(
            path: '/customer/subscriptions/checkout',
          ),
          statusCode: 400,
          data: const {
            'error': 'checkout.coupon_rejected',
            'coupon': {
              'code': 'EXPIRED10',
              'status': 'expired',
              'offerId': null,
              'discountAmount': 0,
              'messageAr': 'انتهت صلاحية كود الخصم',
              'messageEn': 'This coupon code has expired',
            },
          },
        );

        final exception = ApiExceptionMapper.fromResponse(response);

        expect(exception.statusCode, equals(400));
        expect(exception.errorType, equals(ApiErrorType.badRequest));
        expect(
          exception.backendErrorCode,
          equals(SubscriptionErrorCodes.couponRejected),
        );
        expect(exception.response, isA<Map>());
        expect(
          (exception.response as Map)['coupon']['status'],
          equals('expired'),
        );

        final failure = ServerFailure(
          code: exception.backendErrorCode ?? 'error',
          errorMessage: exception.message,
          exception: exception,
        );
        final extractedCoupon = failure.extractCoupon();
        expect(extractedCoupon, isNotNull);
        expect(extractedCoupon!.code, equals('EXPIRED10'));
        expect(extractedCoupon.status.name, equals('expired'));
      },
    );

    testWidgets(
      'ErrorMessagePresenter presents Arabic message when in Arabic locale',
      (tester) async {
        late BuildContext testContext;

        await tester.pumpWidget(
          buildTestContextWidget(
            locale: const Locale('ar'),
            builder: (context) {
              testContext = context;
              return const SizedBox.shrink();
            },
          ),
        );

        final response = Response<dynamic>(
          requestOptions: RequestOptions(path: '/checkout'),
          statusCode: 400,
          data: const {
            'error': 'checkout.coupon_rejected',
            'coupon': {
              'code': 'EXPIRED10',
              'status': 'expired',
              'messageAr': 'انتهت صلاحية كود الخصم',
              'messageEn': 'This coupon code has expired',
            },
          },
        );
        final exception = ApiExceptionMapper.fromResponse(response);
        final failure = ServerFailure(
          code: exception.backendErrorCode ?? '',
          errorMessage: exception.message,
          exception: exception,
        );

        final message = ErrorMessagePresenter.fromFailure(testContext, failure);
        expect(message, equals('انتهت صلاحية كود الخصم'));
      },
    );

    testWidgets(
      'ErrorMessagePresenter presents English message when in English locale',
      (tester) async {
        late BuildContext testContext;

        await tester.pumpWidget(
          buildTestContextWidget(
            locale: const Locale('en'),
            builder: (context) {
              testContext = context;
              return const SizedBox.shrink();
            },
          ),
        );

        final response = Response<dynamic>(
          requestOptions: RequestOptions(path: '/checkout'),
          statusCode: 400,
          data: const {
            'error': 'checkout.coupon_rejected',
            'coupon': {
              'code': 'EXPIRED10',
              'status': 'expired',
              'messageAr': 'انتهت صلاحية كود الخصم',
              'messageEn': 'This coupon code has expired',
            },
          },
        );
        final exception = ApiExceptionMapper.fromResponse(response);
        final failure = ServerFailure(
          code: exception.backendErrorCode ?? '',
          errorMessage: exception.message,
          exception: exception,
        );

        final message = ErrorMessagePresenter.fromFailure(testContext, failure);
        expect(message, equals('This coupon code has expired'));
      },
    );

    testWidgets(
      'ErrorMessagePresenter discards HTML or technical error and falls back to localized status',
      (tester) async {
        late BuildContext testContext;

        await tester.pumpWidget(
          buildTestContextWidget(
            locale: const Locale('ar'),
            builder: (context) {
              testContext = context;
              return const SizedBox.shrink();
            },
          ),
        );

        final response = Response<dynamic>(
          requestOptions: RequestOptions(path: '/checkout'),
          statusCode: 400,
          data: const {
            'error': 'checkout.coupon_rejected',
            'coupon': {
              'code': 'TEST',
              'status': 'expired',
              'messageAr': '<html><body>SQL Exception in line 44</body></html>',
              'messageEn': '<html><body>SQL Exception in line 44</body></html>',
            },
          },
        );
        final exception = ApiExceptionMapper.fromResponse(response);
        final failure = ServerFailure(
          code: exception.backendErrorCode ?? '',
          errorMessage: exception.message,
          exception: exception,
        );

        final message = ErrorMessagePresenter.fromFailure(testContext, failure);
        expect(message, isNot(contains('<html>')));
        expect(message, equals('انتهت صلاحية كود الخصم'));
      },
    );

    testWidgets(
      'handles null coupon and unknown status safely without exposing raw backend error string',
      (tester) async {
        late BuildContext testContext;

        await tester.pumpWidget(
          buildTestContextWidget(
            locale: const Locale('ar'),
            builder: (context) {
              testContext = context;
              return const SizedBox.shrink();
            },
          ),
        );

        // Without coupon payload
        final responseWithoutCoupon = Response<dynamic>(
          requestOptions: RequestOptions(path: '/checkout'),
          statusCode: 400,
          data: const {'error': 'checkout.coupon_rejected'},
        );
        final ex1 = ApiExceptionMapper.fromResponse(responseWithoutCoupon);
        final f1 = ServerFailure(
          code: ex1.backendErrorCode ?? '',
          errorMessage: ex1.message,
          exception: ex1,
        );

        final message1 = ErrorMessagePresenter.fromFailure(testContext, f1);
        expect(message1, equals('تم رفض كود الخصم'));
        expect(message1, isNot(equals('checkout.coupon_rejected')));

        // With full discount unsupported
        final responseZeroAmount = Response<dynamic>(
          requestOptions: RequestOptions(path: '/checkout'),
          statusCode: 400,
          data: const {'error': 'checkout.coupon_full_discount_unsupported'},
        );
        final ex2 = ApiExceptionMapper.fromResponse(responseZeroAmount);
        final f2 = ServerFailure(
          code: ex2.backendErrorCode ?? '',
          errorMessage: ex2.message,
          exception: ex2,
        );

        final message2 = ErrorMessagePresenter.fromFailure(testContext, f2);
        expect(
          message2,
          equals(
            'الدفع بمبلغ صفري غير مدعوم حاليًا. أزل الكود أو استخدم كودًا آخر.',
          ),
        );
      },
    );

    testWidgets('all coupon status codes are mapped in mapFailureMessage', (
      tester,
    ) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        buildTestContextWidget(
          locale: const Locale('en'),
          builder: (context) {
            testContext = context;
            return const SizedBox.shrink();
          },
        ),
      );

      expect(
        mapFailureMessage(testContext, 'checkout.coupon_rejected'),
        equals('Coupon code was rejected'),
      );
      expect(
        mapFailureMessage(testContext, 'checkout.coupon_no_longer_valid'),
        equals('This coupon code has expired'),
      );
      expect(
        mapFailureMessage(
          testContext,
          'checkout.coupon_full_discount_unsupported',
        ),
        equals(
          'Zero-amount checkout is currently unsupported. Remove this code or use another code.',
        ),
      );
      expect(
        mapFailureMessage(testContext, 'valid'),
        equals('Coupon applied successfully'),
      );
      expect(
        mapFailureMessage(testContext, 'not_found'),
        equals('This coupon code does not exist'),
      );
      expect(
        mapFailureMessage(testContext, 'inactive'),
        equals('This coupon code is not active'),
      );
      expect(
        mapFailureMessage(testContext, 'not_started'),
        equals('This coupon code is not valid yet'),
      );
      expect(
        mapFailureMessage(testContext, 'expired'),
        equals('This coupon code has expired'),
      );
      expect(
        mapFailureMessage(testContext, 'usage_exhausted'),
        equals('This coupon code has reached its usage limit'),
      );
      expect(
        mapFailureMessage(testContext, 'stacking_conflict'),
        equals('This coupon code cannot be combined with the current offer'),
      );
      expect(
        mapFailureMessage(testContext, 'ineligible'),
        equals('This coupon code is not eligible for this subscription'),
      );
    });
  });
}
