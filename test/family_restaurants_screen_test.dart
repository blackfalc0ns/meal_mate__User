import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_view_model.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'support/family_meal_selection_view_model_factory.dart';
import 'support/family_calendar_view_model_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/models/family_restaurants_view_data.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/screens/family_restaurants_screen.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_member_selector.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_member_selector_item.dart';

void main() {
  setUp(registerFamilyMealSelectionFactory);
  tearDown(() => getIt.unregister<FamilyMealSelectionViewModel>());

  testWidgets('selecting another member reports its index', (tester) async {
    int? selectedIndex;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: FamilyRestaurantsMemberSelector(
            members: const [
              FamilyRestaurantsMemberData(name: 'الأول', isSelected: true),
              FamilyRestaurantsMemberData(name: 'الثاني'),
            ],
            onMemberSelected: (index) => selectedIndex = index,
          ),
        ),
      ),
    );

    await tester.tap(find.text('الثاني'));

    expect(selectedIndex, 1);
  });

  testWidgets('member placeholder fits inside its fixed card height', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: FamilyRestaurantsMemberSelectorItem(
            member: FamilyRestaurantsMemberData(
              name: 'Member',
              isSelected: true,
            ),
            onSelected: _doNothing,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('empty backend result never falls back to fake restaurants', (
    tester,
  ) async {
    final viewModel = createFamilyCalendarViewModel();
    addTearDown(viewModel.close);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FamilyRestaurantsScreen(
          args: FamilyRestaurantsArgs(
            subscriptionId: 'subscription-1',
            date: DateTime(2026, 9, 13),
            memberName: 'Backend member',
            viewModel: viewModel,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Diet House'), findsNothing);
    expect(find.text('Mariam'), findsNothing);
    expect(find.byType(EmptyStateWidget), findsOneWidget);
  });
}

void _doNothing() {}
