import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/repo/family_programs_repository.dart';

@injectable
class GetFamilyProgramsUseCase {
  GetFamilyProgramsUseCase(this._repository);

  final FamilyProgramsRepository _repository;

  Future<ApiResult<List<SubscriptionProgramEntity>>> call({
    int? page,
    int? pageSize,
  }) {
    return _repository.getFamilyPrograms(page: page, pageSize: pageSize);
  }
}
