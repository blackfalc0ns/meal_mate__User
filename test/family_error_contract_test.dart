import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

void main() {
  group('Family Error Contract & ProblemDetails Mapping', () {
    test('parses ProblemDetails with code and currentVersion', () {
      final json = {
        'status': 409,
        'code': 'family.delivery_version_changed',
        'currentVersion': 3,
        'title': 'Delivery version conflict',
        'detail': 'Internal DB conflict',
        'instance': '/api/v1/customer/family-subscription-flow/delivery-address',
      };

      final exception = ApiException(
        errorType: ApiErrorType.conflict,
        message: 'Delivery version conflict',
        statusCode: 409,
        response: json,
        backendErrorCode: 'family.delivery_version_changed',
      );

      expect(exception.backendErrorCode, SubscriptionErrorCodes.familyDeliveryVersionChanged);
      expect(exception.currentVersion, 3);
      expect(exception.instance, '/api/v1/customer/family-subscription-flow/delivery-address');
    });

    test('parses legacy error with amount and currency', () {
      final json = {
        'error': 'auto_renewal.price_changed',
        'amount': 45.0,
        'currency': 'KWD',
      };

      final exception = ApiException(
        errorType: ApiErrorType.badRequest,
        message: 'auto_renewal.price_changed',
        statusCode: 400,
        response: json,
        backendErrorCode: 'auto_renewal.price_changed',
      );

      expect(exception.backendErrorCode, SubscriptionErrorCodes.autoRenewalPriceChanged);
      expect(exception.amount, 45.0);
      expect(exception.currency, 'KWD');
    });

    testWidgets('presents documented family error codes in English locale', (tester) async {
      late BuildContext buildContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              buildContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final codes = <String>[
        SubscriptionErrorCodes.familyPermissionsChanged,
        SubscriptionErrorCodes.familyDeliveryVersionChanged,
        SubscriptionErrorCodes.familyQuoteChanged,
        SubscriptionErrorCodes.familyIdempotencyKeyUsed,
        SubscriptionErrorCodes.familyClientUpdateRequired,
        SubscriptionErrorCodes.familyInvoiceCreationStopped,
        SubscriptionErrorCodes.familyMemberAccountRequired,
        SubscriptionErrorCodes.familyPaymentMethodUnavailable,
        SubscriptionErrorCodes.familyPaymentCurrencyUnsupported,
        SubscriptionErrorCodes.familyProviderRefundRequired,
        SubscriptionErrorCodes.familyDeliverySnapshotReviewRequired,
        SubscriptionErrorCodes.familyActionNotAvailable,
        SubscriptionErrorCodes.paymentInitializationFailed,
      ];

      for (final code in codes) {
        final exception = ApiException(
          errorType: ApiErrorType.badRequest,
          message: code,
          backendErrorCode: code,
        );
        final message = ErrorMessagePresenter.userFacingMessage(buildContext, exception);
        expect(message, isNotEmpty);
        expect(message, isNot(contains(code)), reason: 'Code $code must be localized');
      }

      // Test auto renewal price changed with parameters
      final autoRenewalException = ApiException(
        errorType: ApiErrorType.badRequest,
        message: 'auto_renewal.price_changed',
        backendErrorCode: 'auto_renewal.price_changed',
        response: {'amount': 30, 'currency': 'KWD'},
      );
      final priceMessage = ErrorMessagePresenter.userFacingMessage(buildContext, autoRenewalException);
      expect(priceMessage, contains('30'));
      expect(priceMessage, contains('KWD'));

      // Test 403 safe presentation
      final forbiddenException = ApiException(
        errorType: ApiErrorType.forbidden,
        message: 'SQL database access denied on row 42',
        statusCode: 403,
      );
      final forbiddenMessage = ErrorMessagePresenter.userFacingMessage(buildContext, forbiddenException);
      expect(forbiddenMessage, isNot(contains('SQL')));
      expect(forbiddenMessage, isNotEmpty);

      // Test invoice 404 safe presentation
      final invoice404Exception = ApiException(
        errorType: ApiErrorType.notFound,
        message: 'Invoice GUID not found in system table',
        statusCode: 404,
        response: {'instance': '/api/v1/customer/invoices/123-abc'},
      );
      final invoice404Message = ErrorMessagePresenter.userFacingMessage(buildContext, invoice404Exception);
      expect(invoice404Message, isNot(contains('system table')));
      expect(invoice404Message, isNotEmpty);
    });

    testWidgets('presents documented family error codes in Arabic locale', (tester) async {
      late BuildContext buildContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Builder(
            builder: (context) {
              buildContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final codes = <String>[
        SubscriptionErrorCodes.familyPermissionsChanged,
        SubscriptionErrorCodes.familyDeliveryVersionChanged,
        SubscriptionErrorCodes.familyQuoteChanged,
        SubscriptionErrorCodes.familyIdempotencyKeyUsed,
        SubscriptionErrorCodes.familyClientUpdateRequired,
        SubscriptionErrorCodes.familyInvoiceCreationStopped,
        SubscriptionErrorCodes.familyMemberAccountRequired,
        SubscriptionErrorCodes.familyPaymentMethodUnavailable,
        SubscriptionErrorCodes.familyPaymentCurrencyUnsupported,
        SubscriptionErrorCodes.familyProviderRefundRequired,
        SubscriptionErrorCodes.familyDeliverySnapshotReviewRequired,
        SubscriptionErrorCodes.familyActionNotAvailable,
        SubscriptionErrorCodes.paymentInitializationFailed,
      ];

      for (final code in codes) {
        final exception = ApiException(
          errorType: ApiErrorType.badRequest,
          message: code,
          backendErrorCode: code,
        );
        final message = ErrorMessagePresenter.userFacingMessage(buildContext, exception);
        expect(message, isNotEmpty);
        expect(message, isNot(contains(code)), reason: 'Code $code must be localized in Arabic');
      }

      // Test auto renewal price changed with parameters in Arabic
      final autoRenewalException = ApiException(
        errorType: ApiErrorType.badRequest,
        message: 'auto_renewal.price_changed',
        backendErrorCode: 'auto_renewal.price_changed',
        response: {'amount': 30, 'currency': 'KWD'},
      );
      final priceMessage = ErrorMessagePresenter.userFacingMessage(buildContext, autoRenewalException);
      expect(priceMessage, contains('30'));
      expect(priceMessage, contains('KWD'));
    });
  });
}
