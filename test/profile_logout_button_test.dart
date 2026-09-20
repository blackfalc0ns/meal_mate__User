import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_logout_button.dart';

void main() {
  testWidgets('logout requires confirmation and can be cancelled', (
    tester,
  ) async {
    var confirmations = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ProfileLogoutButton(onConfirmLogout: () => confirmations++),
        ),
      ),
    );

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Are you sure you want to log out?'), findsOneWidget);
    expect(confirmations, 0);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(confirmations, 0);
    expect(find.text('Are you sure you want to log out?'), findsNothing);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out').last);
    await tester.pumpAndSettle();
    expect(confirmations, 1);
  });
}
