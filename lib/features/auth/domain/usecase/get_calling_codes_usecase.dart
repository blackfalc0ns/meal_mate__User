import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class GetCallingCodesUseCase {
  GetCallingCodesUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<List<CallingCodeEntity>>> call() {
    return _repository.getCallingCodes();
  }
}
