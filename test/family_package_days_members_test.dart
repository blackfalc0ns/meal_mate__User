import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_member_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_card.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

void main() {
  testWidgets('package step shows every family member from the flow', (
    tester,
  ) async {
    final members = [
      _member('manager', 'Manager', programId: 'program'),
      _member('child', 'Child'),
      _member('subscriber', 'Subscriber', memberSubscriptionId: 'subscription'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: FamilyPackageDaysMemberSection(
            state: FamilyPlanState(
              currentFlow: FamilyFlowCurrentEntity(members: members),
            ),
            showSummary: false,
          ),
        ),
      ),
    );

    expect(find.byType(FamilyProgramMemberCard), findsNWidgets(3));
    expect(find.text('Manager'), findsOneWidget);
    expect(find.text('Child'), findsOneWidget);
    expect(find.text('Subscriber'), findsOneWidget);
  });
}

FamilyMemberEntity _member(
  String id,
  String name, {
  String? programId,
  String? memberSubscriptionId,
}) => FamilyMemberEntity(
  memberId: id,
  memberSubscriptionId: memberSubscriptionId,
  role: 2,
  displayName: name,
  relationshipCode: '',
  gender: 1,
  ageYears: 20,
  setupStatus: 1,
  programId: programId,
  includeFriday: false,
  isCurrentUser: false,
);
