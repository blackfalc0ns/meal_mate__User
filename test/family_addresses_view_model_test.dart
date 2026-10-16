import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_event.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

void main() {
  test('add-on address step includes only the requested member', () async {
    const active = FamilyMemberEntity(
      memberId: 'active',
      memberSubscriptionId: 'subscription-1',
      role: 1,
      displayName: 'Active',
      relationshipCode: 'self',
      gender: 1,
      ageYears: 40,
      setupStatus: 2,
      includeFriday: false,
      isCurrentUser: true,
    );
    const added = FamilyMemberEntity(
      memberId: 'added',
      role: 2,
      displayName: 'Added',
      relationshipCode: 'child',
      gender: 1,
      ageYears: 12,
      setupStatus: 1,
      includeFriday: false,
      isCurrentUser: false,
    );
    final viewModel = FamilyAddressesViewModel(
      GetFamilyFlowCurrentUseCase(
        _FamilyFlowRepository(
          const FamilyFlowCurrentEntity(members: [active, added]),
        ),
      ),
    );

    await viewModel.load(memberId: 'added');

    expect(viewModel.state.members, [added]);
    expect(viewModel.state.currentMember, same(added));
    await viewModel.close();
  });

  test(
    'keeps every family member visible and marks saved addresses completed',
    () async {
      const savedMember = FamilyMemberEntity(
        memberId: 'saved-member',
        role: 1,
        displayName: 'Saved',
        relationshipCode: 'SELF',
        gender: 1,
        ageYears: 30,
        deliveryAddressId: 'address-1',
        setupStatus: 1,
        includeFriday: false,
        isCurrentUser: true,
      );
      const pendingMember = FamilyMemberEntity(
        memberId: 'pending-member',
        role: 2,
        displayName: 'Pending',
        relationshipCode: 'CHILD',
        gender: 1,
        ageYears: 12,
        setupStatus: 1,
        includeFriday: false,
        isCurrentUser: false,
      );
      final viewModel = FamilyAddressesViewModel(
        GetFamilyFlowCurrentUseCase(
          _FamilyFlowRepository(
            const FamilyFlowCurrentEntity(
              members: [savedMember, pendingMember],
            ),
          ),
        ),
      );

      await viewModel.load();

      expect(viewModel.state.members, [savedMember, pendingMember]);
      expect(viewModel.state.completedMemberIds, {'saved-member'});
      expect(viewModel.state.currentMember, same(pendingMember));
      await viewModel.close();
    },
  );

  test('revisited completed address flow waits for an explicit save', () async {
    const member = FamilyMemberEntity(
      memberId: 'member-1',
      role: 1,
      displayName: 'Member',
      relationshipCode: 'SELF',
      gender: 1,
      ageYears: 30,
      deliveryAddressId: 'address-1',
      setupStatus: 1,
      includeFriday: false,
      isCurrentUser: true,
    );
    final repository = _FamilyFlowRepository(
      const FamilyFlowCurrentEntity(members: [member]),
    );
    final viewModel = FamilyAddressesViewModel(
      GetFamilyFlowCurrentUseCase(repository),
    );

    await viewModel.load();

    expect(viewModel.state.completed, isFalse);
    expect(viewModel.state.currentMember, same(member));

    viewModel.addressSaved();

    expect(viewModel.state.completed, isTrue);
    expect(viewModel.state.addressSaveRevision, 1);

    viewModel.addressSaved();

    expect(viewModel.state.addressSaveRevision, 2);
    await viewModel.close();
  });

  test('loads the family name and switches to the selected member', () async {
    const firstMember = FamilyMemberEntity(
      memberId: 'member-1',
      role: 1,
      displayName: 'First',
      relationshipCode: 'SELF',
      gender: 1,
      ageYears: 30,
      setupStatus: 1,
      includeFriday: false,
      isCurrentUser: true,
    );
    const secondMember = FamilyMemberEntity(
      memberId: 'member-2',
      role: 2,
      displayName: 'Second',
      relationshipCode: 'CHILD',
      gender: 1,
      ageYears: 12,
      setupStatus: 1,
      includeFriday: false,
      isCurrentUser: false,
    );
    final viewModel = FamilyAddressesViewModel(
      GetFamilyFlowCurrentUseCase(
        _FamilyFlowRepository(
          const FamilyFlowCurrentEntity(
            name: 'My family',
            members: [firstMember, secondMember],
          ),
        ),
      ),
    );

    await viewModel.load();
    viewModel.selectMember(1);

    expect(viewModel.state.familyName, 'My family');
    expect(viewModel.state.currentMember, same(secondMember));
    await viewModel.close();
  });

  test(
    'saving the last selected member does not skip earlier members',
    () async {
      const firstMember = FamilyMemberEntity(
        memberId: 'member-1',
        role: 1,
        displayName: 'First',
        relationshipCode: 'SELF',
        gender: 1,
        ageYears: 30,
        setupStatus: 1,
        includeFriday: false,
        isCurrentUser: true,
      );
      const secondMember = FamilyMemberEntity(
        memberId: 'member-2',
        role: 2,
        displayName: 'Second',
        relationshipCode: 'CHILD',
        gender: 1,
        ageYears: 12,
        setupStatus: 1,
        includeFriday: false,
        isCurrentUser: false,
      );
      final viewModel = FamilyAddressesViewModel(
        GetFamilyFlowCurrentUseCase(
          _FamilyFlowRepository(
            const FamilyFlowCurrentEntity(members: [firstMember, secondMember]),
          ),
        ),
      );

      await viewModel.load();
      viewModel.selectMember(1);
      viewModel.addressSaved();

      expect(viewModel.state.completed, isFalse);
      expect(viewModel.state.currentMember, same(firstMember));

      viewModel.addressSaved();
      expect(viewModel.state.completed, isTrue);
      await viewModel.close();
    },
  );

  test('duplicate save does not emit when the address is identical', () async {
    const dummyAddress = CustomerAddressEntity(
      addressId: 'addr-1',
      label: 'Home',
      addressLine: 'Street 1',
      latitude: 29.3,
      longitude: 47.9,
      isDefault: true,
      notifyOnDelivery: false,
    );
    const member = FamilyMemberEntity(
      memberId: 'member-1',
      role: 1,
      displayName: 'Member',
      relationshipCode: 'SELF',
      gender: 1,
      ageYears: 30,
      setupStatus: 1,
      includeFriday: false,
      isCurrentUser: true,
    );
    final viewModel = FamilyAddressesViewModel(
      GetFamilyFlowCurrentUseCase(
        _FamilyFlowRepository(const FamilyFlowCurrentEntity(members: [member])),
      ),
    );

    await viewModel.load();
    expect(viewModel.state.addressSaveRevision, 0);

    // First save: updates address and emits revision 1
    viewModel.addressSaved(memberId: 'member-1', savedAddress: dummyAddress);
    expect(viewModel.state.addressSaveRevision, 1);
    expect(viewModel.state.members[0].deliveryAddressId, 'addr-1');

    // Duplicate save with exact same address: should NOT emit or increment revision
    viewModel.addressSaved(memberId: 'member-1', savedAddress: dummyAddress);
    expect(viewModel.state.addressSaveRevision, 1);

    await viewModel.close();
  });

  test(
    'currentMember handles empty, valid, and out-of-bounds indices',
    () async {
      const member = FamilyMemberEntity(
        memberId: 'member-1',
        role: 1,
        displayName: 'Member',
        relationshipCode: 'SELF',
        gender: 1,
        ageYears: 30,
        setupStatus: 1,
        includeFriday: false,
        isCurrentUser: true,
      );
      final viewModel = FamilyAddressesViewModel(
        GetFamilyFlowCurrentUseCase(
          _FamilyFlowRepository(
            const FamilyFlowCurrentEntity(members: [member]),
          ),
        ),
      );

      expect(viewModel.state.currentMember, isNull);

      await viewModel.load();
      expect(viewModel.state.currentMember, same(member));

      // Artificially out of bounds state
      final outOfBoundsState = viewModel.state.copyWith(currentIndex: 99);
      expect(outOfBoundsState.currentMember, isNull);

      final negativeIndexState = viewModel.state.copyWith(currentIndex: -1);
      expect(negativeIndexState.currentMember, isNull);

      await viewModel.close();
    },
  );

  test('invalid index selection does not emit or change state', () async {
    const member1 = FamilyMemberEntity(
      memberId: 'member-1',
      role: 1,
      displayName: 'One',
      relationshipCode: 'SELF',
      gender: 1,
      ageYears: 30,
      setupStatus: 1,
      includeFriday: false,
      isCurrentUser: true,
    );
    const member2 = FamilyMemberEntity(
      memberId: 'member-2',
      role: 2,
      displayName: 'Two',
      relationshipCode: 'CHILD',
      gender: 1,
      ageYears: 10,
      setupStatus: 1,
      includeFriday: false,
      isCurrentUser: false,
    );
    final viewModel = FamilyAddressesViewModel(
      GetFamilyFlowCurrentUseCase(
        _FamilyFlowRepository(
          const FamilyFlowCurrentEntity(members: [member1, member2]),
        ),
      ),
    );

    await viewModel.load();
    expect(viewModel.state.currentIndex, 0);

    // Negative index: ignored
    viewModel.selectMember(-1);
    expect(viewModel.state.currentIndex, 0);

    // Out of bounds index: ignored
    viewModel.selectMember(5);
    expect(viewModel.state.currentIndex, 0);

    // Same index: ignored
    viewModel.selectMember(0);
    expect(viewModel.state.currentIndex, 0);

    await viewModel.close();
  });

  test(
    'stale load response is ignored when a newer load completes first',
    () async {
      const initialMember = FamilyMemberEntity(
        memberId: 'initial',
        role: 1,
        displayName: 'Initial',
        relationshipCode: 'SELF',
        gender: 1,
        ageYears: 30,
        setupStatus: 1,
        includeFriday: false,
        isCurrentUser: true,
      );
      const newerMember = FamilyMemberEntity(
        memberId: 'newer',
        role: 1,
        displayName: 'Newer',
        relationshipCode: 'SELF',
        gender: 1,
        ageYears: 35,
        setupStatus: 1,
        includeFriday: false,
        isCurrentUser: true,
      );

      final delayedRepo = _DelayedFamilyFlowRepository();
      final viewModel = FamilyAddressesViewModel(
        GetFamilyFlowCurrentUseCase(delayedRepo),
      );

      // Start first load (will be delayed)
      final firstLoadFuture = viewModel.load();

      // Start second load immediately with different data (completes first)
      delayedRepo.completeSecond(
        const FamilyFlowCurrentEntity(
          name: 'New Family',
          members: [newerMember],
        ),
      );
      final secondLoadFuture = viewModel.load();
      await secondLoadFuture;

      expect(viewModel.state.familyName, 'New Family');
      expect(viewModel.state.members, [newerMember]);

      // Now resolve the first delayed load with stale data
      delayedRepo.completeFirst(
        const FamilyFlowCurrentEntity(
          name: 'Old Family',
          members: [initialMember],
        ),
      );
      await firstLoadFuture;

      // State MUST NOT have been overwritten by the stale first load
      expect(viewModel.state.familyName, 'New Family');
      expect(viewModel.state.members, [newerMember]);

      await viewModel.close();
    },
  );

  test('doIntent dispatches all FamilyAddressesEvent types correctly', () async {
    const member1 = FamilyMemberEntity(
      memberId: 'member-1',
      role: 1,
      displayName: 'First',
      relationshipCode: 'SELF',
      gender: 1,
      ageYears: 30,
      setupStatus: 1,
      includeFriday: false,
      isCurrentUser: true,
    );
    const member2 = FamilyMemberEntity(
      memberId: 'member-2',
      role: 2,
      displayName: 'Second',
      relationshipCode: 'CHILD',
      gender: 1,
      ageYears: 10,
      setupStatus: 1,
      includeFriday: false,
      isCurrentUser: false,
    );
    final viewModel = FamilyAddressesViewModel(
      GetFamilyFlowCurrentUseCase(
        _FamilyFlowRepository(
          const FamilyFlowCurrentEntity(members: [member1, member2]),
        ),
      ),
    );

    // 1. LoadFamilyAddressesEvent
    viewModel.doIntent(const LoadFamilyAddressesEvent());
    await pumpEventQueue();
    expect(viewModel.state.members.length, 2);
    expect(viewModel.state.currentIndex, 0);

    // 2. SelectFamilyAddressMemberEvent
    viewModel.doIntent(const SelectFamilyAddressMemberEvent(1));
    expect(viewModel.state.currentIndex, 1);

    // 3. SaveFamilyMemberAddressEvent
    viewModel.doIntent(
      const SaveFamilyMemberAddressEvent(
        memberId: 'member-2',
        savedAddress: CustomerAddressEntity(
          addressId: 'addr-2',
          label: 'School',
          addressLine: 'Street 2',
          latitude: 29.3,
          longitude: 47.9,
          isDefault: false,
          notifyOnDelivery: false,
        ),
      ),
    );
    expect(viewModel.state.completedMemberIds, contains('member-2'));

    // Save for member 1 to complete all
    viewModel.doIntent(
      const SaveFamilyMemberAddressEvent(
        memberId: 'member-1',
        savedAddress: CustomerAddressEntity(
          addressId: 'addr-1',
          label: 'Home',
          addressLine: 'Street 1',
          latitude: 29.3,
          longitude: 47.9,
          isDefault: true,
          notifyOnDelivery: false,
        ),
      ),
    );
    expect(viewModel.state.completed, isTrue);

    // 4. ProceedToNextAddressStepEvent
    final prevRev = viewModel.state.addressSaveRevision;
    viewModel.doIntent(const ProceedToNextAddressStepEvent());
    expect(viewModel.state.addressSaveRevision, prevRev + 1);

    await viewModel.close();
  });
}

class _FamilyFlowRepository implements FamilySubscriptionSetupRepository {
  _FamilyFlowRepository(this.flow);

  final FamilyFlowCurrentEntity flow;

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>>
  getFamilySubscriptionCurrent() async {
    return ApiSuccessResult(data: flow);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DelayedFamilyFlowRepository
    implements FamilySubscriptionSetupRepository {
  final Completer<ApiResult<FamilyFlowCurrentEntity>> _firstCompleter =
      Completer();
  final Completer<ApiResult<FamilyFlowCurrentEntity>> _secondCompleter =
      Completer();
  var _callCount = 0;

  void completeFirst(FamilyFlowCurrentEntity flow) {
    if (!_firstCompleter.isCompleted) {
      _firstCompleter.complete(ApiSuccessResult(data: flow));
    }
  }

  void completeSecond(FamilyFlowCurrentEntity flow) {
    if (!_secondCompleter.isCompleted) {
      _secondCompleter.complete(ApiSuccessResult(data: flow));
    }
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> getFamilySubscriptionCurrent() {
    _callCount++;
    if (_callCount == 1) {
      return _firstCompleter.future;
    }
    return _secondCompleter.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
