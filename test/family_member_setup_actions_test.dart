import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

void main() {
  FamilyMemberEntity member({
    int role = 2,
    int setupStatus = 1,
    String? memberSubscriptionId,
    String? programId,
    String? bundleId,
    int? selectedTier,
    int? durationDays,
  }) => FamilyMemberEntity(
    memberId: 'member',
    memberSubscriptionId: memberSubscriptionId,
    role: role,
    displayName: 'Member',
    relationshipCode: 'spouse',
    gender: 1,
    ageYears: 22,
    setupStatus: setupStatus,
    programId: programId,
    bundleId: bundleId,
    selectedTier: selectedTier,
    durationDays: durationDays,
    includeFriday: false,
    isCurrentUser: false,
  );

  test('only an incomplete non-manager can be deleted from setup flow', () {
    expect(member().canDeleteFromSetupFlow, isTrue);
    expect(member(role: 1).canDeleteFromSetupFlow, isFalse);
    expect(member(setupStatus: 3).canDeleteFromSetupFlow, isFalse);
    expect(
      member(memberSubscriptionId: 'subscription').canDeleteFromSetupFlow,
      isFalse,
    );
    expect(
      member(
        programId: 'program',
        bundleId: 'bundle',
        selectedTier: 1,
        durationDays: 12,
      ).canDeleteFromSetupFlow,
      isFalse,
    );
  });
}
