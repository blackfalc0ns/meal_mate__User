import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';

@injectable
class GetFamilyMemberAccessUseCase {
  const GetFamilyMemberAccessUseCase(this._repository);

  final FamilyMemberRepository _repository;

  Future<ApiResult<FamilyMemberAccessEntity>> call(String memberId) {
    return _repository.getMemberAccess(memberId);
  }
}
