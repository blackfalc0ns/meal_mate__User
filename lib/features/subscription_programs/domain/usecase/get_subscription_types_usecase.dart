import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/repo/subscription_types_repository.dart';

@injectable
class GetSubscriptionTypesUseCase {
  GetSubscriptionTypesUseCase(this._repository);

  final SubscriptionTypesRepository _repository;

  Future<ApiResult<List<SubscriptionTypeEntity>>> call() {
    return _repository.getSubscriptionTypes();
  }
}
