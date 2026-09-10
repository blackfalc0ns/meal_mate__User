import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/family_management_repository.dart';

@injectable
class GetFamilyHomeUseCase {
  const GetFamilyHomeUseCase(this._repository);
  final FamilyManagementRepository _repository;
  Future<ApiResult<FamilyHomeEntity>> call(String localeName) =>
      _repository.getHome(localeName);
}
