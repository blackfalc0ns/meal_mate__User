import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_settings_card.dart';

void main() {
  testWidgets('profile influencer tile opens influencer dashboard', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          AppRoutes.influencerDashboard: (_) =>
              const Scaffold(body: Text('influencer dashboard route')),
        },
        home: const Scaffold(body: ProfileSettingsCard()),
      ),
    );

    await tester.tap(find.text('Influencer Partner'));
    await tester.pumpAndSettle();

    expect(find.text('influencer dashboard route'), findsOneWidget);
  });
}
