import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/push_notification_service.dart';
import 'package:meal_meat_user/core/services/session_persistence.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:meal_meat_user/features/auth/data/models/request/family_first_login_resend_otp_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/family_first_login_set_password_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/family_first_login_verify_otp_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/login_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/family_first_login_verify_otp_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/login_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/repo/auth_repository_impl.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_resend_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_set_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_step_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_verify_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/login_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/resend_family_first_login_otp_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/set_family_first_login_password_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/verify_family_first_login_otp_usecase.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';

class _FakeAuthRemoteDataSource extends Fake implements AuthRemoteDataSource {
  LoginResponseDto? loginResponse;
  FamilyFirstLoginVerifyOtpResponseDto? verifyOtpResponse;
  LoginResponseDto? setPasswordResponse;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    return loginResponse!;
  }

  @override
  Future<FamilyFirstLoginVerifyOtpResponseDto> verifyFamilyFirstLoginOtp(
    FamilyFirstLoginVerifyOtpRequestDto request,
  ) async {
    return verifyOtpResponse!;
  }

  @override
  Future<LoginResponseDto> setFamilyFirstLoginPassword(
    FamilyFirstLoginSetPasswordRequestDto request,
  ) async {
    return setPasswordResponse!;
  }

  FamilyFirstLoginVerifyOtpResponseDto? resendOtpResponse;

  @override
  Future<FamilyFirstLoginVerifyOtpResponseDto> resendFamilyFirstLoginOtp(
    FamilyFirstLoginResendOtpRequestDto request,
  ) async {
    return resendOtpResponse!;
  }
}

class _RecordingTokenService extends Fake implements TokenService {
  int saveSessionCallCount = 0;
  String? savedUserId;
  String? savedAccessToken;
  String? savedRefreshToken;

  @override
  Future<void> saveSession({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required DateTime? accessExpiresAtUtc,
    required DateTime? refreshExpiresAtUtc,
    required SessionPersistence persistence,
  }) async {
    saveSessionCallCount++;
    savedUserId = userId;
    savedAccessToken = accessToken;
    savedRefreshToken = refreshToken;
  }
}

class _FakeSharedPrefHelper extends Fake implements SharedPrefHelper {
  @override
  Future<bool> removeData({required String key}) async => true;
}

class _FakePushNotificationService extends Fake
    implements PushNotificationService {
  int registerTokenCallCount = 0;

  @override
  Future<void> registerCurrentToken({String? token}) async {
    registerTokenCallCount++;
  }

  @override
  Future<void> unregisterCurrentToken() async {}
}

class _FakeBiometricService extends Fake implements BiometricService {
  @override
  bool isBiometricEnabled() => false;

  @override
  Future<bool> canOfferBiometricLogin() async => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeAuthRemoteDataSource remoteDataSource;
  late _RecordingTokenService tokenService;
  late _FakeSharedPrefHelper sharedPrefHelper;
  late _FakePushNotificationService pushNotificationService;
  late FamilyFlowSnapshotStore familyFlowSnapshotStore;
  late AuthRepositoryImpl repository;
  late LoginUseCase loginUseCase;
  late VerifyFamilyFirstLoginOtpUseCase verifyOtpUseCase;
  late SetFamilyFirstLoginPasswordUseCase setPasswordUseCase;
  late ResendFamilyFirstLoginOtpUseCase resendOtpUseCase;
  late _FakeBiometricService biometricService;

  setUp(() {
    remoteDataSource = _FakeAuthRemoteDataSource();
    tokenService = _RecordingTokenService();
    sharedPrefHelper = _FakeSharedPrefHelper();
    pushNotificationService = _FakePushNotificationService();
    familyFlowSnapshotStore = FamilyFlowSnapshotStore();

    repository = AuthRepositoryImpl(
      remoteDataSource,
      tokenService,
      sharedPrefHelper,
      pushNotificationService,
      familyFlowSnapshotStore,
    );

    loginUseCase = LoginUseCase(repository);
    verifyOtpUseCase = VerifyFamilyFirstLoginOtpUseCase(repository);
    setPasswordUseCase = SetFamilyFirstLoginPasswordUseCase(repository);
    resendOtpUseCase = ResendFamilyFirstLoginOtpUseCase(repository);
    biometricService = _FakeBiometricService();
  });

  group('Family First Login - Repository & Entity Contract', () {
    test(
      'pending family member login returns LoginEntity with isPendingFamilyFirstLogin true and null tokens without persisting session',
      () async {
        remoteDataSource.loginResponse = const LoginResponseDto(
          userId: 'user_pending',
          accessToken: null,
          refreshToken: null,
          nextStep: 'family_verify_otp',
          loginChallengeToken: 'challenge_token_step1',
          loginChallengeExpiresAtUtc: '2026-12-01T10:15:00.000Z',
          isAuthenticated: false,
        );

        final result = await repository.login(
          const LoginRequestEntity(
            phone: '55555555',
            password: 'temp_password',
            countryCode: '+965',
          ),
        );

        expect(result, isA<ApiSuccessResult<LoginEntity>>());
        final entity = (result as ApiSuccessResult<LoginEntity>).data;
        expect(entity.isPendingFamilyFirstLogin, isTrue);
        expect(entity.accessToken, isNull);
        expect(entity.refreshToken, isNull);
        expect(entity.loginChallengeToken, 'challenge_token_step1');
        expect(entity.nextStep, 'family_verify_otp');
        expect(tokenService.saveSessionCallCount, 0);
        expect(pushNotificationService.registerTokenCallCount, 0);
      },
    );

    test('verifyFamilyFirstLoginOtp returns rotated challenge token', () async {
      remoteDataSource.verifyOtpResponse =
          const FamilyFirstLoginVerifyOtpResponseDto(
            nextStep: 'family_set_password',
            loginChallengeToken: 'rotated_challenge_token_step2',
            loginChallengeExpiresAtUtc: '2026-12-01T10:30:00.000Z',
          );

      final result = await repository.verifyFamilyFirstLoginOtp(
        const FamilyFirstLoginVerifyOtpRequestEntity(
          loginChallengeToken: 'challenge_token_step1',
          otpCode: '123456',
        ),
      );

      expect(result, isA<ApiSuccessResult<FamilyFirstLoginStepEntity>>());
      final entity =
          (result as ApiSuccessResult<FamilyFirstLoginStepEntity>).data;
      expect(entity.nextStep, 'family_set_password');
      expect(entity.loginChallengeToken, 'rotated_challenge_token_step2');
      expect(tokenService.saveSessionCallCount, 0);
    });

    test(
      'setFamilyFirstLoginPassword persists session and registers push token on success',
      () async {
        remoteDataSource.setPasswordResponse = const LoginResponseDto(
          userId: 'user_completed',
          accessToken: 'final_access_token',
          refreshToken: 'final_refresh_token',
          accessTokenExpiresAtUtc: '2026-12-01T12:00:00.000Z',
          refreshTokenExpiresAtUtc: '2026-12-15T12:00:00.000Z',
          isAuthenticated: true,
        );

        final result = await repository.setFamilyFirstLoginPassword(
          const FamilyFirstLoginSetPasswordRequestEntity(
            loginChallengeToken: 'rotated_challenge_token_step2',
            newPassword: 'MyStrongPassword123!',
          ),
          persistence: SessionPersistence.currentRun,
        );

        expect(result, isA<ApiSuccessResult<LoginEntity>>());
        final entity = (result as ApiSuccessResult<LoginEntity>).data;
        expect(entity.isPendingFamilyFirstLogin, isFalse);
        expect(entity.accessToken, 'final_access_token');
        expect(tokenService.saveSessionCallCount, 1);
        expect(tokenService.savedUserId, 'user_completed');
        expect(tokenService.savedAccessToken, 'final_access_token');
        expect(pushNotificationService.registerTokenCallCount, 1);
      },
    );

    test(
      'resendFamilyFirstLoginOtp rotates challenge token and does not persist session',
      () async {
        remoteDataSource.resendOtpResponse =
            const FamilyFirstLoginVerifyOtpResponseDto(
          nextStep: 'family_verify_otp',
          loginChallengeToken: 'resend_rotated_token',
          loginChallengeExpiresAtUtc: '2026-10-15T12:00:00.000Z',
        );

        final result = await repository.resendFamilyFirstLoginOtp(
          const FamilyFirstLoginResendOtpRequestEntity(
            loginChallengeToken: 'initial_challenge_token',
          ),
        );

        expect(result, isA<ApiSuccessResult<FamilyFirstLoginStepEntity>>());
        final entity =
            (result as ApiSuccessResult<FamilyFirstLoginStepEntity>).data;
        expect(entity.nextStep, 'family_verify_otp');
        expect(entity.loginChallengeToken, 'resend_rotated_token');
        expect(tokenService.saveSessionCallCount, 0);
      },
    );
  });

  group('Family First Login - LoginViewModel Sequence', () {
    late LoginViewModel viewModel;

    setUp(() {
      viewModel = LoginViewModel(
        loginUseCase,
        biometricService,
        verifyFamilyFirstLoginOtpUseCase: verifyOtpUseCase,
        setFamilyFirstLoginPasswordUseCase: setPasswordUseCase,
        resendFamilyFirstLoginOtpUseCase: resendOtpUseCase,
      );
    });

    tearDown(() async {
      await viewModel.close();
    });

    test(
      'full flow: pending login -> verify OTP (rotates token) -> set password (authenticates)',
      () async {
        // 1. Submit login
        remoteDataSource.loginResponse = const LoginResponseDto(
          userId: 'user_family_1',
          accessToken: null,
          refreshToken: null,
          nextStep: 'family_verify_otp',
          loginChallengeToken: 'challenge_initial',
          loginChallengeExpiresAtUtc: '2026-12-01T10:15:00.000Z',
          isAuthenticated: false,
        );

        viewModel.doIntent(
          const SubmitLoginEvent(
            LoginRequestEntity(
              phone: '55555555',
              password: 'temp_pwd',
              countryCode: '+965',
            ),
            rememberMe: false,
          ),
        );

        await pumpEventQueue();

        expect(viewModel.state.isFamilyVerifyOtpPending, isTrue);
        expect(viewModel.state.familyChallengeToken, 'challenge_initial');
        expect(viewModel.state.outcome, LoginOutcome.familyVerifyOtpPending);

        // 2. Verify OTP
        remoteDataSource.verifyOtpResponse =
            const FamilyFirstLoginVerifyOtpResponseDto(
              nextStep: 'family_set_password',
              loginChallengeToken: 'challenge_rotated',
              loginChallengeExpiresAtUtc: '2026-12-01T10:30:00.000Z',
            );

        viewModel.doIntent(const VerifyFamilyFirstLoginOtpEvent('654321'));

        await pumpEventQueue();

        expect(viewModel.state.isFamilySetPasswordPending, isTrue);
        expect(viewModel.state.familyChallengeToken, 'challenge_rotated');
        expect(viewModel.state.outcome, LoginOutcome.familySetPasswordPending);

        // 3. Set Password
        remoteDataSource.setPasswordResponse = const LoginResponseDto(
          userId: 'user_family_1',
          accessToken: 'jwt_access_token',
          refreshToken: 'jwt_refresh_token',
          isAuthenticated: true,
        );

        viewModel.doIntent(
          const SetFamilyFirstLoginPasswordEvent('MyNewPassword123!'),
        );

        await pumpEventQueue();

        expect(viewModel.state.outcome, LoginOutcome.success);
        expect(viewModel.state.isSuccess, isTrue);
        expect(viewModel.state.familyChallengeToken, isNull);
        expect(viewModel.state.loginEntity?.accessToken, 'jwt_access_token');
      },
    );

    test('expired challenge prompts fresh login', () async {
      // Simulate expired challenge
      remoteDataSource.loginResponse = LoginResponseDto(
        userId: 'user_family_2',
        accessToken: null,
        refreshToken: null,
        nextStep: 'family_verify_otp',
        loginChallengeToken: 'challenge_expired',
        loginChallengeExpiresAtUtc: DateTime.now()
            .toUtc()
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
        isAuthenticated: false,
      );

      viewModel.doIntent(
        const SubmitLoginEvent(
          LoginRequestEntity(
            phone: '55555555',
            password: 'temp_pwd',
            countryCode: '+965',
          ),
          rememberMe: false,
        ),
      );

      await pumpEventQueue();

      expect(viewModel.state.isChallengeExpired, isTrue);

      // Attempting OTP verify with expired challenge
      viewModel.doIntent(const VerifyFamilyFirstLoginOtpEvent('111111'));
      await pumpEventQueue();

      expect(viewModel.state.requiresFreshLogin, isTrue);
      expect(viewModel.state.familyChallengeToken, isNull);
    });

    test('ResetFamilyFirstLoginFlowEvent clears transient challenge', () async {
      remoteDataSource.loginResponse = const LoginResponseDto(
        userId: 'user_family_3',
        accessToken: null,
        refreshToken: null,
        nextStep: 'family_verify_otp',
        loginChallengeToken: 'challenge_xyz',
        isAuthenticated: false,
      );

      viewModel.doIntent(
        const SubmitLoginEvent(
          LoginRequestEntity(
            phone: '55555555',
            password: 'temp_pwd',
            countryCode: '+965',
          ),
          rememberMe: false,
        ),
      );

      await pumpEventQueue();
      expect(viewModel.state.familyChallengeToken, 'challenge_xyz');

      viewModel.doIntent(const ResetFamilyFirstLoginFlowEvent());
      await pumpEventQueue();

      expect(viewModel.state.familyChallengeToken, isNull);
      expect(viewModel.state.isFamilyVerifyOtpPending, isFalse);
    });

    test(
      'ResendFamilyFirstLoginOtpEvent rotates familyChallengeToken and sets resendOtpSent',
      () async {
        remoteDataSource.loginResponse = const LoginResponseDto(
          userId: 'user_family_4',
          accessToken: null,
          refreshToken: null,
          nextStep: 'family_verify_otp',
          loginChallengeToken: 'initial_challenge',
          isAuthenticated: false,
        );

        viewModel.doIntent(
          const SubmitLoginEvent(
            LoginRequestEntity(
              phone: '55555555',
              password: 'temp_pwd',
              countryCode: '+965',
            ),
            rememberMe: false,
          ),
        );

        await pumpEventQueue();
        expect(viewModel.state.familyChallengeToken, 'initial_challenge');

        remoteDataSource.resendOtpResponse =
            const FamilyFirstLoginVerifyOtpResponseDto(
          nextStep: 'family_verify_otp',
          loginChallengeToken: 'resend_rotated_challenge',
        );

        viewModel.doIntent(const ResendFamilyFirstLoginOtpEvent());
        await pumpEventQueue();

        expect(viewModel.state.familyChallengeToken, 'resend_rotated_challenge');
        expect(viewModel.state.resendOtpSent, isTrue);
        expect(viewModel.state.isResending, isFalse);
      },
    );
  });
}
