import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_date_range_picker.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

void main() {
  setUpAll(() async {
    final font = FontLoader('Alexandria')
      ..addFont(rootBundle.load('assets/fonts/Alexandria-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Alexandria-Bold.ttf'));
    await font.load();
  });
  testWidgets('freeze range cannot cross a day whose cutoff has closed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(450, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppDateRangePicker(
            title: 'Freeze',
            confirmText: 'Confirm',
            cancelText: 'Cancel',
            firstDate: DateTime(2026, 10, 22),
            lastDate: DateTime(2026, 11, 1),
            initialStartDate: DateTime(2026, 10, 22),
            initialEndDate: DateTime(2026, 10, 24),
            selectableDayPredicate: (date) => date.day != 23,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final confirm = tester
        .widgetList<AppButton>(find.byType(AppButton))
        .singleWhere((b) => b.text == 'Confirm');
    expect(confirm.onPressed, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'freeze confirmation disables when its server permission closes while open',
    (tester) async {
      tester.view.physicalSize = const Size(450, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var allowed = true;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AppDateRangePicker(
              title: 'Freeze',
              confirmText: 'Confirm',
              cancelText: 'Cancel',
              firstDate: DateTime(2026, 10, 22),
              lastDate: DateTime(2026, 11, 1),
              initialStartDate: DateTime(2026, 10, 22),
              initialEndDate: DateTime(2026, 10, 24),
              selectableDayPredicate: (_) => allowed,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      AppButton confirm() => tester
          .widgetList<AppButton>(find.byType(AppButton))
          .singleWhere((b) => b.text == 'Confirm');
      expect(confirm().onPressed, isNotNull);
      allowed = false;
      await tester.pump(const Duration(seconds: 1));
      expect(confirm().onPressed, isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
