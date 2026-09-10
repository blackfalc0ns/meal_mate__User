import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_calendar_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_review_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_empty_meals.dart';

void main() {
  testWidgets('family member calendar screen renders fallback without DI', (
    tester,
  ) async {
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
        home: const FamilyMemberCalendarScreen(),
      ),
    );

    expect(find.byType(FamilyDayMemberSelector), findsOneWidget);
    expect(find.byType(CalendarPickerPanel), findsOneWidget);
    expect(find.byType(FamilyDayReviewButton), findsOneWidget);
  });

  testWidgets('FamilyMemberCalendarEmptyMeals renders illustration and text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: FamilyMemberCalendarEmptyMeals(),
        ),
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
