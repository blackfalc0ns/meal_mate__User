import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';

@injectable
class UpdateFamilyMemberAccessUseCase {
  const UpdateFamilyMemberAccessUseCase(this._repository);

  final FamilyMemberRepository _repository;

  Future<ApiResult<FamilyMemberAccessEntity>> call(
    String memberId,
    UpdateFamilyMemberAccessRequestDto request,
  ) {
    return _repository.updateMemberAccess(memberId, request);
  }
}
