import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_payment_section.dart';

void main() {
  testWidgets('lets customers choose an upgrade payment method', (
    tester,
  ) async {
    SubscriptionUpgradePaymentMethodEntity? selected;
    const payzah = SubscriptionUpgradePaymentMethodEntity(
      id: 3,
      code: 'PAYZAH',
      title: 'Payzah',
      integrationType: 'HOSTED',
      serviceCharge: 1.153,
      totalAmount: 15.25,
      currencyCode: 'KWD',
      isAvailable: true,
    );
    const visa = SubscriptionUpgradePaymentMethodEntity(
      id: 2,
      code: 'vm',
      title: 'فيزا / ماستر',
      integrationType: 'HOSTED',
      serviceCharge: 0.116,
      totalAmount: 15.25,
      currencyCode: 'KWD',
      isAvailable: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RestaurantTierPaymentSection(
            title: 'طريقة الدفع',
            paymentMethods: const [payzah, visa],
            selectedPaymentMethod: payzah,
            onPaymentMethodSelected: (method) => selected = method,
          ),
        ),
      ),
    );

    expect(find.text('Payzah'), findsOneWidget);
    expect(find.text('فيزا / ماستر'), findsOneWidget);

    await tester.tap(find.text('فيزا / ماستر'));

    expect(selected?.id, 2);
  });
}
