import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_shared/presentation/navigation/family_flow_route_observer.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_navigator.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scaffold.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';

void main() {
  test('family flow routes select their matching persistent step', () {
    expect(
      FamilyFlowRouteObserver.stepFor(AppRoutes.familySubscriptionSetup),
      0,
    );
    expect(FamilyFlowRouteObserver.stepFor(AppRoutes.familyProgramSetup), 1);
    expect(FamilyFlowRouteObserver.stepFor(AppRoutes.familyAddresses), 2);
    expect(FamilyFlowRouteObserver.stepFor(AppRoutes.familyAllergies), 3);
    expect(
      FamilyFlowRouteObserver.stepFor(AppRoutes.familyPackageDaysSetup),
      4,
    );
    expect(FamilyFlowRouteObserver.stepFor(AppRoutes.familyPaymentSetup), 5);
    expect(FamilyFlowRouteObserver.stepFor(null), isNull);
    expect(FamilyFlowRouteObserver.stepFor('/family-sheet'), isNull);
  });

  testWidgets('changing the family stage only rebuilds the stepper subtree', (
    tester,
  ) async {
    final currentStep = ValueNotifier<int>(0);
    var bodyBuilds = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: FamilyFlowScaffold(
          currentStepListenable: currentStep,
          body: Builder(
            builder: (context) {
              bodyBuilds++;
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );

    expect(find.byType(FamilyProgramStepper), findsOneWidget);
    expect(bodyBuilds, 1);

    currentStep.value = 3;
    await tester.pump();

    expect(find.byType(FamilyProgramStepper), findsOneWidget);
    expect(bodyBuilds, 1);
  });

  testWidgets('family stages navigate under one persistent flow scaffold', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: FamilyFlowNavigator(
          initialRoute: AppRoutes.familySubscriptionSetup,
          routeFactory: (settings) => MaterialPageRoute<void>(
            settings: settings,
            builder: (context) => switch (settings.name) {
              AppRoutes.familyProgramSetup => const Text('program-stage'),
              _ => Builder(
                builder: (context) => TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.familyProgramSetup),
                  child: const Text('next-stage'),
                ),
              ),
            },
          ),
        ),
      ),
    );

    expect(find.byType(FamilyProgramStepper), findsOneWidget);
    await tester.tap(find.text('next-stage'));
    await tester.pumpAndSettle();

    expect(find.text('program-stage'), findsOneWidget);
    expect(find.byType(FamilyProgramStepper), findsOneWidget);
  });

  testWidgets(
    'family flow scaffold displays home action in app bar and shows home icon',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: FamilyFlowScope(
            child: Builder(
              builder: (context) {
                FamilyFlowScope.updateFamilyName(context, 'عائلة yyyy');
                return FamilyFlowScaffold(
                  currentStepListenable: ValueNotifier<int>(1),
                  body: const SizedBox.expand(),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(
        find.byKey(const ValueKey('family-flow-home-button')),
        findsOneWidget,
      );
    },
  );
}
