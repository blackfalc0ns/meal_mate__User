import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_advice.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

void main() {
  group('Family & Contract v3.1 Error Tests', () {
    test('extracts field, bilingual messages, and structured advice correctly', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/api/v1/customer/family-subscription-flow/checkout'),
        statusCode: 409,
        data: const {
          'error': 'family.permissions_changed',
          'field': 'permissionsVersion',
          'messageAr': 'تم تغيير الصلاحيات في العائلة',
          'messageEn': 'Family permissions have changed',
          'missingStep': 'PERMISSIONS',
          'actionEndpoint': '/api/v1/customer/family-subscription-flow/members/123/permissions',
          'advice': {
            'retryable': true,
            'refreshSummaryRequired': true,
            'refreshAvailabilityRequired': false,
            'customKey': 'preservedValue',
          },
        },
      );

      final exception = ApiExceptionMapper.fromResponse(response);
      final failure = ServerFailure.fromResponse(response);

      expect(exception.backendErrorCode, 'family.permissions_changed');
      expect(exception.field, 'permissionsVersion');
      expect(exception.messageAr, 'تم تغيير الصلاحيات في العائلة');
      expect(exception.messageEn, 'Family permissions have changed');
      expect(exception.missingStep, 'PERMISSIONS');
      expect(exception.actionEndpoint, contains('permissions'));
      expect(exception.advice.retryable, isTrue);
      expect(exception.advice.refreshSummaryRequired, isTrue);
      expect(exception.advice.refreshAvailabilityRequired, isFalse);
      expect(exception.advice.additionalData['customKey'], 'preservedValue');

      expect(failure.code, 'family.permissions_changed');
      expect(failure.field, 'permissionsVersion');
      expect(failure.messageAr, 'تم تغيير الصلاحيات في العائلة');
      expect(failure.messageEn, 'Family permissions have changed');
      expect(failure.advice, exception.advice);
      expect(failure.missingStep, 'PERMISSIONS');
    });

    test('defaults advice for 410 Gone / hold expired to retryable and refresh required', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/api/v1/customer/subscriptions/checkout'),
        statusCode: 410,
        data: const {
          'error': 'checkout.capacity_hold_expired',
          'message': 'The reservation hold has expired.',
        },
      );

      final exception = ApiExceptionMapper.fromResponse(response);

      expect(exception.backendErrorCode, 'checkout.capacity_hold_expired');
      expect(exception.advice.retryable, isTrue);
      expect(exception.advice.refreshSummaryRequired, isTrue);
      expect(exception.advice.refreshAvailabilityRequired, isTrue);
    });

    test('defaults advice for 502 Bad Gateway to retryable without fake methods', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/api/v1/customer/family-subscription-flow/checkout'),
        statusCode: 502,
        data: const {
          'error': 'payment.initialization_failed',
          'message': 'Gateway timeout connecting to payment provider',
        },
      );

      final exception = ApiExceptionMapper.fromResponse(response);

      expect(exception.advice.retryable, isTrue);
      expect(exception.advice.refreshSummaryRequired, isFalse);
    });

    test('defaults advice for coupon rejections to refreshSummaryRequired', () {
      for (final code in [
        'family.coupon_rejected',
        'checkout.coupon_rejected',
        'family.coupon_context_unavailable',
        'checkout.coupon_no_longer_valid',
      ]) {
        final advice = ApiErrorAdvice.fromData(null, statusCode: 400, code: code);
        expect(advice.refreshSummaryRequired, isTrue, reason: '$code should require summary refresh');
      }
    });

    test('defaults advice for availability errors to refreshAvailabilityRequired', () {
      for (final code in [
        'no_restaurants_for_address',
        'no_restaurants_for_selection',
        'subscription_flow.no_restaurants_for_selection',
        'subscription_flow.friday_unavailable',
      ]) {
        final advice = ApiErrorAdvice.fromData(null, statusCode: 400, code: code);
        expect(
          advice.refreshAvailabilityRequired,
          isTrue,
          reason: '$code should require availability refresh',
        );
      }
    });

    test('handles unknown codes and missing advice gracefully', () {
      final advice = ApiErrorAdvice.fromData(null, statusCode: 200, code: 'unrecognized_custom_code');
      expect(advice.retryable, isFalse);
      expect(advice.refreshSummaryRequired, isFalse);
      expect(advice.refreshAvailabilityRequired, isFalse);
      expect(advice.additionalData, isEmpty);
    });

    testWidgets('presents server bilingual message according to active locale', (
      tester,
    ) async {
      final failure = Failure(
        errorMessage: 'Default error message',
        code: 'family.coupon_rejected',
        messageAr: 'كوبون العائلة غير صالح',
        messageEn: 'Family coupon is invalid',
      );

      Widget buildApp(Locale locale, void Function(BuildContext) onBuilt) {
        return MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (ctx) {
              onBuilt(ctx);
              return const SizedBox.shrink();
            },
          ),
        );
      }

      // Test English
      late BuildContext enContext;
      await tester.pumpWidget(buildApp(const Locale('en'), (ctx) => enContext = ctx));
      expect(ErrorMessagePresenter.fromFailure(enContext, failure), 'Family coupon is invalid');

      // Test Arabic
      late BuildContext arContext;
      await tester.pumpWidget(buildApp(const Locale('ar'), (ctx) => arContext = ctx));
      expect(ErrorMessagePresenter.fromFailure(arContext, failure), 'كوبون العائلة غير صالح');

      // Stable code must be preserved untouched
      expect(failure.code, 'family.coupon_rejected');
    });

    testWidgets('maps preserved backend contract codes to localized strings when server messages absent', (
      tester,
    ) async {
      late BuildContext enContext;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (ctx) {
              enContext = ctx;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        ErrorMessagePresenter.mapCode(enContext, SubscriptionErrorCodes.capacityHoldExpired),
        enContext.localization.billing_uncompleted_hold_expired,
      );
      expect(
        ErrorMessagePresenter.mapCode(enContext, SubscriptionErrorCodes.familyCouponRejected),
        enContext.localization.coupon_error_rejected,
      );
      expect(
        ErrorMessagePresenter.mapCode(enContext, SubscriptionErrorCodes.familyCouponContextUnavailable),
        enContext.localization.coupon_error_no_longer_valid,
      );
      expect(
        ErrorMessagePresenter.mapCode(enContext, SubscriptionErrorCodes.familyAddressRequired),
        enContext.localization.checkout_address_required,
      );
      expect(
        ErrorMessagePresenter.mapCode(enContext, SubscriptionErrorCodes.allergiesRequiredBare),
        enContext.localization.checkout_allergies_required,
      );
      expect(
        ErrorMessagePresenter.mapCode(enContext, SubscriptionErrorCodes.dietaryPreferencesRequiredBare),
        enContext.localization.checkout_dietary_preferences_required,
      );
    });
  });
}
