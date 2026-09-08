import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

void main() {
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
