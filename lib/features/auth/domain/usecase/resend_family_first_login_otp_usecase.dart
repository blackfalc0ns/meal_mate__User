import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_resend_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_step_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class ResendFamilyFirstLoginOtpUseCase {
  const ResendFamilyFirstLoginOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<FamilyFirstLoginStepEntity>> call(
    FamilyFirstLoginResendOtpRequestEntity request,
  ) {
    return _repository.resendFamilyFirstLoginOtp(request);
  }
}
