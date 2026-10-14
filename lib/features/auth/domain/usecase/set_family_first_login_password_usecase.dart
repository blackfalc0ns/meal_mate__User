import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/session_persistence.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_set_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class SetFamilyFirstLoginPasswordUseCase {
  const SetFamilyFirstLoginPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<LoginEntity>> call(
    FamilyFirstLoginSetPasswordRequestEntity request, {
    SessionPersistence persistence = SessionPersistence.currentRun,
  }) {
    return _repository.setFamilyFirstLoginPassword(
      request,
      persistence: persistence,
    );
  }
}
