import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/family_management_repository.dart';

@injectable
class ManageFamilyMemberAccessUseCase {
  const ManageFamilyMemberAccessUseCase(this._repository);
  final FamilyManagementRepository _repository;
  Future<ApiResult<FamilyMemberAccessEntityV2>> get(String memberId) =>
      _repository.getAccess(memberId);
  Future<ApiResult<FamilyMemberAccessEntityV2>> update({
    required String memberId,
    bool? hasSeparateAccount,
    bool? isPaused,
    bool? remove,
    int? expectedVersion,
  }) => _repository.updateAccess(
    memberId: memberId,
    hasSeparateAccount: hasSeparateAccount,
    isPaused: isPaused,
    remove: remove,
    expectedVersion: expectedVersion,
  );
}
