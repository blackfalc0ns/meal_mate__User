import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_step_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_verify_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class VerifyFamilyFirstLoginOtpUseCase {
  const VerifyFamilyFirstLoginOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<FamilyFirstLoginStepEntity>> call(
    FamilyFirstLoginVerifyOtpRequestEntity request,
  ) {
    return _repository.verifyFamilyFirstLoginOtp(request);
  }
}
