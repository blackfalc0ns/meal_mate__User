import 'support/family_member_view_model_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/update_family_member_access_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_state.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/screens/family_member_access_screen.dart';
import 'package:meal_meat_user/features/family_management/shared/family_management_failure.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_credentials_card.dart';

class _FakeGetAccess implements GetFamilyMemberAccessUseCase {
  FamilyMemberAccessEntity? access;

  @override
  Future<ApiResult<FamilyMemberAccessEntity>> call(String memberId) async {
    return ApiSuccessResult(
      data: access ??
          FamilyMemberAccessEntity(
            memberId: memberId,
            hasSeparateAccount: false,
            isPaused: false,
            hasExistingLogin: false,
            phoneNumber: '+96599887766',
          ),
    );
  }
}

class _FakeUpdateAccess implements UpdateFamilyMemberAccessUseCase {
  int callCount = 0;
  List<UpdateFamilyMemberAccessRequestEntity> sentRequests = [];
  ApiResult<FamilyMemberAccessEntity>? result;

  @override
  Future<ApiResult<FamilyMemberAccessEntity>> call(
    String memberId,
    UpdateFamilyMemberAccessRequestEntity request,
  ) async {
    callCount++;
    sentRequests.add(request);
    return result ??
        ApiSuccessResult(
          data: FamilyMemberAccessEntity(
            memberId: memberId,
            hasSeparateAccount: request.hasSeparateAccount ?? false,
            isPaused: request.isPaused ?? false,
            hasExistingLogin: true,
            phoneNumber: '+96599887766',
            generatedPassword: request.generateTemporaryPassword == true ? 'TempPass123' : null,
          ),
        );
  }
}

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    locale: const Locale('en'),
    home: child,
  );
}

void main() {
  group('Task 7: Member Access Credential Safety & Replay Tests', () {
    test('First issuance sends a unique credentialOperationKey and returns generated password', () async {
      final fakeGet = _FakeGetAccess();
      final fakeUpdate = _FakeUpdateAccess();
      final vm = createFamilyMemberViewModel(null, fakeGet, fakeUpdate);

      vm.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem-1',
          generateTemporaryPassword: true,
        ),
      );
      await pumpEventQueue();

      expect(fakeUpdate.callCount, equals(1));
      final request = fakeUpdate.sentRequests.first;
      expect(request.generateTemporaryPassword, isTrue);
      expect(request.credentialOperationKey, isNotNull);
      expect(request.credentialOperationKey!.isNotEmpty, isTrue);

      expect(vm.state.access?.generatedPassword, equals('TempPass123'));
      expect(vm.state.lastCredentialOperationKey, equals(request.credentialOperationKey));
      expect(vm.state.requiresExplicitReset, isFalse);
    });

    test('Retrying the operation reuses the existing credentialOperationKey without generating a fresh key', () async {
      final fakeGet = _FakeGetAccess();
      final fakeUpdate = _FakeUpdateAccess();
      final vm = createFamilyMemberViewModel(null, fakeGet, fakeUpdate);

      // First attempt
      vm.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem-1',
          generateTemporaryPassword: true,
        ),
      );
      await pumpEventQueue();

      final firstKey = fakeUpdate.sentRequests.first.credentialOperationKey;
      expect(firstKey, isNotNull);

      // Retry attempt (isRetry: true)
      vm.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem-1',
          generateTemporaryPassword: true,
          isRetry: true,
        ),
      );
      await pumpEventQueue();

      expect(fakeUpdate.callCount, equals(2));
      final secondKey = fakeUpdate.sentRequests[1].credentialOperationKey;
      expect(secondKey, equals(firstKey));
    });

    test('Explicit reset generates a brand new credentialOperationKey', () async {
      final fakeGet = _FakeGetAccess();
      final fakeUpdate = _FakeUpdateAccess();
      final vm = createFamilyMemberViewModel(null, fakeGet, fakeUpdate);

      // First attempt
      vm.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem-1',
          generateTemporaryPassword: true,
        ),
      );
      await pumpEventQueue();

      final firstKey = fakeUpdate.sentRequests.first.credentialOperationKey;

      // Explicit reset (isExplicitReset: true)
      vm.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem-1',
          generateTemporaryPassword: true,
          isExplicitReset: true,
        ),
      );
      await pumpEventQueue();

      expect(fakeUpdate.callCount, equals(2));
      final resetKey = fakeUpdate.sentRequests[1].credentialOperationKey;
      expect(resetKey, isNot(equals(firstKey)));
    });

    test('Replay with passwordAlreadyIssued sets requiresExplicitReset and records failure', () async {
      final fakeGet = _FakeGetAccess();
      final fakeUpdate = _FakeUpdateAccess();
      fakeUpdate.result = ApiErrorResult(
        failure: FamilyManagementFailure(
          errorMessage: 'Password already issued',
          code: 'passwordAlreadyIssued',
          isPasswordAlreadyIssued: true,
        ),
      );
      final vm = createFamilyMemberViewModel(null, fakeGet, fakeUpdate);

      vm.doIntent(
        const UpdateFamilyMemberAccessEvent(
          memberId: 'mem-1',
          generateTemporaryPassword: true,
        ),
      );
      await pumpEventQueue();

      expect(fakeUpdate.callCount, equals(1));
      expect(vm.state.requiresExplicitReset, isTrue);
      expect(vm.state.saveFailure, isNotNull);
    });

    test('ClearGeneratedPasswordEvent removes generated password from state', () async {
      final fakeGet = _FakeGetAccess();
      final fakeUpdate = _FakeUpdateAccess();
      final vm = createFamilyMemberViewModel(null, fakeGet, fakeUpdate);

      vm.emit(
        FamilyMemberState(
          access: const FamilyMemberAccessEntity(
            memberId: 'mem-1',
            hasSeparateAccount: true,
            isPaused: false,
            hasExistingLogin: true,
            generatedPassword: 'SecretPassword99!',
          ),
          lastCredentialOperationKey: 'op-key-1',
        ),
      );

      expect(vm.state.access?.generatedPassword, equals('SecretPassword99!'));

      vm.doIntent(const ClearGeneratedPasswordEvent());
      await pumpEventQueue();

      expect(vm.state.access?.generatedPassword, isNull);
      expect(vm.state.lastCredentialOperationKey, isNull);
    });
  });

  group('Task 7: FamilyMemberAccessScreen UI Tests', () {
    testWidgets('Displays canonical linked phone from access entity', (tester) async {
      const canonicalPhone = '+965 9988 7766';
      final access = const FamilyMemberAccessEntity(
        memberId: 'mem-1',
        hasSeparateAccount: true,
        isPaused: false,
        hasExistingLogin: true,
        phoneNumber: canonicalPhone,
      );

      await tester.pumpWidget(
        _wrap(
          Scaffold(
            body: FamilyMemberAccessCredentialsCard(
              identifier: access.phoneNumber,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(canonicalPhone), findsOneWidget);
    });
  });
}
