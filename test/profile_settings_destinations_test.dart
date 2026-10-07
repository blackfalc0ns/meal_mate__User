import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/services/language_service.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_app_version_footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    if (!getIt.isRegistered<LanguageService>()) {
      getIt.registerSingleton<LanguageService>(LanguageService(prefs));
    }
  });

  Widget buildTestWidget() {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        AppRoutes.notifications: (_) =>
            const Scaffold(body: Text('Notifications Screen')),
        AppRoutes.profileHelpCenter: (_) =>
            const Scaffold(body: Text('Help Center Screen')),
        AppRoutes.profileContactUs: (_) =>
            const Scaffold(body: Text('Contact Us Screen')),
        AppRoutes.profileComplaints: (_) =>
            const Scaffold(body: Text('Complaints Screen')),
        AppRoutes.profileAbout: (_) =>
            const Scaffold(body: Text('About Screen')),
        AppRoutes.profilePrivacyPolicy: (_) =>
            const Scaffold(body: Text('Privacy Policy Screen')),
        AppRoutes.profileTerms: (_) =>
            const Scaffold(body: Text('Terms Screen')),
      },
      home: const ProfileSettingsScreen(),
    );
  }

  testWidgets('Appearance is removed and notifications remain functional', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Appearance must be completely absent
    expect(find.text('Appearance'), findsNothing);
    expect(find.text('Choose the display mode that suits you'), findsNothing);

    // Notifications must be present and navigate
    expect(find.text('Notifications'), findsOneWidget);
    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Notifications Screen'), findsOneWidget);
  });

  testWidgets(
    'All support and information rows navigate to their destinations',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 1. Help Center
      await tester.tap(find.text('Help center'));
      await tester.pumpAndSettle();
      expect(find.text('Help Center Screen'), findsOneWidget);

      // Pop back to settings
      Navigator.of(tester.element(find.text('Help Center Screen'))).pop();
      await tester.pumpAndSettle();

      // 2. Contact Us
      await tester.tap(find.text('Contact us'));
      await tester.pumpAndSettle();
      expect(find.text('Contact Us Screen'), findsOneWidget);

      Navigator.of(tester.element(find.text('Contact Us Screen'))).pop();
      await tester.pumpAndSettle();

      // 3. Complaints
      await tester.tap(find.text('Complaints'));
      await tester.pumpAndSettle();
      expect(find.text('Complaints Screen'), findsOneWidget);

      Navigator.of(tester.element(find.text('Complaints Screen'))).pop();
      await tester.pumpAndSettle();

      // 4. About MealMate
      await tester.tap(find.text('About MealMate'));
      await tester.pumpAndSettle();
      expect(find.text('About Screen'), findsOneWidget);

      Navigator.of(tester.element(find.text('About Screen'))).pop();
      await tester.pumpAndSettle();

      // Scroll down to reveal information section items
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // 5. Privacy Policy
      await tester.tap(find.text('Privacy policy'));
      await tester.pumpAndSettle();
      expect(find.text('Privacy Policy Screen'), findsOneWidget);

      Navigator.of(tester.element(find.text('Privacy Policy Screen'))).pop();
      await tester.pumpAndSettle();

      // Scroll down again to ensure Terms is visible
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // 6. Terms and Conditions
      await tester.tap(find.text('Terms and conditions'));
      await tester.pumpAndSettle();
      expect(find.text('Terms Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'Application version is rendered via ProfileAppVersionFooter without navigation tile',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // The old navigation tile "App version" and subtitle "You are using the latest version" are gone
      expect(find.text('You are using the latest version'), findsNothing);

      // ProfileAppVersionFooter is rendered at the bottom
      expect(find.byType(ProfileAppVersionFooter), findsOneWidget);
    },
  );
}
