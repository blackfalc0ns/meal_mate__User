import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_content.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_empty_meals_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';

class _FakeOverviewCubit extends Cubit<CalendarOverviewState>
    implements CalendarOverviewViewModel {
  _FakeOverviewCubit(super.state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final language in ['ar', 'en']) {
    testWidgets('no subscription calendar renders and navigates in $language', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cubit = _FakeOverviewCubit(
        const CalendarOverviewState(hasNoSubscription: true),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: Locale(language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            AppRoutes.subscriptions: (_) =>
                const Scaffold(body: Text('Subscriptions route')),
          },
          home: Scaffold(
            body: BlocProvider<CalendarOverviewViewModel>.value(
              value: cubit,
              child: CalendarContent(
                showBottomSpace: false,
                onSelectRestaurant: () {},
                onChangeMeal: () {},
                onMealTap: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CalendarPickerPanel), findsOneWidget);
      expect(find.byType(CalendarEmptyMealsState), findsOneWidget);
      final action = language == 'ar' ? 'عرض الاشتراكات' : 'View subscriptions';
      expect(find.text(action), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text(action));
      await tester.pumpAndSettle();
      expect(find.text('Subscriptions route'), findsOneWidget);
    });
  }
}
