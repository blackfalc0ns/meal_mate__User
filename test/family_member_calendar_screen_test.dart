import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/screens/family_member_calendar_screen.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_empty_meals.dart';

void main() {
  testWidgets(
    'family member calendar screen renders empty state when no active plan',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FamilyMemberCalendarScreen(),
        ),
      );

      expect(find.byType(EmptyStateWidget), findsOneWidget);
    },
  );

  testWidgets(
    'family member calendar screen renders member selector when member provided',
    (tester) async {
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

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FamilyMemberCalendarScreen(
            args: FamilyMemberCalendarArgs(
              subscriptionId: 'sub-1',
              displayName: 'أحمد',
              memberId: 'mem-1',
            ),
          ),
        ),
      );

      expect(find.byType(FamilyDayMemberSelector), findsOneWidget);
      expect(find.text('أحمد'), findsWidgets);
    },
  );

  testWidgets('FamilyMemberCalendarEmptyMeals renders illustration and text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: FamilyMemberCalendarEmptyMeals()),
      ),
    );

    expect(find.byType(FamilyMemberCalendarEmptyMeals), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image));
    expect(
      (image.image as AssetImage).assetName,
      Assets.calendarEmptyMealsIllustration,
    );
    expect(find.text('لا توجد وجبات مختارة لهذا اليوم.'), findsOneWidget);
  });
}
