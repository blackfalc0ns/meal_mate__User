import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_content.dart';

void main() {
  for (final width in [320.0, 360.0]) {
    testWidgets('fixed family program actions fit a $width wide screen', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: FamilyProgramContent(state: FamilyProgramsState()),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FamilyProgramActions), findsOneWidget);
      expect(
        tester.getSize(find.byType(FamilyProgramActions)).width.isFinite,
        isTrue,
      );
    });
  }
}
