import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_restaurants_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_date_badge.dart';

void main() {
  testWidgets(
    'family restaurants screen shows member selector above date badge',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FamilyRestaurantsScreen(),
        ),
      );

      final selectorFinder = find.byKey(
        const ValueKey('family_restaurants_member_selector'),
      );
      final dateBadgeFinder = find.byType(FamilyRestaurantsDateBadge);

      expect(selectorFinder, findsOneWidget);
      expect(
        find.byKey(const ValueKey('family_restaurants_member_selector_item')),
        findsNWidgets(4),
      );

      final selectorTop = tester.getTopLeft(selectorFinder).dy;
      final dateBadgeTop = tester.getTopLeft(dateBadgeFinder).dy;

      expect(selectorTop, lessThan(dateBadgeTop));
    },
  );
}
