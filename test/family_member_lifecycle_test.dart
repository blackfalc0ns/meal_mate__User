import 'support/family_member_view_model_factory.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';

class _PendingAccess implements GetFamilyMemberAccessUseCase {
  final result = Completer<ApiResult<FamilyMemberAccessEntity>>();
  @override
  Future<ApiResult<FamilyMemberAccessEntity>> call(String memberId) =>
      result.future;
}

void main() {
  test('access response after closing does not emit or throw', () async {
    final useCase = _PendingAccess();
    final vm = createFamilyMemberViewModel(null, useCase);
    vm.doIntent(const LoadFamilyMemberAccessEvent('member'));
    expect(vm.state.isLoadingAccess, isTrue);
    await vm.close();
    useCase.result.complete(
      const ApiSuccessResult(
        data: FamilyMemberAccessEntity(
          memberId: 'member',
          hasSeparateAccount: true,
          isPaused: false,
          hasExistingLogin: true,
        ),
      ),
    );
    await pumpEventQueue();
    expect(vm.isClosed, isTrue);
  });
}
