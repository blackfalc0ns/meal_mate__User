import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class ResendPasswordOtpUseCase {
  ResendPasswordOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<ResendPasswordOtpEntity>> call(
    ResendPasswordOtpRequestEntity request,
  ) {
    return _repository.resendPasswordOtp(request);
  }
}
