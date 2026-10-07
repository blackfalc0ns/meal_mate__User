import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';

sealed class RegisterEvent {
  const RegisterEvent();
}

class SubmitRegisterEvent extends RegisterEvent {
  const SubmitRegisterEvent(this.request);
  final RegisterRequestEntity request;
}

class VerifyRegisterPhoneEvent extends RegisterEvent {
  const VerifyRegisterPhoneEvent(this.code);
  final String code;
}

class ResendRegisterOtpEvent extends RegisterEvent {
  const ResendRegisterOtpEvent();
}

class ClearRegisterFeedbackEvent extends RegisterEvent {
  const ClearRegisterFeedbackEvent();
}

class ResetRegisterFlowEvent extends RegisterEvent {
  const ResetRegisterFlowEvent();
}
