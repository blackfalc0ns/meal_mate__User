import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_permissions_confirm_dialog.dart';

void main() {
  testWidgets(
    'FamilyMemberPermissionsConfirmDialog confirms and cancels correctly',
    (tester) async {
      bool confirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => FamilyMemberPermissionsConfirmDialog(
                    memberName: 'أحمد',
                    onConfirm: () => confirmed = true,
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(FamilyMemberPermissionsConfirmDialog), findsOneWidget);
      expect(find.text('تأكيد حفظ الصلاحيات'), findsOneWidget);
      expect(find.textContaining('أحمد'), findsOneWidget);

      // Confirm
      await tester.tap(find.text('تأكيد'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
      expect(find.byType(FamilyMemberPermissionsConfirmDialog), findsNothing);
    },
  );
}
