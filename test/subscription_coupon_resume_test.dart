import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/errors/failure_mapper.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_billing_action_request_dto.dart';

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

  group('Subscription Coupon Resume Tests', () {
    test(
      'SubscriptionBillingResumeRequestDto JSON never includes promoCode',
      () {
        const dto = SubscriptionBillingResumeRequestDto(
          startDate: '2026-10-15',
          paymentMethodId: 1,
        );

        final json = dto.toJson();
        expect(json.containsKey('promoCode'), isFalse);
        expect(json['startDate'], equals('2026-10-15'));
        expect(json['paymentMethodId'], equals(1));
      },
    );

    testWidgets(
      'resume 400 coupon_no_longer_valid maps to localized message in Arabic',
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
          requestOptions: RequestOptions(
            path: '/customer/subscriptions/sub-123/resume',
          ),
          statusCode: 400,
          data: const {
            'error': 'checkout.coupon_no_longer_valid',
            'message': 'Coupon expired',
          },
        );

        final exception = ApiExceptionMapper.fromResponse(response);
        expect(
          exception.backendErrorCode,
          equals(SubscriptionErrorCodes.couponNoLongerValid),
        );
        expect(exception.errorType, equals(ApiErrorType.badRequest));

        final failure = ServerFailure(
          code: exception.backendErrorCode ?? '',
          errorMessage: exception.message,
          exception: exception,
        );

        final message = mapFailureMessage(testContext, failure.code);
        expect(message, equals('انتهت صلاحية كود الخصم'));
      },
    );

    testWidgets(
      'resume 400 coupon_no_longer_valid maps to localized message in English',
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
          requestOptions: RequestOptions(
            path: '/customer/subscriptions/sub-123/resume',
          ),
          statusCode: 400,
          data: const {
            'error': 'checkout.coupon_no_longer_valid',
            'message': 'Coupon expired',
          },
        );

        final exception = ApiExceptionMapper.fromResponse(response);
        final failure = ServerFailure(
          code: exception.backendErrorCode ?? '',
          errorMessage: exception.message,
          exception: exception,
        );

        final message = mapFailureMessage(testContext, failure.code);
        expect(message, equals('This coupon code has expired'));
      },
    );
  });
}
