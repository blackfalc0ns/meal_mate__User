import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/errors/failure_mapper.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/features/family_addresses/data/models/request/family_delivery_address_request_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/models/response/family_delivery_address_response_dto.dart';
import 'package:meal_meat_user/features/family_addresses/domain/entities/family_delivery_address_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_auto_renewal_consent_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_auto_renewal_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_auto_renewal_mapper.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    locale: locale,
    home: Scaffold(body: child),
  );
}

void main() {
  group('Task 9: Subscription, Address, Finance, and Account Routes Alignment Tests', () {
    test('Delivery address update payload sends addressId, effectiveFromDate, expectedVersion and preserves committed snapshots', () {
      const requestEntity = FamilyDeliveryAddressRequestEntity(
        addressId: 'addr-uuid-456',
        effectiveFromDate: '2026-10-20',
        expectedVersion: 3,
      );

      final dto = FamilyDeliveryAddressRequestDto(
        addressId: requestEntity.addressId,
        effectiveFromDate: requestEntity.effectiveFromDate,
        expectedVersion: requestEntity.expectedVersion,
      );

      final json = dto.toJson();
      expect(json['addressId'], equals('addr-uuid-456'));
      expect(json['effectiveFromDate'], equals('2026-10-20'));
      expect(json['expectedVersion'], equals(3));

      // Result includes affectedDayIds and skippedDayIds for immutable committed day protection
      const resultDto = FamilyDeliveryAddressResultResponseDto(
        subscriptionId: 'sub-789',
        version: 4,
        amendmentId: 'amend-1',
        effectiveFromDate: '2026-10-20',
        affectedDayIds: ['day-1', 'day-2'],
        skippedDayIds: ['day-0-locked'],
      );

      final resultEntity = FamilyDeliveryAddressResultEntity(
        subscriptionId: resultDto.subscriptionId!,
        version: resultDto.version!,
        amendmentId: resultDto.amendmentId!,
        effectiveFromDate: resultDto.effectiveFromDate!,
        affectedDayIds: resultDto.affectedDayIds!,
        skippedDayIds: resultDto.skippedDayIds!,
      );

      expect(resultEntity.isDayAffected('day-1'), isTrue);
      expect(resultEntity.isDayAffected('day-2'), isTrue);
      expect(resultEntity.isDaySkipped('day-0-locked'), isTrue);
      expect(resultEntity.isDayAffected('day-0-locked'), isFalse);
    });

    test('Auto-renew consent is separate from billing connection, preserving truthful billingStatus: NotConnected', () {
      // 1. Initial GET before consent
      final getDto = SubscriptionAutoRenewalDto.fromJson({
        'subscriptionId': 'sub-auto-1',
        'consentActive': false,
        'consentVersion': null,
        'consentAmount': null,
        'currency': null,
        'consentActorUserId': null,
        'withdrawnByUserId': null,
        'consentedAtUtc': null,
        'withdrawnAtUtc': null,
        'billingStatus': 'NotConnected',
        'requiresPaymentSetup': false,
        'autoChargeEnabled': false,
      });

      final getEntity = getDto.toEntity();
      expect(getEntity.consentActive, isFalse);
      expect(getEntity.billingStatus, equals('NotConnected'));
      expect(getEntity.autoChargeEnabled, isFalse);
      expect(getEntity.requiresPaymentSetup, isFalse);

      // 2. PUT Consent Request payload matches 3-decimal amount and currency
      const consentRequest = SubscriptionAutoRenewalConsentRequestDto(
        accepted: true,
        consentVersion: 'v2.1',
        amount: 85.500,
        currency: 'KWD',
      );
      final consentJson = consentRequest.toJson();
      expect(consentJson['accepted'], isTrue);
      expect(consentJson['consentVersion'], equals('v2.1'));
      expect(consentJson['amount'], equals(85.500));
      expect(consentJson['currency'], equals('KWD'));

      // 3. Response after consent active preserves NotConnected billing status
      final consentResponseDto = SubscriptionAutoRenewalDto.fromJson({
        'subscriptionId': 'sub-auto-1',
        'consentActive': true,
        'consentVersion': 'v2.1',
        'consentAmount': 85.500,
        'currency': 'KWD',
        'consentedAtUtc': '2026-10-15T12:00:00Z',
        'billingStatus': 'NotConnected',
        'requiresPaymentSetup': true,
        'autoChargeEnabled': false,
      });

      final consentResponseEntity = consentResponseDto.toEntity();
      expect(consentResponseEntity.consentActive, isTrue);
      expect(consentResponseEntity.billingStatus, equals('NotConnected'));
      expect(consentResponseEntity.requiresPaymentSetup, isTrue);
      expect(consentResponseEntity.autoChargeEnabled, isFalse);
    });

    test('Invoice permissions are financially independent from plan permissions', () {
      const permissions = FamilyMemberPermissionsEntity(
        memberId: 'mem-inv-1',
        version: 1,
        values: {
          'viewCalendar': true,
          'viewFamilyCalendars': false,
          'viewProgram': true,
          'viewFamilyPlans': false,
          'viewInvoices': true,
          'viewFamilyInvoices': false,
        },
        groups: [],
      );

      // Individual invoice permission does NOT imply family invoices permission
      expect(permissions.values['viewInvoices'], isTrue);
      expect(permissions.values['viewFamilyInvoices'], isFalse);
      // Individual plan permission does NOT grant family plan or invoice permission
      expect(permissions.values['viewProgram'], isTrue);
      expect(permissions.values['viewFamilyPlans'], isFalse);
    });

    test('Route constants alignment: password changes decoupled from family detachment', () {
      expect(EndPoints.customerPassword, equals('/api/v1/customers/me/password'));
      expect(EndPoints.familyMemberDetach, equals('/api/v1/customer/family/members/{memberId}/detach'));
      expect(EndPoints.customerSubscriptionAutoRenewal, equals('/api/v1/customer/subscriptions/{subscriptionId}/auto-renewal'));
      expect(EndPoints.customerSubscriptionAutoRenewalConsent, equals('/api/v1/customer/subscriptions/{subscriptionId}/auto-renewal/consent'));
      expect(EndPoints.customerSubscriptionInvoices, equals('/api/v1/customer/subscriptions/{subscriptionId}/invoices'));
    });

    testWidgets('Localized error mapping for ProblemDetails and contract error codes', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (ctx) {
              capturedContext = ctx;
              return const SizedBox();
            },
          ),
          locale: const Locale('en'),
        ),
      );

      expect(
        mapFailureMessage(capturedContext, 'invoice.not_found'),
        equals('The requested invoice is not available.'),
      );
      expect(
        mapFailureMessage(capturedContext, 'family.delivery_version_changed'),
        equals('Delivery information was updated on the server. Please review the changes.'),
      );
      expect(
        mapFailureMessage(capturedContext, 'family.detach_blocked_financial_intent'),
        equals('Cannot detach member with pending checkout or payment.'),
      );
      expect(
        mapFailureMessage(capturedContext, 'family.detach_requires_active_account'),
        equals('Member must have completed active account login before detachment.'),
      );
      expect(
        mapFailureMessage(capturedContext, 'family.password_already_issued'),
        equals('A password has already been issued for this account. Use explicit reset if you need to generate a new password.'),
      );
    });

    testWidgets('Localized error mapping in Arabic for contract error codes', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (ctx) {
              capturedContext = ctx;
              return const SizedBox();
            },
          ),
          locale: const Locale('ar'),
        ),
      );

      expect(
        mapFailureMessage(capturedContext, 'invoice.not_found'),
        equals('الفاتورة المطلوبة غير متاحة.'),
      );
      expect(
        mapFailureMessage(capturedContext, 'family.delivery_version_changed'),
        equals('تم تحديث بيانات التوصيل على الخادم، يرجى مراجعة التغييرات.'),
      );
      expect(
        mapFailureMessage(capturedContext, 'family.detach_blocked_financial_intent'),
        equals('لا يمكن فصل الفرد في حال وجود عملية دفع أو اختيار معلقة.'),
      );
      expect(
        mapFailureMessage(capturedContext, 'family.detach_requires_active_account'),
        equals('يجب أن يكون لدى الفرد حساب نشط ومكتمل قبل الفصل.'),
      );
    });
  });
}
