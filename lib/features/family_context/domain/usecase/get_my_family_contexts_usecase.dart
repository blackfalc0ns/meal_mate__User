import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/repo/family_context_repository.dart';

@injectable
class GetMyFamilyContextsUseCase {
  const GetMyFamilyContextsUseCase(this._repository);

  final FamilyContextRepository _repository;

  Future<ApiResult<List<FamilyContextEntity>>> call() {
    return _repository.getMyFamilyContexts();
  }
}
