import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_header.dart';

void main() {
  testWidgets('calendar title stays inside header with tall status bar', (
    tester,
  ) async {
    const title = 'Calendar title';

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(390, 844),
          padding: EdgeInsets.only(top: 52),
        ),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(body: CalendarHeader(title: title)),
          ),
        ),
      ),
    );

    final headerRect = tester.getRect(find.byType(CalendarHeader));
    final titleRect = tester.getRect(find.text(title));

    expect(titleRect.bottom, lessThanOrEqualTo(headerRect.bottom));
  });
}
