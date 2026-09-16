import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_info_action.dart';

void main() {
  testWidgets(
    'expanded family chip hides info icon and fits a narrow toolbar',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('إعداد اشتراك العائلة'),
              actions: const [
                FamilyFlowInfoAction(
                  familyName: 'عائلة تجريبية باسم طويل للغاية',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.info_outlined), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('family-flow-info-button')));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.info_outlined), findsNothing);
      expect(find.byIcon(Icons.group_rounded), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
