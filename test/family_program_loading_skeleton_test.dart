import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_selection_section.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_setup_loading_skeleton.dart';

void main() {
  testWidgets('family program loading mirrors the six-card program grid', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: FamilyProgramSetupLoadingSkeleton()),
      ),
    );

    final programCards = find.byKey(
      const ValueKey('family-program-loading-card'),
    );

    expect(programCards, findsNWidgets(6));
    expect(
      tester.getSize(programCards.first).height,
      Spacing.familyProgramCardHeight,
    );
  });

  testWidgets('loaded family stays visible while only programs shimmer', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: FamilyProgramSelectionSection(
            state: FamilyProgramsState(isProgramsLoading: true),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('family-program-grid-loading')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('family-program-loading-card')),
      findsNWidgets(6),
    );
  });
}
