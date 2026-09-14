import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/screens/influencer_share_links_screen.dart';

void main() {
  testWidgets('share links screen renders figma fake data sections', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: InfluencerShareLinksScreen(showScaffold: false),
        ),
      ),
    );

    expect(find.text('Mealmate20'), findsOneWidget);
    expect(find.text('https://mealmate.com/ref/Mealmate20'), findsOneWidget);
    expect(find.text('35%'), findsOneWidget);
    expect(find.text('68'), findsOneWidget);
    expect(find.text('520'), findsOneWidget);
    expect(find.text('واتساب'), findsOneWidget);
    expect(find.text('إنستغرام'), findsOneWidget);
    expect(find.text('تيليجرام'), findsOneWidget);
    expect(find.text('تيك توك'), findsOneWidget);
    expect(find.text('المزيد'), findsOneWidget);
  });
}
