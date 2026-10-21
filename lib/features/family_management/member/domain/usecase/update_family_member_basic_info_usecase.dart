import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_write_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';

@injectable
class UpdateFamilyMemberBasicInfoUseCase {
  const UpdateFamilyMemberBasicInfoUseCase(this._repository);

  final FamilyMemberRepository _repository;

  Future<ApiResult<void>> call(
    String memberId,
    FamilyMemberWriteRequestEntity request,
  ) {
    return _repository.updateMemberBasicInfo(memberId, request);
  }
}
