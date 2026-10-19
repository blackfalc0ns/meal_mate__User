import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_primary_action.dart';

void main() {
  testWidgets('family calendar loading uses a structural shimmer', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FamilyMemberCalendarLoadingSkeleton(),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('family-calendar-loading-skeleton')),
      findsOneWidget,
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('empty editable day offers meal selection', (tester) async {
    var choseMeals = false;
    await tester.pumpWidget(
      _localized(
        FamilyMemberCalendarPrimaryAction(
          hasMeals: false,
          canEdit: true,
          onChooseMeals: () => choseMeals = true,
          onShowDetails: () => fail('details must not open for an empty day'),
        ),
      ),
    );

    expect(find.text('اختيار الوجبات'), findsOneWidget);
    await tester.tap(find.text('اختيار الوجبات'));
    expect(choseMeals, isTrue);
  });

  testWidgets('day with meals offers day details', (tester) async {
    var showedDetails = false;
    await tester.pumpWidget(
      _localized(
        FamilyMemberCalendarPrimaryAction(
          hasMeals: true,
          canEdit: true,
          onChooseMeals: () => fail('selection must not open'),
          onShowDetails: () => showedDetails = true,
        ),
      ),
    );

    expect(find.text('عرض تفاصيل اليوم'), findsOneWidget);
    await tester.tap(find.text('عرض تفاصيل اليوم'));
    expect(showedDetails, isTrue);
  });

  testWidgets('locked day shows a disabled closed action', (tester) async {
    await tester.pumpWidget(
      _localized(
        FamilyMemberCalendarPrimaryAction(
          hasMeals: true,
          canEdit: false,
          onChooseMeals: () => fail('selection must not open'),
          onShowDetails: () => fail('details must not open'),
        ),
      ),
    );

    expect(find.text('تم الإغلاق'), findsOneWidget);
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });
}

Widget _localized(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  locale: const Locale('ar'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);
