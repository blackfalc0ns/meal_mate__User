import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/repo/subscription_programs_repository.dart';

@injectable
class GetSubscriptionProgramBundlesUseCase {
  GetSubscriptionProgramBundlesUseCase(this._repository);

  final SubscriptionProgramsRepository _repository;

  Future<ApiResult<List<SubscriptionBundleEntity>>> call(String programId) {
    return _repository.getSubscriptionProgramBundles(programId);
  }
}
