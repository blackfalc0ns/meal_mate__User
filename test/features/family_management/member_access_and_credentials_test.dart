import '../../support/family_member_view_model_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/sensitive_data_sanitizer.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/update_family_member_access_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_detail_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/renew_family_member_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_basic_info_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_view_model.dart';

class FakeAccessFamilyMemberRepository implements FamilyMemberRepository {
  UpdateFamilyMemberAccessRequestEntity? lastUpdateRequest;
  ApiResult<FamilyMemberAccessEntity>? updateResult;
  int updateCallCount = 0;

  @override
  Future<ApiResult<FamilyMemberAccessEntity>> updateMemberAccess(
    String memberId,
    UpdateFamilyMemberAccessRequestEntity request,
  ) async {
    updateCallCount++;
    lastUpdateRequest = request;
    return updateResult ??
        ApiSuccessResult(
          data: FamilyMemberAccessEntity(
            memberId: memberId,
            hasSeparateAccount: request.hasSeparateAccount ?? false,
            isPaused: request.isPaused ?? false,
            hasExistingLogin: true,
            phoneNumber: '+96598765432',
            generatedPassword: request.generateTemporaryPassword == true
                ? 'Temp@1234'
                : null,
          ),
        );
  }

  @override
  Future<ApiResult<FamilyMemberAccessEntity>> getMemberAccess(
    String memberId,
  ) async {
    return const ApiSuccessResult(
      data: FamilyMemberAccessEntity(
        memberId: 'm-1',
        hasSeparateAccount: false,
        isPaused: false,
        hasExistingLogin: false,
        phoneNumber: '+96598765432',
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

FamilyMemberViewModel _createViewModel(FakeAccessFamilyMemberRepository fakeRepo) {
  return createFamilyMemberViewModel(
    GetFamilyMemberDetailUseCase(fakeRepo),
    GetFamilyMemberAccessUseCase(fakeRepo),
    UpdateFamilyMemberAccessUseCase(fakeRepo),
    GetFamilyMemberPermissionsUseCase(fakeRepo),
    UpdateFamilyMemberPermissionsUseCase(fakeRepo),
    UpdateFamilyMemberBasicInfoUseCase(fakeRepo),
    RenewFamilyMemberSubscriptionUseCase(fakeRepo),
  );
}

void main() {
  group('Task 7: Member access provisioning and credential safety', () {
    test('1. First issuance generates temporary password and sends unique operationKey', () async {
      final fakeRepo = FakeAccessFamilyMemberRepository();
      final viewModel = _createViewModel(fakeRepo);

      viewModel.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem_1',
          hasSeparateAccount: true,
          generateTemporaryPassword: true,
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeRepo.lastUpdateRequest, isNotNull);
      expect(fakeRepo.lastUpdateRequest?.generateTemporaryPassword, isTrue);
      expect(fakeRepo.lastUpdateRequest?.credentialOperationKey, isNotNull);
      expect(fakeRepo.lastUpdateRequest?.credentialOperationKey!.isNotEmpty, isTrue);

      expect(viewModel.state.access?.generatedPassword, equals('Temp@1234'));
      expect(viewModel.state.access?.phoneNumber, equals('+96598765432'));
      expect(viewModel.state.lastCredentialOperationKey, equals(fakeRepo.lastUpdateRequest?.credentialOperationKey));

      // Clearing generated password clears it from state
      viewModel.doIntent(const ClearGeneratedPasswordEvent());
      expect(viewModel.state.access?.generatedPassword, isNull);

      viewModel.close();
    });

    test('2. Replay/retry reuses the existing operationKey and does not auto-generate a fresh one', () async {
      final fakeRepo = FakeAccessFamilyMemberRepository();
      final viewModel = _createViewModel(fakeRepo);

      // First attempt with explicit key
      viewModel.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem_1',
          generateTemporaryPassword: true,
          credentialOperationKey: 'key-attempt-1',
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeRepo.lastUpdateRequest?.credentialOperationKey, equals('key-attempt-1'));
      expect(viewModel.state.lastCredentialOperationKey, equals('key-attempt-1'));

      // Retry same operation (isRetry = true) without specifying a new key
      viewModel.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem_1',
          generateTemporaryPassword: true,
          isRetry: true,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      // Must reuse key-attempt-1!
      expect(fakeRepo.lastUpdateRequest?.credentialOperationKey, equals('key-attempt-1'));

      viewModel.close();
    });

    test('3. Replay with passwordAlreadyIssued or requiresExplicitReset marks state', () async {
      final fakeRepo = FakeAccessFamilyMemberRepository();
      fakeRepo.updateResult = ApiErrorResult(
        failure: Failure(
          errorMessage: 'Password has already been issued for this account',
          code: 'family.password_already_issued',
          exception: ApiException(
            statusCode: 409,
            message: 'Conflict',
            errorType: ApiErrorType.conflict,
          ),
        ),
      );

      final viewModel = _createViewModel(fakeRepo);

      viewModel.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem_1',
          generateTemporaryPassword: true,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(viewModel.state.saveFailure, isNotNull);
      expect(viewModel.state.requiresExplicitReset, isTrue);

      viewModel.close();
    });

    test('4. Explicit reset generates a new operationKey', () async {
      final fakeRepo = FakeAccessFamilyMemberRepository();
      final viewModel = _createViewModel(fakeRepo);

      // First request
      viewModel.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem_1',
          generateTemporaryPassword: true,
          credentialOperationKey: 'initial-key',
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(fakeRepo.lastUpdateRequest?.credentialOperationKey, equals('initial-key'));

      // Explicit reset (isRetry: false, fresh key)
      viewModel.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem_1',
          generateTemporaryPassword: true,
          isRetry: false,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(fakeRepo.lastUpdateRequest?.credentialOperationKey, isNot(equals('initial-key')));
      expect(viewModel.state.requiresExplicitReset, isFalse);

      viewModel.close();
    });

    test('5. Redacts credentials and tokens in SensitiveDataSanitizer', () {
      const rawJson = '''
      {
        "accessToken": "eyJhbGciOi...",
        "refreshToken": "ref_123456",
        "generatedPassword": "SecretPassword123!",
        "temporaryPassword": "TempPassword456!",
        "loginChallengeToken": "challenge_token_abc",
        "otpCode": "123456",
        "phoneNumber": "+96598765432"
      }
      ''';

      final sanitized = SensitiveDataSanitizer.sanitize(rawJson);

      expect(sanitized, isNot(contains('eyJhbGciOi...')));
      expect(sanitized, isNot(contains('ref_123456')));
      expect(sanitized, isNot(contains('SecretPassword123!')));
      expect(sanitized, isNot(contains('TempPassword456!')));
      expect(sanitized, isNot(contains('challenge_token_abc')));
      expect(sanitized, isNot(contains('123456')));

      // Non-sensitive data remains intact
      expect(sanitized, contains('+96598765432'));
    });
  });
}
