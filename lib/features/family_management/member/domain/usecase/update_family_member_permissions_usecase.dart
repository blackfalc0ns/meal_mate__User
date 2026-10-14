import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';

@injectable
class UpdateFamilyMemberPermissionsUseCase {
  const UpdateFamilyMemberPermissionsUseCase(this._repository);

  final FamilyMemberRepository _repository;

  Future<ApiResult<FamilyMemberPermissionsEntity>> call(
    String memberId,
    UpdateFamilyMemberPermissionsRequestDto request, {
    String locale = 'ar',
  }) {
    return _repository.updateMemberPermissions(
      memberId,
      request,
      locale: locale,
    );
  }
}
