import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_members_list_card.dart';

void main() {
  Widget buildTestCard({
    required FamilyMemberSummaryEntity member,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 380,
            child: FamilyMembersListCard(member: member, onTap: onTap),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'FamilyMembersListCard displays real data without static fallbacks when member has no active plan',
    (tester) async {
      const member = FamilyMemberSummaryEntity(
        memberId: 'mem-1',
        displayName: 'yahya',
        role: 1, // Manager
        ageYears: null,
        isPaused: false,
        subscriptionId: null,
        programName: 'كيتو',
        remainingDays: 0,
        setupStatus: 1, // In progress
        todayUiStatus: 'جميع الوجبات يديرها المسؤول',
        todayFilledCount: 0,
        todayRequiredCount: 0,
      );

      await tester.pumpWidget(buildTestCard(member: member));
      await tester.pumpAndSettle();

      // Display name
      expect(find.text('yahya'), findsOneWidget);

      // Role badge for manager: "مدير العائلة"
      expect(find.text('مدير العائلة'), findsOneWidget);

      // Status label: "قيد الإعداد"
      expect(find.text('قيد الإعداد'), findsOneWidget);

      // Program name
      expect(find.text('كيتو'), findsOneWidget);

      // No fake 4 meals or 7 days
      expect(find.textContaining('4 وجبات'), findsNothing);
      expect(find.textContaining('7 أيام'), findsNothing);

      // Shows unassigned / no plan notice
      expect(find.text('لم يتم اختيار النظام'), findsOneWidget);

      // Management note
      expect(find.text('جميع الوجبات يديرها المسؤول'), findsOneWidget);
    },
  );

  testWidgets(
    'FamilyMembersListCard displays active subscription metrics and triggers onTap',
    (tester) async {
      bool tapped = false;
      const member = FamilyMemberSummaryEntity(
        memberId: 'mem-2',
        displayName: 'edrtre',
        role: 2, // Member
        ageYears: 28,
        isPaused: false,
        subscriptionId: 'sub-edrtre',
        programName: 'نمط حياة متوازن',
        remainingDays: 31,
        setupStatus: 3, // Active
        todayUiStatus: 'تم تخصيص بعض الوجبات',
        todayFilledCount: 2,
        todayRequiredCount: 4,
      );

      await tester.pumpWidget(
        buildTestCard(member: member, onTap: () => tapped = true),
      );
      await tester.pumpAndSettle();

      // Display name and age
      expect(find.text('edrtre'), findsOneWidget);
      expect(find.text('• 28 سنة'), findsOneWidget);

      // Role badge for active member: "لديه حساب"
      expect(find.text('لديه حساب'), findsOneWidget);

      // Status: "نشط"
      expect(find.text('نشط'), findsOneWidget);

      // Program name
      expect(find.text('نمط حياة متوازن'), findsOneWidget);

      // Real meals count (4 وجبات) and remaining days (متبقي 31 أيام)
      expect(find.textContaining('4 وجبات'), findsOneWidget);
      expect(find.textContaining('31'), findsOneWidget);

      // Note
      expect(find.text('تم تخصيص بعض الوجبات'), findsOneWidget);

      // Test tap interaction
      await tester.tap(find.byType(FamilyMembersListCard));
      expect(tapped, isTrue);
    },
  );
}
