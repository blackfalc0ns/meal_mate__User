import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';

@injectable
class GetFamilyMemberCapabilitiesUseCase {
  const GetFamilyMemberCapabilitiesUseCase(this._repository);

  final FamilyMemberRepository _repository;

  Future<ApiResult<List<FamilyCapabilityEntity>>> call(String memberId) {
    return _repository.getMemberCapabilities(memberId);
  }
}
