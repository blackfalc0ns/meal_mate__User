import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

void main() {
  group('Calendar Edit Block Reason Localization Tests (Task 9)', () {
    testWidgets(
      'formats calendar deadline and reason strings and switches between ar and en',
      (tester) async {
        Locale currentLocale = const Locale('ar');

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return MaterialApp(
                locale: currentLocale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return Scaffold(
                      body: Column(
                        children: [
                          Text(l10n.calendarPreparing),
                          Text(
                            l10n.calendarSelectionDeadline('2026-10-14 20:00'),
                          ),
                          Text(l10n.calendarSelectionDeadlinePassed),
                          Text(l10n.calendarDayLocked),
                          Text(l10n.calendarDayFrozen),
                          Text(l10n.calendarDayCancelled),
                          Text(l10n.calendarFulfillmentNotReady),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentLocale = const Locale('en');
                              });
                            },
                            child: const Text('toggle_locale'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );

        // Arabic assertions
        expect(
          find.text('جارٍ تجهيز تقويم اشتراكك بعد تأكيد الدفع.'),
          findsOneWidget,
        );
        expect(
          find.text('يمكنك اختيار الوجبات حتى 2026-10-14 20:00.'),
          findsOneWidget,
        );
        expect(
          find.text('انتهت مهلة اختيار الوجبات لهذا اليوم.'),
          findsOneWidget,
        );
        expect(find.text('تم إغلاق التعديل لهذا اليوم.'), findsOneWidget);
        expect(
          find.text('هذا اليوم مجمّد ولا يمكن تعديله الآن.'),
          findsOneWidget,
        );
        expect(find.text('تم إلغاء هذا اليوم.'), findsOneWidget);
        expect(
          find.text('التقويم غير جاهز بعد. حاول التحديث بعد قليل.'),
          findsOneWidget,
        );

        // Switch to English
        await tester.tap(find.text('toggle_locale'));
        await tester.pumpAndSettle();

        // English assertions
        expect(
          find.text(
            'Your subscription calendar is being prepared after payment confirmation.',
          ),
          findsOneWidget,
        );
        expect(
          find.text('You can select meals until 2026-10-14 20:00.'),
          findsOneWidget,
        );
        expect(
          find.text('The meal selection deadline for this day has passed.'),
          findsOneWidget,
        );
        expect(find.text('Editing is closed for this day.'), findsOneWidget);
        expect(
          find.text('This day is frozen and cannot be edited now.'),
          findsOneWidget,
        );
        expect(find.text('This day was cancelled.'), findsOneWidget);
        expect(
          find.text('The calendar is not ready yet. Refresh in a moment.'),
          findsOneWidget,
        );
      },
    );
  });
}
