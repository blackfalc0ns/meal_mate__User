import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_types/domain/repo/subscription_types_repository.dart';

@injectable
class GetSubscriptionConversionOptionsUseCase {
  GetSubscriptionConversionOptionsUseCase(this._repository);

  final SubscriptionTypesRepository _repository;

  Future<ApiResult<void>> call() {
    return _repository.getSubscriptionConversionOptions();
  }
}
