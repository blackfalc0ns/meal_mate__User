import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_subscription_repository.dart';

@injectable
class GetFamilyProgramsUseCase {
  GetFamilyProgramsUseCase(this._repository);

  final FamilySubscriptionRepository _repository;

  Future<ApiResult<List<SubscriptionProgramEntity>>> call() {
    return _repository.getFamilyPrograms();
  }
}
