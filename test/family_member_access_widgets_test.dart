import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_credentials_card.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_header.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_independent_card.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_password_dialog.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_permissions_tile.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_status_card.dart';

void main() {
  Widget buildTestable(Widget child) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  testWidgets('FamilyMemberAccessLoadingSkeleton renders shimmer elements', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestable(
        const SizedBox(height: 800, child: FamilyMemberAccessLoadingSkeleton()),
      ),
    );

    expect(find.byType(FamilyMemberAccessLoadingSkeleton), findsOneWidget);
  });

  testWidgets('FamilyMemberAccessHeader renders active state correctly', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestable(
        const FamilyMemberAccessHeader(
          isPaused: false,
          hasExistingLogin: false,
        ),
      ),
    );

    expect(find.text('حالة الحساب'), findsOneWidget);
    expect(find.text('نشط'), findsWidgets);
  });

  testWidgets('FamilyMemberAccessHeader renders paused state correctly', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestable(
        const FamilyMemberAccessHeader(isPaused: true, hasExistingLogin: false),
      ),
    );

    expect(find.text('متوقف مؤقتاً'), findsWidgets);
  });

  testWidgets(
    'FamilyMemberAccessCredentialsCard renders identifier and password',
    (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const FamilyMemberAccessCredentialsCard(identifier: '+965 50000000'),
        ),
      );

      expect(find.text('بيانات الدخول'), findsOneWidget);
      expect(find.text('+965 50000000'), findsOneWidget);
      expect(find.text('••••••••'), findsOneWidget);
      expect(find.text('تعديل'), findsNWidgets(2));
    },
  );

  testWidgets('FamilyMemberAccessIndependentCard renders title and switch', (
    tester,
  ) async {
    bool toggled = false;
    await tester.pumpWidget(
      buildTestable(
        FamilyMemberAccessIndependentCard(
          memberName: 'أحمد',
          hasIndependentAccount: true,
          onChanged: (val) => toggled = val,
        ),
      ),
    );

    expect(find.text('لديه حساب مستقل'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    final switchFinder = find.byType(Switch);
    await tester.tap(switchFinder);
    expect(toggled, false);
  });

  testWidgets(
    'FamilyMemberAccessStatusCard renders radio choices and deactivate button',
    (tester) async {
      bool selectedPause = false;
      bool deactivateClicked = false;

      await tester.pumpWidget(
        buildTestable(
          FamilyMemberAccessStatusCard(
            memberName: 'أحمد',
            isPaused: false,
            canDeactivate: true,
            onStatusChanged: (val) => selectedPause = val,
            onDeactivate: () => deactivateClicked = true,
          ),
        ),
      );

      expect(find.text('إدارة العضوية'), findsOneWidget);
      expect(find.text('نشط'), findsOneWidget);
      expect(find.text('متوقف مؤقتاً'), findsOneWidget);
      expect(find.text('إيقاف الحساب'), findsOneWidget);

      await tester.tap(find.text('متوقف مؤقتاً'));
      expect(selectedPause, true);

      await tester.tap(find.text('إيقاف الحساب'));
      expect(deactivateClicked, true);
    },
  );

  testWidgets('FamilyMemberAccessPermissionsTile renders navigation tile', (
    tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      buildTestable(
        FamilyMemberAccessPermissionsTile(onTap: () => tapped = true),
      ),
    );

    expect(find.text('صلاحيات استخدام التطبيق'), findsOneWidget);
    await tester.tap(find.byType(FamilyMemberAccessPermissionsTile));
    expect(tapped, true);
  });

  testWidgets(
    'FamilyMemberAccessPasswordDialog renders password and copy button',
    (tester) async {
      bool dismissed = false;
      await tester.pumpWidget(
        buildTestable(
          FamilyMemberAccessPasswordDialog(
            password: 'Pass1234!',
            onDismiss: () => dismissed = true,
          ),
        ),
      );

      expect(find.text('كلمة مرور لمرة واحدة'), findsOneWidget);
      expect(find.text('Pass1234!'), findsOneWidget);
      expect(find.text('نسخ'), findsOneWidget);

      await tester.tap(find.byType(TextButton).last);
      expect(dismissed, true);
    },
  );
}
