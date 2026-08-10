import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class LogoutUseCase {
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<LogoutEntity>> call(LogoutRequestEntity request) {
    return _repository.logout(request);
  }
}
