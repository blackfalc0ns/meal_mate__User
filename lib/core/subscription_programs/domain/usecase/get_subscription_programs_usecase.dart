import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/repo/subscription_programs_repository.dart';

@injectable
class GetSubscriptionProgramsUseCase {
  GetSubscriptionProgramsUseCase(this._repository);

  final SubscriptionProgramsRepository _repository;

  Future<ApiResult<List<SubscriptionProgramEntity>>> call() {
    return _repository.getSubscriptionPrograms();
  }
}
