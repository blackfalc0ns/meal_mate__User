import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

void main() {
  testWidgets('showAppCustomDialog renders content and returns action result', (
    tester,
  ) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await context.showAppCustomDialog<bool>(
                    title: 'Test title',
                    message: 'Test message',
                    content: const Text('Dialog body'),
                    cancelText: 'Cancel',
                    confirmText: 'Confirm',
                    onCancel: () => false,
                    onConfirm: () => true,
                  );
                },
                child: const Text('Open dialog'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Test title'), findsOneWidget);
    expect(find.text('Test message'), findsOneWidget);
    expect(find.text('Dialog body'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('showAppCustomDialog returns cancel result', (tester) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await context.showAppCustomDialog<bool>(
                    title: 'Test title',
                    message: 'Test message',
                    cancelText: 'Cancel',
                    confirmText: 'Confirm',
                    onCancel: () => false,
                    onConfirm: () => true,
                  );
                },
                child: const Text('Open dialog'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
