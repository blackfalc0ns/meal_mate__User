import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_day_meals_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_header.dart';

void main() {
  testWidgets('family day screen shows member selector above date header', (
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

    final members = List.generate(
      4,
      (i) => FamilyMemberSummaryEntity(
        memberId: 'm_$i',
        displayName: 'Member $i',
        role: 2,
        ageYears: 20 + i,
        isPaused: false,
        subscriptionId: 'sub_$i',
        programName: 'Program $i',
        remainingDays: 10,
        setupStatus: 2,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FamilyDayMealsScreen(
          args: FamilyDayMealsArgs(
            subscriptionId: 'sub_1',
            date: DateTime(2024, 5, 26),
            members: members,
          ),
        ),
      ),
    );

    final selectorFinder = find.byKey(
      const ValueKey('family_day_member_selector'),
    );
    final dateHeaderFinder = find.byType(FamilyDayHeader);

    expect(selectorFinder, findsOneWidget);
    expect(
      find.byKey(const ValueKey('family_day_member_selector_item')),
      findsNWidgets(4),
    );

    final selectorTop = tester.getTopLeft(selectorFinder).dy;
    final dateHeaderTop = tester.getTopLeft(dateHeaderFinder).dy;

    expect(selectorTop, lessThan(dateHeaderTop));
  });
}
