import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/profile/data/fake/profile_support_fake_data.dart';
import 'package:meal_meat_user/features/profile/presentation/support/screens/profile_help_center_screen.dart';

void main() {
  Widget buildTestWidget({
    NavigatorObserver? navigatorObserver,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: [if (navigatorObserver != null) navigatorObserver],
      routes: {
        AppRoutes.profileContactUs: (_) =>
            const Scaffold(body: Text('Contact Us Screen')),
        AppRoutes.profileComplaints: (_) =>
            const Scaffold(body: Text('Complaints Screen')),
      },
      home: const ProfileHelpCenterScreen(),
    );
  }

  testWidgets(
    'renders default list with all FAQ items and expands item on tap',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Help center'), findsOneWidget);
      expect(find.text('How can we help you?'), findsOneWidget);

      final firstItem = ProfileSupportFakeData.faqItems.first;
      expect(
        find.text(
          firstItem.question(lookupAppLocalizations(const Locale('en'))),
        ),
        findsOneWidget,
      );

      // Initially, answer is not visible
      expect(
        find.text(firstItem.answer(lookupAppLocalizations(const Locale('en')))),
        findsNothing,
      );

      // Tap the first FAQ item to expand
      await tester.tap(
        find.text(
          firstItem.question(lookupAppLocalizations(const Locale('en'))),
        ),
      );
      await tester.pumpAndSettle();

      // Answer is now visible
      expect(
        find.text(firstItem.answer(lookupAppLocalizations(const Locale('en')))),
        findsOneWidget,
      );

      // Tap again to collapse
      await tester.tap(
        find.text(
          firstItem.question(lookupAppLocalizations(const Locale('en'))),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(firstItem.answer(lookupAppLocalizations(const Locale('en')))),
        findsNothing,
      );
    },
  );

  testWidgets('filters FAQs with search query and handles empty results', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    // Enter matching query
    await tester.enterText(searchField, 'freeze');
    await tester.pumpAndSettle();

    expect(find.text('How do I freeze my subscription?'), findsOneWidget);
    expect(find.text('How do I start a new subscription?'), findsNothing);

    // Enter query with no matches
    await tester.enterText(searchField, 'xyzunknownquery');
    await tester.pumpAndSettle();

    expect(find.text('No results found'), findsOneWidget);
    expect(find.text('Clear search'), findsOneWidget);

    // Tap clear search
    await tester.tap(find.text('Clear search'));
    await tester.pumpAndSettle();

    expect(find.text('How do I start a new subscription?'), findsOneWidget);
  });

  testWidgets('bottom links navigate to contact us and complaints', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Scroll to bottom
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    expect(find.text('Contact support'), findsOneWidget);
    await tester.tap(find.text('Contact support'));
    await tester.pumpAndSettle();

    expect(find.text('Contact Us Screen'), findsOneWidget);
  });
}
