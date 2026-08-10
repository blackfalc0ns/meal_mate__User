import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class VerifyPhoneUseCase {
  VerifyPhoneUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<VerifyPhoneEntity>> call(VerifyPhoneRequestEntity request) {
    return _repository.verifyPhone(request);
  }
}
