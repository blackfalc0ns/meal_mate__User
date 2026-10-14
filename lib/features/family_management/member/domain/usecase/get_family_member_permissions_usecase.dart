import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';

@injectable
class GetFamilyMemberPermissionsUseCase {
  const GetFamilyMemberPermissionsUseCase(this._repository);

  final FamilyMemberRepository _repository;

  Future<ApiResult<FamilyMemberPermissionsEntity>> call(
    String memberId, {
    String locale = 'ar',
  }) {
    return _repository.getMemberPermissions(memberId, locale: locale);
  }
}
