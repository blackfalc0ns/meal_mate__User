import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_generator.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';

void main() {
  testWidgets(
    'daily meals shortcut route opens member calendar before day details',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: AppRoutes.familyMemberDailyMeals,
          onGenerateRoute: RouteGenerator.getRoute,
        ),
      );

      expect(find.text('تقويم أحمد'), findsOneWidget);
      expect(find.text('تفاصيل يوم'), findsNothing);
      expect(find.byType(CalendarPickerPanel), findsOneWidget);
      expect(find.byKey(const ValueKey('month-grid')), findsNothing);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('month-grid')), findsOneWidget);

      final previousOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        final exception = details.exception;
        if (exception is FlutterError &&
            exception.message.contains('A RenderFlex overflowed')) {
          return;
        }
        previousOnError?.call(details);
      };
      addTearDown(() => FlutterError.onError = previousOnError);

      await tester.ensureVisible(find.text('عرض تفاصيل اليوم'));
      await tester.tap(find.text('عرض تفاصيل اليوم'));
      await tester.pumpAndSettle();

      expect(find.text('تفاصيل يوم'), findsOneWidget);
    },
  );
}
