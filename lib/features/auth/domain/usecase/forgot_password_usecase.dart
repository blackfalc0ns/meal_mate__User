import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class ForgotPasswordUseCase {
  ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<ForgotPasswordEntity>> call(
    ForgotPasswordRequestEntity request,
  ) {
    return _repository.forgotPassword(request);
  }
}
