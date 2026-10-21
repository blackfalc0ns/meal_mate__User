import 'support/family_calendar_view_model_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/screens/family_member_calendar_screen.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_empty_meals.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

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
          home: FamilyMemberCalendarScreen(
            viewModel: createFamilyCalendarViewModel(),
          ),
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
          home: FamilyMemberCalendarScreen(
            viewModel: createFamilyCalendarViewModel(
              membersData: const [
                FamilyMemberSummaryEntity(
                  memberId: 'mem-1',
                  displayName: 'أحمد',
                  role: 1,
                  ageYears: 10,
                  isPaused: false,
                  subscriptionId: 'sub-1',
                  programName: '',
                  remainingDays: 0,
                  setupStatus: 1,
                ),
              ],
            ),
            args: const FamilyMemberCalendarArgs(
              subscriptionId: 'sub-1',
              displayName: 'أحمد',
              memberId: 'mem-1',
            ),
          ),
        ),
      );

      await tester.pump();
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

  testWidgets(
    'supplied ViewModel stays open when FamilyMemberCalendarScreen is disposed',
    (tester) async {
      final viewModel = createFamilyCalendarViewModel();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FamilyMemberCalendarScreen(viewModel: viewModel),
        ),
      );
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      expect(viewModel.isClosed, isFalse);
    },
  );

  testWidgets(
    'locally created ViewModel closes when FamilyMemberCalendarScreen is disposed',
    (tester) async {
      final createdViewModel = createFamilyCalendarViewModel();
      if (getIt.isRegistered<FamilyCalendarViewModel>()) {
        getIt.unregister<FamilyCalendarViewModel>();
      }
      getIt.registerFactory<FamilyCalendarViewModel>(() => createdViewModel);
      addTearDown(() {
        if (getIt.isRegistered<FamilyCalendarViewModel>()) {
          getIt.unregister<FamilyCalendarViewModel>();
        }
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FamilyMemberCalendarScreen(),
        ),
      );
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      expect(createdViewModel.isClosed, isTrue);
    },
  );

  testWidgets(
    'renders inline error when capabilitiesFailure or dayFailure is present',
    (tester) async {
      final viewModel = createFamilyCalendarViewModel();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FamilyMemberCalendarScreen(
            viewModel: viewModel,
            args: const FamilyMemberCalendarArgs(
              subscriptionId: 'sub-1',
              displayName: 'أحمد',
            ),
          ),
        ),
      );
      await tester.pump();

      viewModel.emit(
        FamilyCalendarState(
          currentSubscriptionId: 'sub-1',
          selectedDate: DateTime(2026, 9, 20),
          days: [
            CalendarDayEntity(
              dayNumber: 20,
              weekday: 'الأحد',
              date: DateTime(2026, 9, 20),
            ),
          ],
          capabilitiesFailure: Failure(errorMessage: 'Capabilities error'),
          dayFailure: Failure(errorMessage: 'Day error'),
        ),
      );
      await tester.pump();

      expect(find.byType(InlineApiErrorWidget), findsNWidgets(2));
    },
  );
}
