import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_subscription_repository.dart';

@injectable
class GetFamilyRelationshipsUseCase {
  GetFamilyRelationshipsUseCase(this._repository);

  final FamilySubscriptionRepository _repository;

  Future<ApiResult<List<FamilyRelationshipEntity>>> call() {
    return _repository.getFamilyRelationships();
  }
}
