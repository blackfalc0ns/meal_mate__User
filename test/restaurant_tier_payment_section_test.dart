import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_payment_section.dart';

void main() {
  testWidgets('lets customers choose an upgrade payment method', (
    tester,
  ) async {
    SubscriptionUpgradePaymentMethodEntity? selected;
    const mada = SubscriptionUpgradePaymentMethodEntity(
      id: 6,
      code: 'md',
      title: 'مدى',
      integrationType: 'MYFATOORAH_HOSTED',
      serviceCharge: 1.153,
      totalAmount: 15.25,
      currencyCode: 'KWD',
      isAvailable: true,
    );
    const visa = SubscriptionUpgradePaymentMethodEntity(
      id: 2,
      code: 'vm',
      title: 'فيزا / ماستر',
      integrationType: 'MYFATOORAH_HOSTED',
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
            paymentMethods: const [mada, visa],
            selectedPaymentMethod: mada,
            onPaymentMethodSelected: (method) => selected = method,
          ),
        ),
      ),
    );

    expect(find.text('مدى'), findsOneWidget);
    expect(find.text('فيزا / ماستر'), findsOneWidget);

    await tester.tap(find.text('فيزا / ماستر'));

    expect(selected?.id, 2);
  });
}
