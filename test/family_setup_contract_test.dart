import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/mapper/family_subscription_setup_mapper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_member_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';

void main() {
  group('Family Setup Contract Acceptance Tests', () {
    test(
      'partial plan patch sends only changed fields and preserves omitted fields',
      () {
        // 1. Changing only startDate
        final startDateOnly = const FamilyMemberPlanWriteRequestDto(
          startDate: '2026-11-01',
        ).toJson();
        expect(startDateOnly, {'startDate': '2026-11-01'});
        expect(startDateOnly.containsKey('programId'), isFalse);
        expect(startDateOnly.containsKey('bundleId'), isFalse);
        expect(startDateOnly.containsKey('durationDays'), isFalse);

        // 2. Explicit clear of bundleId
        final clearBundle = const FamilyMemberPlanWriteRequestDto(
          clearBundleId: true,
        ).toJson();
        expect(clearBundle, {'bundleId': null});
        expect(clearBundle.containsKey('programId'), isFalse);

        // 3. Omits durationDays if 0 is passed (never treats 0 as valid default duration)
        final zeroDuration = const FamilyMemberPlanWriteRequestDto(
          durationDays: 0,
          includeFriday: true,
        ).toJson();
        expect(zeroDuration, {'includeFriday': true});
        expect(zeroDuration.containsKey('durationDays'), isFalse);

        // 4. Reset/clear sends all 4 pricing fields as explicit nulls
        final reset = FamilyMemberPlanWriteRequestDto.clear().toJson();
        expect(reset, {
          'programId': null,
          'bundleId': null,
          'tier': null,
          'durationDays': null,
        });
      },
    );

    test(
      'member setup state distinguishes roster count from selected new subscribers',
      () {
        final members = [
          const FamilyMemberEntity(
            memberId: 'm1',
            role: 1,
            displayName: 'Manager',
            relationshipCode: 'self',
            gender: 1,
            ageYears: 35,
            setupStatus: 2,
            programId: 'prog-1',
            bundleId: 'bundle-1',
            selectedTier: 1,
            durationDays: 26,
            includeFriday: false,
            isCurrentUser: true,
            customerUserId: 'user-manager-id',
            subscribeNow: true,
          ),
          const FamilyMemberEntity(
            memberId: 'm2',
            role: 2,
            displayName: 'Deferred Child',
            relationshipCode: 'child',
            gender: 2,
            ageYears: 10,
            setupStatus: 1,
            programId: 'prog-1',
            bundleId: 'bundle-1',
            selectedTier: 1,
            durationDays: 26,
            includeFriday: false,
            isCurrentUser: false,
            customerUserId: null,
            phoneNumber: null,
            subscribeNow: false, // Deferred from checkout
          ),
          const FamilyMemberEntity(
            memberId: 'm3',
            role: 2,
            displayName: 'Unlinked Member',
            relationshipCode: 'spouse',
            gender: 2,
            ageYears: 32,
            setupStatus: 1,
            programId: 'prog-1',
            bundleId: 'bundle-1',
            selectedTier: 2,
            durationDays: 26,
            includeFriday: false,
            isCurrentUser: false,
            customerUserId: null,
            phoneNumber: null, // No linked account
            subscribeNow: true,
          ),
        ];

        final state = FamilyPlanState(
          currentFlow: const FamilyFlowCurrentResponseDto(
            familyGroupId: 'group-1',
            name: 'Al-Family',
          ).toEntity().copyWith(members: members),
        );

        // Roster count is 3
        expect(state.rosterCount, 3);
        // Selected new subscribers count only includes members with complete unpaid plan and subscribeNow == true
        expect(state.selectedNewSubscriberCount, 2);

        // Check account linkage detection
        expect(members[0].hasLinkedAccount, isTrue);
        expect(members[1].hasLinkedAccount, isFalse);
        expect(members[2].hasLinkedAccount, isFalse);
      },
    );

    test(
      'maps FamilyFlowCurrentResponseDto with session and package fields',
      () {
        final dto = FamilyFlowCurrentResponseDto.fromJson({
          'familyGroupId': '11111111-1111-1111-1111-111111111111',
          'name': 'Test Group',
          'status': 'Draft',
          'sessionExpired': false,
          'packageAvailable': true,
          'members': [
            {
              'memberId': '22222222-2222-2222-2222-222222222222',
              'displayName': 'Test Member',
              'role': 'Member',
              'gender': 'Male',
              'ageYears': 25,
              'setupStatus': 'Ready',
              'subscribeNow': false,
              'customerUserId': '33333333-3333-3333-3333-333333333333',
              'currentSubscriptionId': '44444444-4444-4444-4444-444444444444',
              'readinessBlocker': 'family.address_required',
            },
          ],
        });

        final entity = dto.toEntity();
        expect(entity.familyGroupId, '11111111-1111-1111-1111-111111111111');
        expect(entity.packageAvailable, isTrue);
        expect(entity.members.length, 1);

        final member = entity.members.first;
        expect(member.subscribeNow, isFalse);
        expect(member.customerUserId, '33333333-3333-3333-3333-333333333333');
        expect(member.readinessBlocker, 'family.address_required');
      },
    );

    test(
      'does not auto-select InProgress members when subscribeNow is omitted',
      () {
        final inProgressDto = FamilyMemberResponseDto(
          memberId: 'mem-prog',
          displayName: 'Prog Member',
          role: 2,
          gender: 1,
          ageYears: 22,
          setupStatus: 1, // InProgress
          isCurrentUser: false,
        );
        final inProgressEntity = inProgressDto.toEntity();
        expect(inProgressEntity.subscribeNow, isFalse);
        expect(inProgressEntity.checkoutSelected, isFalse);

        final readyDto = FamilyMemberResponseDto(
          memberId: 'mem-ready',
          displayName: 'Ready Member',
          role: 2,
          gender: 1,
          ageYears: 25,
          setupStatus: 2, // Ready
          isCurrentUser: false,
        );
        final readyEntity = readyDto.toEntity();
        expect(readyEntity.subscribeNow, isFalse);
        expect(readyEntity.checkoutSelected, isFalse);

        final managerDto = FamilyMemberResponseDto(
          memberId: 'mem-mgr',
          displayName: 'Manager Member',
          role: 1, // Manager
          gender: 1,
          ageYears: 35,
          setupStatus: 1,
          isCurrentUser: true,
        );
        final managerEntity = managerDto.toEntity();
        expect(managerEntity.subscribeNow, isFalse);
        expect(managerEntity.checkoutSelected, isFalse);
      },
    );
  });
}
