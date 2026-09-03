import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_frozen_day_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';

void main() {
  testWidgets(
    'CalendarFrozenDayState renders Figma frozen illustration and texts',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: CalendarFrozenDayState()),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(
        (imageWidget.image as AssetImage).assetName,
        Assets.calendarFrozenDayIllustration,
      );
      expect(find.text('تم تجميد اليوم'), findsOneWidget);
      expect(
        find.text(
          'تم إيقاف تحضير وتوصيل وجبات هذا اليوم مؤقتا. يمكنك إلغاء التجميد لاستئناف الوجبات',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'CalendarPickerPanel renders frozen day tile without any overflow',
    (tester) async {
      final frozenDay = CalendarDayEntity(
        date: DateTime(2026, 9, 25),
        dayNumber: 25,
        weekday: 'الأحد',
        isSelected: true,
        status: 'frozen',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CalendarPickerPanel(
              monthTitle: 'سبتمبر 2026',
              days: [frozenDay],
              isExpanded: false,
              onToggleExpanded: () {},
              onMonthChanged: (_) {},
              onDaySelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('25'), findsOneWidget);
      expect(find.text('الأحد'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
