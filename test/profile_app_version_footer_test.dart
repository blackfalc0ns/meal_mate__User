import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_app_version_footer.dart';

void main() {
  Widget buildTestWidget({
    String? version,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: ProfileAppVersionFooter(version: version)),
    );
  }

  testWidgets('renders dynamic version value in English', (tester) async {
    await tester.pumpWidget(buildTestWidget(version: '2.5.1'));
    await tester.pumpAndSettle();

    expect(find.text('Version 2.5.1'), findsOneWidget);
    expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('renders dynamic version value in Arabic', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(version: '2.5.1', locale: const Locale('ar')),
    );
    await tester.pumpAndSettle();

    expect(find.text('الإصدار 2.5.1'), findsOneWidget);
    expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('renders version unavailable when version is null or empty', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(version: null));
    await tester.pumpAndSettle();

    expect(find.text('Version unavailable'), findsOneWidget);

    await tester.pumpWidget(buildTestWidget(version: '   '));
    await tester.pumpAndSettle();

    expect(find.text('Version unavailable'), findsOneWidget);
  });
}
