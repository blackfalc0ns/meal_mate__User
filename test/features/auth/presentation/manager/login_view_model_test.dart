import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_credentials.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/services/session_persistence.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/login_usecase.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_view_model.dart';

LoginEntity createTestLoginEntity({
  String userId = 'user-1',
  bool isAuthenticated = true,
}) {
  return LoginEntity(
    userId: userId,
    email: 'test@example.com',
    phoneNumber: '+96512345678',
    fullName: 'Test User',
    userType: 'Customer',
    accountStatus: 'Active',
    restaurantId: null,
    roles: const ['Customer'],
    permissions: const [],
    accessToken: 'access-token',
    accessTokenExpiresAtUtc: '2026-10-07T12:00:00Z',
    refreshToken: 'refresh-token',
    refreshTokenExpiresAtUtc: '2026-10-14T12:00:00Z',
    nextStep: null,
    loginChallengeToken: null,
    loginChallengeExpiresAtUtc: null,
    recoveryCodes: const [],
    isAuthenticated: isAuthenticated,
  );
}

class _FakeLoginUseCase extends Fake implements LoginUseCase {
  int callCount = 0;
  LoginRequestEntity? lastRequest;
  SessionPersistence? lastPersistence;
  ApiResult<LoginEntity>? stubbedResult;
  Completer<ApiResult<LoginEntity>>? completer;

  @override
  Future<ApiResult<LoginEntity>> call(
    LoginRequestEntity request, {
    SessionPersistence persistence = SessionPersistence.currentRun,
  }) async {
    callCount++;
    lastRequest = request;
    lastPersistence = persistence;
    if (completer != null) {
      return completer!.future;
    }
    return stubbedResult!;
  }
}

class _FakeBiometricService extends Fake implements BiometricService {
  bool canOffer = false;
  bool isEnabled = false;
  BiometricCredentials? credentials;
  BiometricAuthResult authResult = const BiometricAuthResult.success();
  int authCallCount = 0;

  @override
  Future<bool> canOfferBiometricLogin() async => canOffer;

  @override
  bool isBiometricEnabled() => isEnabled;

  @override
  Future<BiometricCredentials?> getSavedCredentials() async => credentials;

  @override
  Future<BiometricAuthResult> authenticate({
    required String localizedReason,
    bool biometricOnly = false,
  }) async {
    authCallCount++;
    return authResult;
  }
}

void main() {
  late _FakeLoginUseCase fakeLoginUseCase;
  late _FakeBiometricService fakeBiometricService;
  late LoginViewModel viewModel;

  setUp(() {
    fakeLoginUseCase = _FakeLoginUseCase();
    fakeBiometricService = _FakeBiometricService();
    viewModel = LoginViewModel(fakeLoginUseCase, fakeBiometricService);
  });

  tearDown(() async {
    await viewModel.close();
  });

  test(
    'SubmitLoginEvent passes SessionPersistence.remembered when rememberMe is true',
    () async {
      const request = LoginRequestEntity(
        phone: '+96512345678',
        password: 'password123',
        countryCode: 'KW',
      );
      final loginEntity = createTestLoginEntity();
      fakeLoginUseCase.stubbedResult = ApiSuccessResult(data: loginEntity);

      final expectation = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<LoginState>((s) => s.isLoading && s.rememberMe),
          predicate<LoginState>(
            (s) => !s.isLoading && s.isSuccess && s.loginEntity == loginEntity,
          ),
        ]),
      );

      viewModel.doIntent(const SubmitLoginEvent(request, rememberMe: true));
      await expectation;

      expect(fakeLoginUseCase.callCount, 1);
      expect(fakeLoginUseCase.lastPersistence, SessionPersistence.remembered);
    },
  );

  test(
    'SubmitLoginEvent passes SessionPersistence.currentRun when rememberMe is false',
    () async {
      const request = LoginRequestEntity(
        phone: '+96512345678',
        password: 'password123',
        countryCode: 'KW',
      );
      final loginEntity = createTestLoginEntity();
      fakeLoginUseCase.stubbedResult = ApiSuccessResult(data: loginEntity);

      final expectation = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<LoginState>((s) => s.isLoading && !s.rememberMe),
          predicate<LoginState>((s) => !s.isLoading && s.isSuccess),
        ]),
      );

      viewModel.doIntent(const SubmitLoginEvent(request, rememberMe: false));
      await expectation;

      expect(fakeLoginUseCase.callCount, 1);
      expect(fakeLoginUseCase.lastPersistence, SessionPersistence.currentRun);
    },
  );

  test(
    'duplicate concurrent SubmitLoginEvent triggers only one LoginUseCase call',
    () async {
      const request = LoginRequestEntity(
        phone: '+96512345678',
        password: 'password123',
        countryCode: 'KW',
      );
      fakeLoginUseCase.completer = Completer<ApiResult<LoginEntity>>();

      viewModel.doIntent(const SubmitLoginEvent(request, rememberMe: false));
      viewModel.doIntent(const SubmitLoginEvent(request, rememberMe: false));

      expect(fakeLoginUseCase.callCount, 1);

      fakeLoginUseCase.completer!.complete(
        ApiSuccessResult(data: createTestLoginEntity()),
      );
      await Future<void>.delayed(Duration.zero);
    },
  );

  test(
    'SubmitLoginEvent failure emits LoginOutcome.failure and ends loading',
    () async {
      const request = LoginRequestEntity(
        phone: '+96512345678',
        password: 'wrong',
        countryCode: 'KW',
      );
      final failure = ServerFailure(
        errorMessage: 'Invalid credentials',
        exception: const ApiException(
          errorType: ApiErrorType.unauthorized,
          message: 'Invalid credentials',
        ),
      );
      fakeLoginUseCase.stubbedResult = ApiErrorResult(failure: failure);

      final expectation = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<LoginState>((s) => s.isLoading),
          predicate<LoginState>(
            (s) =>
                !s.isLoading &&
                s.outcome == LoginOutcome.failure &&
                s.failure == failure,
          ),
        ]),
      );

      viewModel.doIntent(const SubmitLoginEvent(request, rememberMe: false));
      await expectation;
    },
  );

  test(
    'ViewModel closed during in-flight login does not throw or emit after close',
    () async {
      const request = LoginRequestEntity(
        phone: '+96512345678',
        password: 'password123',
        countryCode: 'KW',
      );
      fakeLoginUseCase.completer = Completer<ApiResult<LoginEntity>>();

      viewModel.doIntent(const SubmitLoginEvent(request, rememberMe: false));
      await viewModel.close();

      fakeLoginUseCase.completer!.complete(
        ApiSuccessResult(data: createTestLoginEntity()),
      );
      await Future<void>.delayed(Duration.zero);
    },
  );

  test(
    'RememberMeChangedEvent updates rememberMe state without calling use case',
    () {
      expect(viewModel.state.rememberMe, isFalse);

      viewModel.doIntent(const RememberMeChangedEvent(true));
      expect(viewModel.state.rememberMe, isTrue);

      viewModel.doIntent(const RememberMeChangedEvent(false));
      expect(viewModel.state.rememberMe, isFalse);

      expect(fakeLoginUseCase.callCount, 0);
    },
  );

  test(
    'CheckBiometricReadinessEvent sets isBiometricReady true when supported and credentials present',
    () async {
      fakeBiometricService.canOffer = true;
      fakeBiometricService.isEnabled = true;
      fakeBiometricService.credentials = const BiometricCredentials(
        phone: '+96512345678',
        password: 'password',
        countryCode: 'KW',
      );

      final expectation = expectLater(
        viewModel.stream,
        emits(predicate<LoginState>((s) => s.isBiometricReady)),
      );

      viewModel.doIntent(const CheckBiometricReadinessEvent());
      await expectation;
    },
  );

  test(
    'LoginWithBiometricsEvent user cancellation resets loading without error toast',
    () async {
      fakeBiometricService.credentials = const BiometricCredentials(
        phone: '+96512345678',
        password: 'password',
        countryCode: 'KW',
      );
      fakeBiometricService.authResult = const BiometricAuthResult.canceled();

      final expectation = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<LoginState>((s) => s.isLoading),
          predicate<LoginState>(
            (s) =>
                !s.isLoading &&
                s.outcome == LoginOutcome.idle &&
                s.biometricErrorMessage == null,
          ),
        ]),
      );

      viewModel.doIntent(const LoginWithBiometricsEvent());
      await expectation;

      expect(fakeLoginUseCase.callCount, 0);
    },
  );

  test(
    'LoginWithBiometricsEvent success performs login and emits success',
    () async {
      const creds = BiometricCredentials(
        phone: '+96512345678',
        password: 'password',
        countryCode: 'KW',
      );
      final loginEntity = createTestLoginEntity();

      fakeBiometricService.credentials = creds;
      fakeBiometricService.authResult = const BiometricAuthResult.success();
      fakeLoginUseCase.stubbedResult = ApiSuccessResult(data: loginEntity);

      final expectation = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<LoginState>((s) => s.isLoading),
          predicate<LoginState>(
            (s) => !s.isLoading && s.isSuccess && s.loginEntity == loginEntity,
          ),
        ]),
      );

      viewModel.doIntent(const LoginWithBiometricsEvent());
      await expectation;

      expect(fakeLoginUseCase.callCount, 1);
    },
  );

  test('ClearLoginFeedbackEvent resets outcome and error messages', () async {
    final failure = ServerFailure(
      errorMessage: 'Invalid credentials',
      exception: const ApiException(
        errorType: ApiErrorType.unauthorized,
        message: 'Invalid credentials',
      ),
    );
    fakeLoginUseCase.stubbedResult = ApiErrorResult(failure: failure);

    final expectation = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<LoginState>((s) => s.isLoading),
        predicate<LoginState>((s) => s.outcome == LoginOutcome.failure),
      ]),
    );

    viewModel.doIntent(
      const SubmitLoginEvent(
        LoginRequestEntity(
          phone: '+96512345678',
          password: 'p',
          countryCode: 'KW',
        ),
        rememberMe: false,
      ),
    );
    await expectation;

    viewModel.doIntent(const ClearLoginFeedbackEvent());

    expect(viewModel.state.outcome, LoginOutcome.idle);
    expect(viewModel.state.failure, isNull);
  });
}
