import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_content.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_member_content_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

void main() {
  testWidgets(
    'package and days keeps the family header and selected member fixed while plan data shimmers',
    (tester) async {
      const state = FamilyPlanState(
        isBundlesLoading: true,
        currentFlow: FamilyFlowCurrentEntity(
          name: 'Stable family',
          members: [
            FamilyMemberEntity(
              memberId: 'member-1',
              role: 1,
              displayName: 'Stable member',
              relationshipCode: 'self',
              gender: 1,
              ageYears: 30,
              setupStatus: 1,
              programId: 'program-1',
              includeFriday: false,
              isCurrentUser: true,
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: FamilyPackageDaysContent(
              state: state,
              onNextPressed: _doNothing,
            ),
          ),
        ),
      );

      expect(find.text('Stable family'), findsOneWidget);
      expect(find.text('Stable member'), findsNWidgets(2));
      expect(find.byType(FamilyMemberContentLoadingSkeleton), findsOneWidget);
    },
  );

  test('payment keeps members visible while selected summary shimmers', () {
    final source = File(
      'lib/features/family_checkout/presentation/widgets/'
      'family_payment_content.dart',
    ).readAsStringSync();
    final membersSource = File(
      'lib/features/family_checkout/presentation/widgets/'
      'family_payment_members_section.dart',
    ).readAsStringSync();

    expect(source, contains('FamilyPaymentMembersSection(state: state)'));
    expect(source, contains('if (state.isSummaryLoading)'));
    expect(source, contains('FamilyMemberContentLoadingSkeleton'));
    expect(membersSource, contains('onSelectMember: state.isSummaryLoading'));
    expect(membersSource, contains('? null'));
  });
}

void _doNothing() {}
