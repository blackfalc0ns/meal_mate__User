import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/register_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/resend_phone_otp_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/verify_phone_usecase.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_view_model.dart';

class _FakeRegisterUseCase extends Fake implements RegisterUseCase {
  int callCount = 0;
  RegisterRequestEntity? lastRequest;
  ApiResult<RegisterEntity>? stubbedResult;

  @override
  Future<ApiResult<RegisterEntity>> call(RegisterRequestEntity request) async {
    callCount++;
    lastRequest = request;
    return stubbedResult!;
  }
}

class _FakeVerifyPhoneUseCase extends Fake implements VerifyPhoneUseCase {
  int callCount = 0;
  VerifyPhoneRequestEntity? lastRequest;
  ApiResult<VerifyPhoneEntity>? stubbedResult;

  @override
  Future<ApiResult<VerifyPhoneEntity>> call(VerifyPhoneRequestEntity request) async {
    callCount++;
    lastRequest = request;
    return stubbedResult!;
  }
}

class _FakeResendPhoneOtpUseCase extends Fake implements ResendPhoneOtpUseCase {
  int callCount = 0;
  ResendPhoneOtpRequestEntity? lastRequest;
  ApiResult<ResendPhoneOtpEntity>? stubbedResult;

  @override
  Future<ApiResult<ResendPhoneOtpEntity>> call(ResendPhoneOtpRequestEntity request) async {
    callCount++;
    lastRequest = request;
    return stubbedResult!;
  }
}

VerifyPhoneEntity createTestVerifyPhoneEntity() {
  return const VerifyPhoneEntity(
    userId: 'u-1',
    email: null,
    phoneNumber: '+96512345678',
    fullName: 'Test User',
    userType: 'Customer',
    accountStatus: 'Active',
    restaurantId: null,
    roles: ['Customer'],
    permissions: [],
    accessToken: 'at',
    accessTokenExpiresAtUtc: '2026-10-07T12:00:00Z',
    refreshToken: 'rt',
    refreshTokenExpiresAtUtc: '2026-10-14T12:00:00Z',
    nextStep: 'complete',
  );
}

void main() {
  late _FakeRegisterUseCase fakeRegisterUseCase;
  late _FakeVerifyPhoneUseCase fakeVerifyPhoneUseCase;
  late _FakeResendPhoneOtpUseCase fakeResendPhoneOtpUseCase;
  late RegisterViewModel viewModel;

  setUp(() {
    fakeRegisterUseCase = _FakeRegisterUseCase();
    fakeVerifyPhoneUseCase = _FakeVerifyPhoneUseCase();
    fakeResendPhoneOtpUseCase = _FakeResendPhoneOtpUseCase();
    viewModel = RegisterViewModel(
      fakeRegisterUseCase,
      fakeVerifyPhoneUseCase,
      fakeResendPhoneOtpUseCase,
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  test('SubmitRegisterEvent stores snapshot and emits registrationSuccess when otpSent is true', () async {
    const request = RegisterRequestEntity(
      fullName: 'Ahmad User',
      phone: '+96512345678',
      password: 'secretPassword123',
      countryCode: 'KW',
    );
    const registerEntity = RegisterEntity(
      userId: 'user-123',
      phone: '+96512345678',
      otpSent: true,
      nextStep: 'verifyPhone',
    );
    fakeRegisterUseCase.stubbedResult = const ApiSuccessResult(data: registerEntity);

    final expectation = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<RegisterState>((s) => s.isLoading && s.snapshotPhone == '+96512345678'),
        predicate<RegisterState>((s) =>
            !s.isLoading &&
            s.outcome == RegisterOutcome.registrationSuccess &&
            s.userId == 'user-123' &&
            s.hasActiveVerification),
      ]),
    );

    viewModel.doIntent(const SubmitRegisterEvent(request));
    await expectation;

    expect(fakeRegisterUseCase.callCount, 1);
  });

  test('SubmitRegisterEvent with otpSent=false emits failure outcome', () async {
    const request = RegisterRequestEntity(
      fullName: 'Ahmad User',
      phone: '+96512345678',
      password: 'secretPassword123',
      countryCode: 'KW',
    );
    const registerEntity = RegisterEntity(
      userId: 'user-123',
      phone: '+96512345678',
      otpSent: false,
      nextStep: 'failed',
    );
    fakeRegisterUseCase.stubbedResult = const ApiSuccessResult(data: registerEntity);

    final expectation = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<RegisterState>((s) => s.isLoading),
        predicate<RegisterState>((s) => !s.isLoading && s.outcome == RegisterOutcome.failure),
      ]),
    );

    viewModel.doIntent(const SubmitRegisterEvent(request));
    await expectation;
  });

  test('VerifyRegisterPhoneEvent uses snapshot and code to verify phone', () async {
    // Prime the snapshot
    fakeRegisterUseCase.stubbedResult = const ApiSuccessResult(
      data: RegisterEntity(userId: 'u-1', phone: '+96512345678', otpSent: true, nextStep: 'verify'),
    );
    viewModel.doIntent(const SubmitRegisterEvent(
      RegisterRequestEntity(fullName: 'Name', phone: '+96512345678', password: 'p', countryCode: 'KW'),
    ));
    await Future<void>.delayed(Duration.zero);

    fakeVerifyPhoneUseCase.stubbedResult = ApiSuccessResult(data: createTestVerifyPhoneEntity());

    final expectation = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<RegisterState>((s) => s.isLoading),
        predicate<RegisterState>((s) => !s.isLoading && s.outcome == RegisterOutcome.phoneVerifiedSuccess),
      ]),
    );

    viewModel.doIntent(const VerifyRegisterPhoneEvent('123456'));
    await expectation;

    expect(fakeVerifyPhoneUseCase.callCount, 1);
    expect(fakeVerifyPhoneUseCase.lastRequest?.phone, '+96512345678');
    expect(fakeVerifyPhoneUseCase.lastRequest?.code, '123456');
    expect(fakeVerifyPhoneUseCase.lastRequest?.countryCode, 'KW');
  });

  test('VerifyRegisterPhoneEvent without snapshot emits failure without calling use case', () async {
    final expectation = expectLater(
      viewModel.stream,
      emits(predicate<RegisterState>((s) => s.outcome == RegisterOutcome.failure)),
    );

    viewModel.doIntent(const VerifyRegisterPhoneEvent('123456'));
    await expectation;

    expect(fakeVerifyPhoneUseCase.callCount, 0);
  });

  test('ResendRegisterOtpEvent calls use case with snapshot phone and countryCode', () async {
    fakeRegisterUseCase.stubbedResult = const ApiSuccessResult(
      data: RegisterEntity(userId: 'u-1', phone: '+96512345678', otpSent: true, nextStep: 'verify'),
    );
    viewModel.doIntent(const SubmitRegisterEvent(
      RegisterRequestEntity(fullName: 'Name', phone: '+96512345678', password: 'p', countryCode: 'KW'),
    ));
    await Future<void>.delayed(Duration.zero);

    fakeResendPhoneOtpUseCase.stubbedResult = const ApiSuccessResult(
      data: ResendPhoneOtpEntity(success: true, otpSent: true, nextStep: 'verify'),
    );

    final expectation = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<RegisterState>((s) => s.isResending),
        predicate<RegisterState>((s) => !s.isResending && s.resendOtpSent),
      ]),
    );

    viewModel.doIntent(const ResendRegisterOtpEvent());
    await expectation;

    expect(fakeResendPhoneOtpUseCase.callCount, 1);
    expect(fakeResendPhoneOtpUseCase.lastRequest?.phone, '+96512345678');
    expect(fakeResendPhoneOtpUseCase.lastRequest?.countryCode, 'KW');
  });

  test('ResetRegisterFlowEvent clears state and snapshots back to clean initial state', () async {
    fakeRegisterUseCase.stubbedResult = const ApiSuccessResult(
      data: RegisterEntity(userId: 'u-1', phone: '+96512345678', otpSent: true, nextStep: 'verify'),
    );
    viewModel.doIntent(const SubmitRegisterEvent(
      RegisterRequestEntity(fullName: 'Name', phone: '+96512345678', password: 'p', countryCode: 'KW'),
    ));
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.state.hasActiveVerification, isTrue);

    viewModel.doIntent(const ResetRegisterFlowEvent());

    expect(viewModel.state.hasActiveVerification, isFalse);
    expect(viewModel.state.snapshotPhone, isNull);
    expect(viewModel.state.outcome, RegisterOutcome.idle);
  });
}
