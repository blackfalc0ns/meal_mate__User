import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector_skeleton.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_content.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_duration_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_package_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_plan_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_options_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_tiers_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

void main() {
  const testMember1 = FamilyMemberEntity(
    memberId: 'm-1',
    role: 1,
    displayName: 'Father',
    relationshipCode: 'self',
    gender: 1,
    ageYears: 35,
    setupStatus: 1,
    programId: 'prog-1',
    bundleId: 'bundle-1',
    includeFriday: false,
    isCurrentUser: true,
  );

  const testMember2 = FamilyMemberEntity(
    memberId: 'm-2',
    role: 2,
    displayName: 'Child',
    relationshipCode: 'child',
    gender: 2,
    ageYears: 8,
    setupStatus: 1,
    programId: 'prog-1',
    includeFriday: false,
    isCurrentUser: false,
  );

  group('FamilyPackageDays Shimmer & Loading', () {
    testWidgets(
      'when isMemberChanging is true, package, duration, and tier sections show skeletons',
      (tester) async {
        const state = FamilyPackageDaysState(
          isMemberChanging: true,
          selectedMemberIndex: 1,
          currentFlow: FamilyFlowCurrentEntity(
            members: [testMember1, testMember2],
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    FamilyPackageDaysPackageSection(state: state),
                    FamilyPackageDaysDurationSection(state: state),
                    FamilyPackageDaysPlanSection(
                      state: state,
                      onNextPressed: _dummyCallback,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(
          find.byType(FamilyPackageOptionsLoadingSkeleton),
          findsOneWidget,
        );
        expect(
          find.byType(SubscriptionDurationSelectorSkeleton),
          findsOneWidget,
        );
        expect(
          find.byType(FamilyPackageTiersLoadingSkeleton),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'CustomProgressIndicator appears in overlay when isPlanSaving is true in content stack',
      (tester) async {
        const state = FamilyPackageDaysState(
          isPlanSaving: true,
          currentFlow: FamilyFlowCurrentEntity(
            members: [testMember1],
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: Stack(
                children: [
                  const FamilyPackageDaysContent(
                    state: state,
                    onNextPressed: _dummyCallback,
                  ),
                  if (state.isPlanSaving)
                    const Positioned.fill(
                      child: Center(
                        child: CustomProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CustomProgressIndicator), findsOneWidget);
      },
    );
  });
}

void _dummyCallback() {}
