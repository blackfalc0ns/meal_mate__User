import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/session_persistence.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<LoginEntity>> call(
    LoginRequestEntity request, {
    SessionPersistence persistence = SessionPersistence.currentRun,
  }) {
    return _repository.login(request, persistence: persistence);
  }
}
