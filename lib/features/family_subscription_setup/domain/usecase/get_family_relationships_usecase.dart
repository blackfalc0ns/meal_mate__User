import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';

@injectable
class GetFamilyRelationshipsUseCase {
  GetFamilyRelationshipsUseCase(this._repository);

  final FamilySubscriptionSetupRepository _repository;

  Future<ApiResult<List<FamilyRelationshipEntity>>> call() {
    return _repository.getFamilyRelationships();
  }
}
