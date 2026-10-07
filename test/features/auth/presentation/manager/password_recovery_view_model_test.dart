import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/resend_password_otp_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/reset_password_usecase.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_view_model.dart';

class _FakeForgotPasswordUseCase extends Fake implements ForgotPasswordUseCase {
  int callCount = 0;
  ForgotPasswordRequestEntity? lastRequest;
  ApiResult<ForgotPasswordEntity>? stubbedResult;

  @override
  Future<ApiResult<ForgotPasswordEntity>> call(ForgotPasswordRequestEntity request) async {
    callCount++;
    lastRequest = request;
    return stubbedResult!;
  }
}

class _FakeResendPasswordOtpUseCase extends Fake implements ResendPasswordOtpUseCase {
  int callCount = 0;
  ResendPasswordOtpRequestEntity? lastRequest;
  ApiResult<ResendPasswordOtpEntity>? stubbedResult;

  @override
  Future<ApiResult<ResendPasswordOtpEntity>> call(ResendPasswordOtpRequestEntity request) async {
    callCount++;
    lastRequest = request;
    return stubbedResult!;
  }
}

class _FakeResetPasswordUseCase extends Fake implements ResetPasswordUseCase {
  int callCount = 0;
  ResetPasswordRequestEntity? lastRequest;
  ApiResult<ResetPasswordEntity>? stubbedResult;

  @override
  Future<ApiResult<ResetPasswordEntity>> call(ResetPasswordRequestEntity request) async {
    callCount++;
    lastRequest = request;
    return stubbedResult!;
  }
}

class _FakeTokenService extends Fake implements TokenService {
  int deleteBiometricCalls = 0;

  @override
  Future<void> deleteBiometricCredentials() async {
    deleteBiometricCalls++;
  }
}

void main() {
  late _FakeForgotPasswordUseCase fakeForgotPasswordUseCase;
  late _FakeResendPasswordOtpUseCase fakeResendPasswordOtpUseCase;
  late _FakeResetPasswordUseCase fakeResetPasswordUseCase;
  late _FakeTokenService fakeTokenService;
  late PasswordRecoveryViewModel viewModel;

  setUp(() {
    fakeForgotPasswordUseCase = _FakeForgotPasswordUseCase();
    fakeResendPasswordOtpUseCase = _FakeResendPasswordOtpUseCase();
    fakeResetPasswordUseCase = _FakeResetPasswordUseCase();
    fakeTokenService = _FakeTokenService();
    viewModel = PasswordRecoveryViewModel(
      fakeForgotPasswordUseCase,
      fakeResendPasswordOtpUseCase,
      fakeResetPasswordUseCase,
      fakeTokenService,
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  test('RequestRecoveryOtpEvent snapshots phone and countryCode, emits otpSentSuccess', () async {
    fakeForgotPasswordUseCase.stubbedResult = const ApiSuccessResult(
      data: ForgotPasswordEntity(
        success: true,
        otpSent: true,
        nextStep: 'verifyOtp',
        phone: '+96512345678',
        countryCode: 'KW',
      ),
    );

    final expectation = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<PasswordRecoveryState>((s) => s.isLoading && s.snapshotPhone == '+96512345678'),
        predicate<PasswordRecoveryState>((s) =>
            !s.isLoading &&
            s.outcome == PasswordRecoveryOutcome.otpSentSuccess &&
            s.hasActiveRecovery),
      ]),
    );

    viewModel.doIntent(const RequestRecoveryOtpEvent(
      phone: '+96512345678',
      countryCode: 'KW',
    ));
    await expectation;

    expect(fakeForgotPasswordUseCase.callCount, 1);
  });

  test('SaveRecoveryOtpEvent saves OTP in state and emits otpCodeReady', () {
    viewModel.doIntent(const SaveRecoveryOtpEvent('654321'));

    expect(viewModel.state.otpCode, '654321');
    expect(viewModel.state.outcome, PasswordRecoveryOutcome.otpCodeReady);
  });

  test('SubmitResetPasswordEvent resets password and invalidates biometric credentials', () async {
    // Prime recovery snapshot and otp
    fakeForgotPasswordUseCase.stubbedResult = const ApiSuccessResult(
      data: ForgotPasswordEntity(
        success: true,
        otpSent: true,
        nextStep: 'verify',
        phone: '+96512345678',
        countryCode: 'KW',
      ),
    );
    viewModel.doIntent(const RequestRecoveryOtpEvent(phone: '+96512345678', countryCode: 'KW'));
    await Future<void>.delayed(Duration.zero);

    viewModel.doIntent(const SaveRecoveryOtpEvent('112233'));

    fakeResetPasswordUseCase.stubbedResult = const ApiSuccessResult(
      data: ResetPasswordEntity(success: true, passwordReset: true, nextStep: 'login'),
    );

    final expectation = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<PasswordRecoveryState>((s) => s.isLoading),
        predicate<PasswordRecoveryState>((s) =>
            !s.isLoading &&
            s.outcome == PasswordRecoveryOutcome.resetSuccess &&
            s.otpCode == null),
      ]),
    );

    viewModel.doIntent(const SubmitResetPasswordEvent(newPassword: 'BrandNewPassword123!'));
    await expectation;

    expect(fakeResetPasswordUseCase.callCount, 1);
    expect(fakeResetPasswordUseCase.lastRequest?.phone, '+96512345678');
    expect(fakeResetPasswordUseCase.lastRequest?.otpCode, '112233');
    expect(fakeResetPasswordUseCase.lastRequest?.newPassword, 'BrandNewPassword123!');
    expect(fakeResetPasswordUseCase.lastRequest?.countryCode, 'KW');
    // Spec: Invalidate old biometric credentials upon password reset
    expect(fakeTokenService.deleteBiometricCalls, 1);
  });

  test('SubmitResetPasswordEvent without active recovery or OTP emits failure', () async {
    final expectation = expectLater(
      viewModel.stream,
      emits(predicate<PasswordRecoveryState>((s) => s.outcome == PasswordRecoveryOutcome.failure)),
    );

    viewModel.doIntent(const SubmitResetPasswordEvent(newPassword: 'Password123'));
    await expectation;

    expect(fakeResetPasswordUseCase.callCount, 0);
  });

  test('ResendRecoveryOtpEvent uses snapshot phone and countryCode', () async {
    fakeForgotPasswordUseCase.stubbedResult = const ApiSuccessResult(
      data: ForgotPasswordEntity(
        success: true,
        otpSent: true,
        nextStep: 'verify',
        phone: '+96512345678',
        countryCode: 'KW',
      ),
    );
    viewModel.doIntent(const RequestRecoveryOtpEvent(phone: '+96512345678', countryCode: 'KW'));
    await Future<void>.delayed(Duration.zero);

    fakeResendPasswordOtpUseCase.stubbedResult = const ApiSuccessResult(
      data: ResendPasswordOtpEntity(success: true, otpSent: true, nextStep: 'verify'),
    );

    final expectation = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<PasswordRecoveryState>((s) => s.isResending),
        predicate<PasswordRecoveryState>((s) => !s.isResending && s.resendOtpSent),
      ]),
    );

    viewModel.doIntent(const ResendRecoveryOtpEvent());
    await expectation;

    expect(fakeResendPasswordOtpUseCase.callCount, 1);
    expect(fakeResendPasswordOtpUseCase.lastRequest?.phone, '+96512345678');
    expect(fakeResendPasswordOtpUseCase.lastRequest?.countryCode, 'KW');
  });

  test('ResetRecoveryFlowEvent clears state and snapshots', () async {
    fakeForgotPasswordUseCase.stubbedResult = const ApiSuccessResult(
      data: ForgotPasswordEntity(
        success: true,
        otpSent: true,
        nextStep: 'verify',
        phone: '+96512345678',
        countryCode: 'KW',
      ),
    );
    viewModel.doIntent(const RequestRecoveryOtpEvent(phone: '+96512345678', countryCode: 'KW'));
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.state.hasActiveRecovery, isTrue);

    viewModel.doIntent(const ResetRecoveryFlowEvent());

    expect(viewModel.state.hasActiveRecovery, isFalse);
    expect(viewModel.state.snapshotPhone, isNull);
    expect(viewModel.state.outcome, PasswordRecoveryOutcome.idle);
  });
}
