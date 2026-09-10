import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/family_management_repository.dart';

@injectable
class ManageFamilyMemberPermissionsUseCase {
  const ManageFamilyMemberPermissionsUseCase(this._repository);
  final FamilyManagementRepository _repository;
  Future<ApiResult<FamilyMemberPermissionsEntity>> get({
    required String memberId,
    required String localeName,
  }) => _repository.getPermissions(memberId, localeName);
  Future<ApiResult<FamilyMemberPermissionsEntity>> update({
    required String memberId,
    required Map<String, bool> values,
    required String localeName,
  }) => _repository.updatePermissions(
    memberId: memberId,
    values: values,
    localeName: localeName,
  );
}
