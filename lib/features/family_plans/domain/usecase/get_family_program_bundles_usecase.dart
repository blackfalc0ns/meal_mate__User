import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_subscription_repository.dart';

@injectable
class GetFamilyProgramBundlesUseCase {
  GetFamilyProgramBundlesUseCase(this._repository);

  final FamilySubscriptionRepository _repository;

  Future<ApiResult<List<SubscriptionBundleEntity>>> call(String programId) {
    return _repository.getFamilyProgramBundles(programId);
  }
}
