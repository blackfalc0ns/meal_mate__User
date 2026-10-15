import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_shared/presentation/manager/family_subscription_flow_state.dart';
import 'package:meal_meat_user/features/family_shared/presentation/manager/family_subscription_flow_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

class _FakeFamilySubscriptionSetupRepository
    implements FamilySubscriptionSetupRepository {
  ApiResult<FamilyFlowCurrentEntity>? currentResult;
  int currentCallCount = 0;

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>>
  getFamilySubscriptionCurrent() async {
    currentCallCount++;
    return currentResult ??
        ApiErrorResult(failure: Failure(errorMessage: 'Default error'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeFamilySubscriptionSetupRepository repository;
  late GetFamilyFlowCurrentUseCase getFamilyFlowCurrentUseCase;
  late FamilyFlowSnapshotStore snapshotStore;
  late FamilySubscriptionFlowViewModel viewModel;

  const testMember = FamilyMemberEntity(
    memberId: 'mem_1',
    role: 1,
    displayName: 'Ahmad',
    relationshipCode: 'FATHER',
    gender: 1,
    ageYears: 40,
    setupStatus: 1,
    includeFriday: false,
    isCurrentUser: true,
    subscribeNow: true,
  );

  const initialFlow = FamilyFlowCurrentEntity(
    familyGroupId: 'grp_123',
    name: 'Al-Ahmad Family',
    members: [testMember],
    minMembers: 1,
    maxMembers: 5,
  );

  setUp(() {
    repository = _FakeFamilySubscriptionSetupRepository();
    getFamilyFlowCurrentUseCase = GetFamilyFlowCurrentUseCase(repository);
    snapshotStore = FamilyFlowSnapshotStore();
    viewModel = FamilySubscriptionFlowViewModel(
      getFamilyFlowCurrentUseCase,
      snapshotStore,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  group('FamilySubscriptionFlowViewModel Coordinator Tests', () {
    test(
      '1. Cached load emits cached snapshot without calling use case',
      () async {
        snapshotStore.update(initialFlow);
        final vmWithCache = FamilySubscriptionFlowViewModel(
          getFamilyFlowCurrentUseCase,
          snapshotStore,
        );

        await vmWithCache.load(forceRefresh: false);

        expect(repository.currentCallCount, 0);
        expect(vmWithCache.state.flow?.familyGroupId, 'grp_123');
        expect(vmWithCache.state.isLoading, false);
        expect(vmWithCache.state.failure, isNull);

        vmWithCache.close();
      },
    );

    test(
      '2. Force refresh calls use case and updates snapshot store',
      () async {
        snapshotStore.update(initialFlow);
        const refreshedFlow = FamilyFlowCurrentEntity(
          familyGroupId: 'grp_123',
          name: 'Updated Family Name',
          members: [testMember],
        );
        repository.currentResult = const ApiSuccessResult(data: refreshedFlow);

        await viewModel.load(forceRefresh: true);

        expect(repository.currentCallCount, 1);
        expect(viewModel.state.flow?.name, 'Updated Family Name');
        expect(snapshotStore.current?.name, 'Updated Family Name');
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.failure, isNull);
      },
    );

    test('3. Load failure emits failure and keeps snapshot intact', () async {
      repository.currentResult = ApiErrorResult(
        failure: Failure(errorMessage: 'Network error'),
      );

      await viewModel.load(forceRefresh: true);

      expect(repository.currentCallCount, 1);
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.failure, isNotNull);
      expect(viewModel.state.failure?.errorMessage, 'Network error');
    });

    test(
      '4. updateMemberAddress updates snapshot store and emits new state',
      () {
        snapshotStore.update(initialFlow);
        viewModel = FamilySubscriptionFlowViewModel(
          getFamilyFlowCurrentUseCase,
          snapshotStore,
        );

        const newAddress = CustomerAddressEntity(
          addressId: 'addr_99',
          label: 'Home',
          addressLine: 'Main St',
          area: 'Kuwait City',
          block: '1',
          street: 'Main St',
          isDefault: false,
          notifyOnDelivery: false,
        );

        viewModel.updateMemberAddress('mem_1', newAddress);

        expect(
          snapshotStore.current?.members.first.deliveryAddressId,
          'addr_99',
        );
        expect(
          viewModel.state.flow?.members.first.deliveryAddressId,
          'addr_99',
        );
      },
    );

    test(
      '5. updateMemberAllergies updates snapshot store and emits new state',
      () {
        snapshotStore.update(initialFlow);
        viewModel = FamilySubscriptionFlowViewModel(
          getFamilyFlowCurrentUseCase,
          snapshotStore,
        );

        viewModel.updateMemberAllergies('mem_1', const [
          FamilyMemberAllergySelection(code: 'PEANUTS', severity: 'HIGH'),
        ]);

        expect(snapshotStore.current?.members.first.allergiesCompleted, true);
        expect(
          snapshotStore.current?.members.first.allergies.first.code,
          'PEANUTS',
        );
        expect(
          viewModel.state.flow?.members.first.allergies.first.code,
          'PEANUTS',
        );
      },
    );

    test('6. currentStep and targetMemberId management', () {
      expect(viewModel.state.currentStep, 0);
      expect(viewModel.state.targetMemberId, isNull);

      viewModel.setStep(2);
      expect(viewModel.state.currentStep, 2);

      viewModel.setTargetMember('mem_1');
      expect(viewModel.state.targetMemberId, 'mem_1');
    });

    test('7. Transition intent validation based on single snapshot source', () {
      snapshotStore.update(initialFlow);
      viewModel = FamilySubscriptionFlowViewModel(
        getFamilyFlowCurrentUseCase,
        snapshotStore,
      );

      // Members stage: 1 member with subscribeNow=true meets minMembers=1
      expect(viewModel.canProceedFromMembers(), true);

      // Programs stage: member has no program yet
      expect(viewModel.canProceedFromPrograms(), false);

      viewModel.updateMemberProgram('mem_1', 'prog_keto');
      expect(viewModel.canProceedFromPrograms(), true);

      // Addresses stage: member has no delivery address yet
      expect(viewModel.canProceedFromAddresses(), false);

      const address = CustomerAddressEntity(
        addressId: 'addr_1',
        label: 'Home',
        addressLine: 'Beirut St',
        area: 'Hawally',
        block: '2',
        street: 'Beirut St',
        isDefault: false,
        notifyOnDelivery: false,
      );
      viewModel.updateMemberAddress('mem_1', address);
      expect(viewModel.canProceedFromAddresses(), true);

      // Allergies stage: member has not completed allergies
      expect(viewModel.canProceedFromAllergies(), false);

      viewModel.updateMemberAllergies('mem_1', const [
        FamilyMemberAllergySelection(code: 'NONE'),
      ]);
      expect(viewModel.canProceedFromAllergies(), true);
    });

    test(
      '8. Restores step and target member from server flow on load',
      () async {
        final step2Member1 = testMember.copyWith(
          memberId: 'mem_1',
          displayName: 'Ahmad',
          programId: 'prog_1',
          deliveryAddressId: 'addr_1',
          allergiesCompleted: true,
          subscribeNow: true,
        );
        final step2Member2 = testMember.copyWith(
          memberId: 'mem_2',
          displayName: 'Sarah',
          relationshipCode: 'DAUGHTER',
          programId: 'prog_1',
          allergiesCompleted: false,
          subscribeNow: true,
        );
        final serverFlowWithStep2 = FamilyFlowCurrentEntity(
          familyGroupId: 'grp_123',
          name: 'Al-Ahmad Family',
          currentStep: 2,
          members: [step2Member1, step2Member2],
        );

        repository.currentResult = ApiSuccessResult(data: serverFlowWithStep2);

        await viewModel.load(forceRefresh: true);

        expect(viewModel.state.currentStep, 2);
        expect(viewModel.state.targetMemberId, 'mem_2');
      },
    );
  });
}
