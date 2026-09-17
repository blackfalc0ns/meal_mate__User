import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

void main() {
  FamilyMemberEntity member({
    String? subscriptionId,
    String? programId = 'program',
    String? bundleId = 'bundle',
    int? tier = 1,
    int? duration = 26,
  }) => FamilyMemberEntity(
    memberId: 'member',
    memberSubscriptionId: subscriptionId,
    role: 2,
    displayName: 'Member',
    relationshipCode: 'other',
    gender: 1,
    ageYears: 20,
    setupStatus: 1,
    programId: programId,
    bundleId: bundleId,
    selectedTier: tier,
    durationDays: duration,
    includeFriday: false,
    isCurrentUser: false,
  );

  test('only complete unpaid plans enter the checkout basket', () {
    expect(member().isInCheckoutBasket, isTrue);
    expect(member().isReady, isFalse);
    expect(member(subscriptionId: 'subscription').isInCheckoutBasket, isFalse);
    expect(member(bundleId: null).isInCheckoutBasket, isFalse);
    expect(member(duration: 0).isInCheckoutBasket, isFalse);
  });
}
