import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/restaurant_tier_upgrade_screen.dart';

void main() {
  testWidgets(
    'restaurant tier upgrade starts at tier selection then shows confirmation',
    (tester) async {
      tester.view.physicalSize = const Size(522, 1134);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const RestaurantTierUpgradeScreen(),
        ),
      );

      expect(find.text('اختر التصنيف الذي تريد الترقية إليه'), findsOneWidget);
      expect(find.text('تفاصيل الترقية'), findsNothing);

      await tester.ensureVisible(find.text('ترقية إلى بلس'));
      await tester.tap(find.text('ترقية إلى بلس'));
      await tester.pumpAndSettle();

      expect(find.text('مقارنة سريعة'), findsOneWidget);
      expect(find.text('تفاصيل الترقية'), findsOneWidget);
      expect(find.text('طريقة الدفع'), findsOneWidget);
    },
  );
}
