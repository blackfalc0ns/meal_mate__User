import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_confirmation_section.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_price_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

void main() {
  group('formatFamilyPrice', () {
    test(
      'removes the last trailing zero when price has 3 decimals ending in zero',
      () {
        expect(formatFamilyPrice(42.0), equals('42.00'));
        expect(formatFamilyPrice(42.000), equals('42.00'));
        expect(formatFamilyPrice(202.750), equals('202.75'));
        expect(formatFamilyPrice(16.220), equals('16.22'));
        expect(formatFamilyPrice(186.530), equals('186.53'));
        expect(formatFamilyPrice(0.0), equals('0.00'));
      },
    );

    test('retains precision if 3rd decimal digit is not zero', () {
      expect(formatFamilyPrice(12.345), equals('12.345'));
    });
  });

  group('resolveFamilyCurrency', () {
    testWidgets(
      'resolves to د.ك when locale is Arabic and currency is KWD or empty',
      (tester) async {
        late AppLocalizations arabicLocale;
        late AppLocalizations englishLocale;

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                arabicLocale = AppLocalizations.of(context)!;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolveFamilyCurrency(arabicLocale, 'KWD'), equals('د.ك'));
        expect(resolveFamilyCurrency(arabicLocale, 'kwd'), equals('د.ك'));
        expect(resolveFamilyCurrency(arabicLocale, ''), equals('د.ك'));
        expect(resolveFamilyCurrency(arabicLocale, null), equals('د.ك'));
        expect(resolveFamilyCurrency(arabicLocale, 'USD'), equals('USD'));

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                englishLocale = AppLocalizations.of(context)!;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolveFamilyCurrency(englishLocale, 'KWD'), equals('KWD'));
        expect(resolveFamilyCurrency(englishLocale, ''), equals('KWD'));
      },
    );
  });

  group('FamilyPaymentConfirmationSection Summary Values', () {
    testWidgets(
      'renders total price label and with-Friday text when includeFriday is true',
      (tester) async {
        const memberSummary = FamilySelectedMemberSummaryEntity(
          memberId: 'm1',
          displayName: 'أحمد',
          programNameAr: 'خسارة الوزن',
          bundleNameAr: 'ريوق + غداء + سناك',
          durationDays: 6,
          durationLabelAr: '6 يوم',
          memberPrice: 42.0,
          includeFriday: true,
        );

        const state = FamilyCheckoutState(
          summary: FamilySummaryEntity(
            batchId: 'b1',
            selectedMemberId: 'm1',
            subtotal: 42.0,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 42.0,
            canCheckout: true,
            currencyCode: 'KWD',
            selectedMember: memberSummary,
            members: [
              FamilySummaryMemberEntity(
                memberId: 'm1',
                displayName: 'أحمد',
                isManager: true,
              ),
            ],
          ),
          currentFlow: FamilyFlowCurrentEntity(
            members: [
              FamilyMemberEntity(
                memberId: 'm1',
                displayName: 'أحمد',
                role: 1,
                relationshipCode: 'self',
                ageYears: 30,
                setupStatus: 1,
                gender: 1,
                isCurrentUser: true,
                includeFriday: true,
              ),
            ],
          ),
        );

        await tester.pumpWidget(
          const MaterialApp(
            locale: Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: FamilyPaymentConfirmationSection(state: state),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should display total price label (السعر الإجمالي) and NOT weekly price (السعر الأسبوعي)
        expect(find.text('السعر الإجمالي'), findsOneWidget);
        expect(find.text('السعر الأسبوعي'), findsNothing);

        // Price value should be formatted without the third trailing zero and with Arabic currency
        expect(find.text('42.00 د.ك'), findsOneWidget);

        // Days row should state 6 days with Friday
        expect(find.text('6 يوم (مع يوم جمعة)'), findsOneWidget);
      },
    );

    testWidgets(
      'renders total price label and without-Friday text when includeFriday is false',
      (tester) async {
        const memberSummary = FamilySelectedMemberSummaryEntity(
          memberId: 'm2',
          displayName: 'سارة',
          programNameAr: 'خسارة الوزن',
          bundleNameAr: 'غداء + عشاء',
          durationDays: 5,
          durationLabelAr: '5 يوم',
          memberPrice: 35.5,
          includeFriday: false,
        );

        const state = FamilyCheckoutState(
          summary: FamilySummaryEntity(
            batchId: 'b1',
            selectedMemberId: 'm2',
            subtotal: 35.5,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 35.5,
            canCheckout: true,
            currencyCode: 'KWD',
            selectedMember: memberSummary,
            members: [
              FamilySummaryMemberEntity(
                memberId: 'm2',
                displayName: 'سارة',
                isManager: false,
              ),
            ],
          ),
          currentFlow: FamilyFlowCurrentEntity(
            members: [
              FamilyMemberEntity(
                memberId: 'm2',
                displayName: 'سارة',
                role: 2,
                relationshipCode: 'sister',
                ageYears: 25,
                setupStatus: 1,
                gender: 2,
                isCurrentUser: false,
                includeFriday: false,
              ),
            ],
          ),
        );

        await tester.pumpWidget(
          const MaterialApp(
            locale: Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: FamilyPaymentConfirmationSection(state: state),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should display total price label (السعر الإجمالي) and NOT weekly price (السعر الأسبوعي)
        expect(find.text('السعر الإجمالي'), findsOneWidget);
        expect(find.text('السعر الأسبوعي'), findsNothing);

        // Price value should be formatted without third trailing zero
        expect(find.text('35.50 د.ك'), findsOneWidget);

        // Days row should state without Friday
        expect(find.text('5 يوم (بدون يوم جمعة)'), findsOneWidget);
      },
    );
  });

  group('FamilyPaymentPriceSection Summary Labels', () {
    testWidgets(
      'renders "إجمالي اشتراك الأفراد" and "إجمالي اشتراك العائلة:"',
      (tester) async {
        const summary = FamilySummaryEntity(
          batchId: 'b1',
          subtotal: 84.0,
          familyDiscountPercent: 0.08,
          familyDiscountAmount: 6.72,
          finalPrice: 77.28,
          canCheckout: true,
          currencyCode: 'KWD',
        );

        await tester.pumpWidget(
          const MaterialApp(
            locale: Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: FamilyPaymentPriceSection(summary: summary),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should display "إجمالي اشتراك الأفراد" and NOT "إجمالي المدة"
        expect(find.text('إجمالي اشتراك الأفراد'), findsOneWidget);
        expect(find.text('إجمالي المدة'), findsNothing);

        // Should display "إجمالي اشتراك العائلة:" (both in row and bottom card) and NOT "الإجمالي:"
        expect(find.text('إجمالي اشتراك العائلة:'), findsNWidgets(2));
        expect(find.text('الإجمالي:'), findsNothing);

        // Verify values
        expect(find.textContaining('84.00'), findsOneWidget);
        expect(find.textContaining('-6.72'), findsOneWidget);
        expect(find.textContaining('77.28'), findsWidgets);
      },
    );
  });
}
