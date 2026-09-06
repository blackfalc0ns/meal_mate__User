import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_prerequisite_destination.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_prerequisite_bottom_sheet.dart';

void main() {
  testWidgets('shows only the missing address requirement', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      _TestApp(
        child: SubscriptionPrerequisiteBottomSheet(
          destination: SubscriptionPrerequisiteDestination.address,
          onPressed: () => pressed = true,
        ),
      ),
    );

    expect(find.text('Choose home location'), findsOneWidget);
    expect(find.text('Add allergy'), findsNothing);
    expect(find.text('Dietary preferences'), findsNothing);

    await tester.tap(find.text('Choose home location'));

    expect(pressed, isTrue);
  });

  testWidgets('shows only the missing allergy requirement', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: SubscriptionPrerequisiteBottomSheet(
          destination: SubscriptionPrerequisiteDestination.allergies,
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('Add allergy'), findsOneWidget);
    expect(find.text('Choose home location'), findsNothing);
    expect(find.text('Dietary preferences'), findsNothing);
  });

  testWidgets('shows only the missing dietary requirement', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: SubscriptionPrerequisiteBottomSheet(
          destination: SubscriptionPrerequisiteDestination.dietaryPreferences,
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('Dietary preferences'), findsOneWidget);
    expect(find.text('Choose home location'), findsNothing);
    expect(find.text('Add allergy'), findsNothing);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }
}
