import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class ResetPasswordUseCase {
  ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<ResetPasswordEntity>> call(
    ResetPasswordRequestEntity request,
  ) {
    return _repository.resetPassword(request);
  }
}
