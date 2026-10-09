import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

void main() {
  group('Subscription Availability Localization Tests (Task 9)', () {
    testWidgets(
      'formats placeholders and switches language between ar and en dynamically',
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
                          Text(l10n.subscriptionFirstDelivery('2026-10-11')),
                          Text(l10n.subscriptionPaymentAnchor('2026-10-08')),
                          Text(
                            l10n.subscriptionNoRestaurantsForAddress('الرشاقة'),
                          ),
                          Text(l10n.subscriptionNoRestaurantsForSelection),
                          Text(l10n.subscriptionAvailabilityChanged),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentLocale = const Locale('en');
                              });
                            },
                            child: const Text('switch'),
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

        // Verify Arabic initial strings
        expect(
          find.text('بداية الاشتراك وأول توصيل: 2026-10-11'),
          findsOneWidget,
        );
        expect(find.text('تاريخ الاختيار: 2026-10-08'), findsOneWidget);
        expect(
          find.text(
            'لا توجد مطاعم تقدم برنامج الرشاقة وتوصل إلى عنوانك المحدد.',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'لا توجد مطاعم متاحة طوال مدة الاشتراك وفق اختياراتك الحالية.',
          ),
          findsOneWidget,
        );
        expect(
          find.text('تغير توافر المطاعم. راجع الملخص قبل إعادة محاولة الدفع.'),
          findsOneWidget,
        );

        // Switch to English
        await tester.tap(find.text('switch'));
        await tester.pumpAndSettle();

        // Verify English strings after switch
        expect(
          find.text('Subscription start and first delivery: 2026-10-11'),
          findsOneWidget,
        );
        expect(find.text('Selected payment date: 2026-10-08'), findsOneWidget);
        expect(
          find.text(
            'No restaurants offer the الرشاقة program and deliver to your selected address.',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'No restaurants are available throughout the subscription period with your current selections.',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'Restaurant availability changed. Review the summary before trying payment again.',
          ),
          findsOneWidget,
        );
      },
    );
  });
}
