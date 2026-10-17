import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_home_action.dart';

void main() {
  testWidgets('renders home icon and triggers onPressed on tap', (
    tester,
  ) async {
    var homePressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: AppBar(
            actions: [
              FamilyFlowHomeAction(
                onPressed: () {
                  homePressed = true;
                },
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('family-flow-home-button')),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('family-flow-home-button')));
    await tester.pumpAndSettle();

    expect(homePressed, isTrue);
  });

  testWidgets('default behavior navigates to AppRoutes.home', (tester) async {
    String? navigatedRoute;
    Object? navigatedArgs;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.home) {
            navigatedRoute = settings.name;
            navigatedArgs = settings.arguments;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('Home Screen')),
            );
          }
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(
              appBar: AppBar(actions: const [FamilyFlowHomeAction()]),
            ),
          );
        },
      ),
    );

    expect(
      find.byKey(const ValueKey('family-flow-home-button')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('family-flow-home-button')));
    await tester.pumpAndSettle();

    expect(navigatedRoute, AppRoutes.home);
    expect(navigatedArgs, 0);
    expect(find.text('Home Screen'), findsOneWidget);
  });
}
