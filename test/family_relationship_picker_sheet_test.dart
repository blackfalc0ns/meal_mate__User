import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_relationship_picker_sheet.dart';

void main() {
  const relationships = [
    FamilyRelationshipEntity(
      code: 'self',
      nameAr: 'أنت',
      nameEn: 'You',
      forDependents: false,
      isPrimary: true,
    ),
    FamilyRelationshipEntity(
      code: 'spouse',
      nameAr: 'زوج / زوجة',
      nameEn: 'Spouse',
      forDependents: true,
      isPrimary: false,
    ),
  ];

  testWidgets('picker shows dependent relationships and returns the API code', (
    tester,
  ) async {
    FamilyRelationshipEntity? selected;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                selected = await FamilyRelationshipPickerSheet.show(
                  context: context,
                  relationships: relationships,
                );
              },
              child: const Text('Open picker'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();
    expect(find.text('أنت'), findsNothing);
    expect(find.text('زوج / زوجة'), findsOneWidget);

    await tester.tap(find.text('زوج / زوجة'));
    await tester.pumpAndSettle();
    expect(selected?.code, 'spouse');
  });

  testWidgets('edit picker keeps the currently selected primary relationship', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => FamilyRelationshipPickerSheet.show(
                context: context,
                relationships: relationships,
                selectedCode: 'self',
                includeSelectedRelationship: true,
              ),
              child: const Text('Open picker'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();
    expect(find.text('You'), findsOneWidget);
    expect(find.text('Spouse'), findsOneWidget);
  });
}
