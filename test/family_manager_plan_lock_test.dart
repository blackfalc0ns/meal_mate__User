import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

void main() {
  const manager = FamilyMemberEntity(
    memberId: 'manager',
    role: 1,
    displayName: 'Manager',
    relationshipCode: 'self',
    gender: 1,
    ageYears: 30,
    setupStatus: 1,
    includeFriday: false,
    isCurrentUser: true,
  );

  tearDown(FamilyConversionDraftSession.clearConvertedFamilyDraft);

  test('stale conversion session does not lock a new unpaid manager', () {
    FamilyConversionDraftSession.markConvertedFamilyDraft();
    const state = FamilyPackageDaysState(
      currentFlow: FamilyFlowCurrentEntity(
        status: 1,
        managerPrepaid: false,
        members: [manager],
      ),
    );

    expect(state.isSelectedManagerPlanLocked, isFalse);
  });

  test('server prepaid flag still locks the selected manager', () {
    const state = FamilyPackageDaysState(
      currentFlow: FamilyFlowCurrentEntity(
        status: 1,
        managerPrepaid: true,
        members: [manager],
      ),
    );

    expect(state.isSelectedManagerPlanLocked, isTrue);
  });
}
