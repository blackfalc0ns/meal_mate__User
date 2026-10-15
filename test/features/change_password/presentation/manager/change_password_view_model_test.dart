import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/change_password/domain/entities/change_customer_password_request_entity.dart';
import 'package:meal_meat_user/features/change_password/domain/repo/change_password_repository.dart';
import 'package:meal_meat_user/features/change_password/domain/usecase/change_customer_password_usecase.dart';
import 'package:meal_meat_user/features/change_password/presentation/manager/change_password_event.dart';
import 'package:meal_meat_user/features/change_password/presentation/manager/change_password_state.dart';
import 'package:meal_meat_user/features/change_password/presentation/manager/change_password_view_model.dart';

class FakeChangePasswordRepository implements ChangePasswordRepository {
  int callCount = 0;
  ChangeCustomerPasswordRequestEntity? lastRequest;
  Completer<ApiResult<void>>? completer;
  ApiResult<void> stubResult = const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<void>> changeCustomerPassword(
    ChangeCustomerPasswordRequestEntity request,
  ) {
    callCount++;
    lastRequest = request;
    if (completer != null) {
      return completer!.future;
    }
    return Future.value(stubResult);
  }
}

class FakeTokenServiceForChangePassword extends Fake implements TokenService {
  int deleteBiometricCalls = 0;

  @override
  Future<void> deleteBiometricCredentials() async {
    deleteBiometricCalls++;
  }
}

void main() {
  late FakeChangePasswordRepository fakeRepo;
  late ChangeCustomerPasswordUseCase useCase;
  late FakeTokenServiceForChangePassword fakeTokenService;
  late ChangePasswordViewModel viewModel;

  const testRequest = ChangeCustomerPasswordRequestEntity(
    currentPassword: 'oldPassword123',
    newPassword: 'newPassword456',
  );

  setUp(() {
    fakeRepo = FakeChangePasswordRepository();
    useCase = ChangeCustomerPasswordUseCase(fakeRepo);
    fakeTokenService = FakeTokenServiceForChangePassword();
    viewModel = ChangePasswordViewModel(useCase, fakeTokenService);
  });

  tearDown(() async {
    await viewModel.close();
  });

  test(
    'SubmitChangePasswordEvent calls usecase and deletes biometric credentials on success',
    () async {
      final expectedStates = <ChangePasswordState>[];
      final sub = viewModel.stream.listen(expectedStates.add);

      viewModel.add(const SubmitChangePasswordEvent(testRequest));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeRepo.callCount, 1);
      expect(fakeRepo.lastRequest?.currentPassword, 'oldPassword123');
      expect(fakeRepo.lastRequest?.newPassword, 'newPassword456');
      expect(fakeTokenService.deleteBiometricCalls, 1);

      expect(expectedStates.length, 2);
      expect(expectedStates[0].isLoading, isTrue);
      expect(expectedStates[1].isLoading, isFalse);
      expect(expectedStates[1].outcome, ChangePasswordOutcome.success);
      expect(expectedStates[1].failure, isNull);

      await sub.cancel();
    },
  );

  test(
    'Concurrent duplicate SubmitChangePasswordEvent only triggers one in-flight call',
    () async {
      final completer = Completer<ApiResult<void>>();
      fakeRepo.completer = completer;

      viewModel.add(const SubmitChangePasswordEvent(testRequest));
      viewModel.add(const SubmitChangePasswordEvent(testRequest));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(fakeRepo.callCount, 1);

      completer.complete(const ApiSuccessResult(data: null));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(fakeRepo.callCount, 1);
    },
  );

  test(
    'SubmitChangePasswordEvent does NOT delete biometric credentials on failure',
    () async {
      final failure = ServerFailure(
        errorMessage: 'Wrong password',
        exception: const ApiException(
          errorType: ApiErrorType.unauthorized,
          message: 'Wrong password',
        ),
      );
      fakeRepo.stubResult = ApiErrorResult(failure: failure);

      final expectedStates = <ChangePasswordState>[];
      final sub = viewModel.stream.listen(expectedStates.add);

      viewModel.add(const SubmitChangePasswordEvent(testRequest));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeRepo.callCount, 1);
      expect(fakeTokenService.deleteBiometricCalls, 0);

      expect(expectedStates.length, 2);
      expect(expectedStates[0].isLoading, isTrue);
      expect(expectedStates[1].isLoading, isFalse);
      expect(expectedStates[1].outcome, ChangePasswordOutcome.failure);
      expect(expectedStates[1].failure, failure);

      await sub.cancel();
    },
  );

  test(
    'Closing ViewModel during in-flight call does not crash or emit after close',
    () async {
      final completer = Completer<ApiResult<void>>();
      fakeRepo.completer = completer;

      viewModel.add(const SubmitChangePasswordEvent(testRequest));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await viewModel.close();
      completer.complete(const ApiSuccessResult(data: null));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(viewModel.isClosed, isTrue);
    },
  );

  test(
    'ClearChangePasswordFeedbackEvent resets outcome to idle and clears failure',
    () async {
      final failure = ServerFailure(
        errorMessage: 'Failed',
        exception: const ApiException(
          errorType: ApiErrorType.badRequest,
          message: 'Failed',
        ),
      );
      fakeRepo.stubResult = ApiErrorResult(failure: failure);

      viewModel.add(const SubmitChangePasswordEvent(testRequest));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(viewModel.state.outcome, ChangePasswordOutcome.failure);
      expect(viewModel.state.failure, isNotNull);

      viewModel.add(const ClearChangePasswordFeedbackEvent());
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(viewModel.state.outcome, ChangePasswordOutcome.idle);
      expect(viewModel.state.failure, isNull);
    },
  );
}
