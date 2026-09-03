import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

void main() {
  testWidgets('showAppDateRangePicker returns selected date range', (
    tester,
  ) async {
    DateTimeRange? result;

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
                  result = await context.showAppDateRangePicker(
                    title: 'Select range',
                    confirmText: 'Confirm',
                    cancelText: 'Cancel',
                    initialStartDate: DateTime(2026, 9, 10),
                    initialEndDate: DateTime(2026, 9, 12),
                    firstDate: DateTime(2026, 9),
                    lastDate: DateTime(2026, 9, 30),
                  );
                },
                child: const Text('Open calendar'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open calendar'));
    await tester.pumpAndSettle();

    expect(find.text('Select range'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(result?.start, DateTime(2026, 9, 10));
    expect(result?.end, DateTime(2026, 9, 12));
  });
}
