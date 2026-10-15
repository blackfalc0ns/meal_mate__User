import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/logout_usecase.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/logout_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/logout_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/logout_view_model.dart';

class FakeAuthRepositoryForLogout extends Fake implements AuthRepository {
  int logoutCalls = 0;
  LogoutRequestEntity? lastRequest;
  Completer<ApiResult<LogoutEntity>>? completer;
  ApiResult<LogoutEntity> stubResult = const ApiSuccessResult(
    data: LogoutEntity(isLoggedOut: true),
  );

  @override
  Future<ApiResult<LogoutEntity>> logout(LogoutRequestEntity request) {
    logoutCalls++;
    lastRequest = request;
    if (completer != null) {
      return completer!.future;
    }
    return Future.value(stubResult);
  }
}

class FakeTokenServiceForLogout extends Fake implements TokenService {
  String? refreshToken = 'mock-refresh-token';
  int clearSessionCalls = 0;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> clearSession() async {
    clearSessionCalls++;
  }
}

class FakeBiometricServiceForLogout extends Fake implements BiometricService {
  int disableBiometricCalls = 0;

  @override
  Future<void> disableBiometric() async {
    disableBiometricCalls++;
  }
}

void main() {
  late FakeAuthRepositoryForLogout fakeRepo;
  late LogoutUseCase logoutUseCase;
  late FakeTokenServiceForLogout fakeTokenService;
  late FakeBiometricServiceForLogout fakeBiometricService;
  late LogoutViewModel viewModel;

  setUp(() {
    fakeRepo = FakeAuthRepositoryForLogout();
    logoutUseCase = LogoutUseCase(fakeRepo);
    fakeTokenService = FakeTokenServiceForLogout();
    fakeBiometricService = FakeBiometricServiceForLogout();
    viewModel = LogoutViewModel(
      logoutUseCase,
      fakeTokenService,
      fakeBiometricService,
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  test(
    'RequestLogoutEvent calls use case, clears session, and emits success',
    () async {
      final expectedStates = <LogoutState>[];
      final sub = viewModel.stream.listen(expectedStates.add);

      viewModel.add(const RequestLogoutEvent());
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeRepo.logoutCalls, 1);
      expect(fakeRepo.lastRequest?.refreshToken, 'mock-refresh-token');
      expect(fakeTokenService.clearSessionCalls, 1);
      expect(fakeBiometricService.disableBiometricCalls, 0);

      expect(expectedStates.length, 2);
      expect(expectedStates[0].isLoading, isTrue);
      expect(expectedStates[1].isLoading, isFalse);
      expect(expectedStates[1].outcome, LogoutOutcome.success);
      expect(expectedStates[1].isServerRevoked, isTrue);

      await sub.cancel();
    },
  );

  test(
    'RequestLogoutEvent with invalidateBiometrics: true disables biometric',
    () async {
      viewModel.add(const RequestLogoutEvent(invalidateBiometrics: true));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeBiometricService.disableBiometricCalls, 1);
      expect(fakeTokenService.clearSessionCalls, 1);
    },
  );

  test(
    'Concurrent duplicate RequestLogoutEvent only executes one network call',
    () async {
      final completer = Completer<ApiResult<LogoutEntity>>();
      fakeRepo.completer = completer;

      viewModel.add(const RequestLogoutEvent());
      viewModel.add(const RequestLogoutEvent());
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(fakeRepo.logoutCalls, 1);

      completer.complete(
        const ApiSuccessResult(data: LogoutEntity(isLoggedOut: true)),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(fakeRepo.logoutCalls, 1);
    },
  );

  test(
    'RequestLogoutEvent when server fails still guarantees local session clear',
    () async {
      final failure = ServerFailure(
        errorMessage: 'Network timeout',
        exception: const ApiException(
          errorType: ApiErrorType.connectionTimeout,
          message: 'Network timeout',
        ),
      );
      fakeRepo.stubResult = ApiErrorResult(failure: failure);

      viewModel.add(const RequestLogoutEvent());
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeTokenService.clearSessionCalls, 1);
      expect(viewModel.state.outcome, LogoutOutcome.success);
      expect(viewModel.state.isServerRevoked, isFalse);
      expect(viewModel.state.failure, failure);
    },
  );

  test('ClearLogoutFeedbackEvent clears outcome and failure', () async {
    fakeRepo.stubResult = ApiErrorResult(
      failure: ServerFailure(
        errorMessage: 'Err',
        exception: const ApiException(
          errorType: ApiErrorType.unknown,
          message: 'Err',
        ),
      ),
    );

    viewModel.add(const RequestLogoutEvent());
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(viewModel.state.outcome, LogoutOutcome.success);
    expect(viewModel.state.failure, isNotNull);

    viewModel.add(const ClearLogoutFeedbackEvent());
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(viewModel.state.outcome, LogoutOutcome.idle);
    expect(viewModel.state.failure, isNull);
  });
}
