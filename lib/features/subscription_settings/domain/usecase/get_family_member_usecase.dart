import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/family_management_repository.dart';

@injectable
class GetFamilyMemberUseCase {
  const GetFamilyMemberUseCase(this._repository);
  final FamilyManagementRepository _repository;
  Future<ApiResult<FamilyMemberDetailEntity>> call({
    required String memberId,
    required String localeName,
  }) => _repository.getMember(memberId, localeName);
}
