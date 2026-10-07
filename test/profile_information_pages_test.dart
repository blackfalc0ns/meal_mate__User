import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/profile/presentation/information/screens/profile_about_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/information/screens/profile_privacy_policy_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/information/screens/profile_terms_screen.dart';

void main() {
  Widget buildTestWidget(Widget home) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        AppRoutes.profileContactUs: (_) =>
            const Scaffold(body: Text('Contact Us Screen')),
      },
      home: home,
    );
  }

  testWidgets(
    'ProfileAboutScreen renders identity, features, and contact link',
    (tester) async {
      await tester.pumpWidget(buildTestWidget(const ProfileAboutScreen()));
      await tester.pumpAndSettle();

      expect(find.text('About MealMate'), findsOneWidget);
      expect(
        find.text('Your smart partner for healthy meal planning & delivery'),
        findsOneWidget,
      );
      expect(find.text('Custom Meal Plans'), findsOneWidget);
      expect(find.text('Flexible Scheduling'), findsOneWidget);
      expect(find.text('Quality & Freshness'), findsOneWidget);

      final contactButton = find.text('Contact us');
      expect(contactButton, findsOneWidget);
      await tester.ensureVisible(contactButton);
      await tester.pumpAndSettle();
      await tester.tap(contactButton);
      await tester.pumpAndSettle();

      expect(find.text('Contact Us Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'ProfilePrivacyPolicyScreen renders demo notice and ordered sections',
    (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const ProfilePrivacyPolicyScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Privacy policy'), findsOneWidget);
      expect(
        find.text(
          'Notice: This document is demonstration sample content for interface presentation and does not constitute a legally binding agreement.',
        ),
        findsOneWidget,
      );
      expect(find.text('1. Information Collected'), findsOneWidget);
      expect(find.text('2. Usage of Information'), findsOneWidget);
      expect(find.text('3. Data Protection'), findsOneWidget);
    },
  );

  testWidgets('ProfileTermsScreen renders demo notice and ordered sections', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(const ProfileTermsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Terms and conditions'), findsOneWidget);
    expect(
      find.text(
        'Notice: This document is demonstration sample content for interface presentation and does not constitute a legally binding agreement.',
      ),
      findsOneWidget,
    );
    expect(find.text('1. Service Overview'), findsOneWidget);
    expect(find.text('2. Account Responsibilities'), findsOneWidget);
    expect(find.text('3. Subscription & Billing'), findsOneWidget);
  });
}
