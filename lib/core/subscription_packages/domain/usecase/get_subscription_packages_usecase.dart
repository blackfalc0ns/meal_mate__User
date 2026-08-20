import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/repo/subscription_packages_repository.dart';

@injectable
class GetSubscriptionPackagesUseCase {
  GetSubscriptionPackagesUseCase(this._repository);

  final SubscriptionPackagesRepository _repository;

  Future<ApiResult<List<SubscriptionBundleEntity>>> call(String programId) {
    return _repository.getSubscriptionPackages(programId);
  }
}
