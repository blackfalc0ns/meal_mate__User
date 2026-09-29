import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/repo/family_programs_repository.dart';

@injectable
class GetFamilyProgramBundlesUseCase {
  GetFamilyProgramBundlesUseCase(this._repository);

  final FamilyProgramsRepository _repository;

  Future<ApiResult<List<SubscriptionBundleEntity>>> call(String programId) {
    return _repository.getFamilyProgramBundles(programId);
  }
}
