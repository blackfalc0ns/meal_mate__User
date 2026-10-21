import 'package:meal_meat_user/features/family_management/member/data/mapper/family_member_request_mapper.dart';
import '../../support/family_member_view_model_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/update_family_member_permissions_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_detail_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/renew_family_member_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_basic_info_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/shared/family_management_failure.dart';

class FakeFamilyMemberRepository implements FamilyMemberRepository {
  UpdateFamilyMemberPermissionsRequestEntity? lastUpdateRequest;
  int updateCallCount = 0;
  int getPermissionsCallCount = 0;

  ApiResult<FamilyMemberPermissionsEntity>? updateResult;
  ApiResult<FamilyMemberPermissionsEntity>? getPermissionsResult;

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> updateMemberPermissions(
    String memberId,
    UpdateFamilyMemberPermissionsRequestEntity request, {
    String locale = 'ar',
  }) async {
    updateCallCount++;
    lastUpdateRequest = request;
    return updateResult!;
  }

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> getMemberPermissions(
    String memberId, {
    String locale = 'ar',
  }) async {
    getPermissionsCallCount++;
    return getPermissionsResult!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Task 5: Versioned Permission Updates and Conflict Handling', () {
    test('UpdateFamilyMemberPermissionsRequestEntity omits unchanged keys and strips obsolete keys', () {
      final request = UpdateFamilyMemberPermissionsRequestEntity(
        expectedVersion: 4,
        patch: {
          'editDailyMeals': true,
          'changeProgram': true, // obsolete, must be stripped
          'changeDeliveryTime': true, // obsolete, must be stripped
        },
      );

      final json = request.toDto().toJson();

      expect(json['expectedVersion'], 4);
      expect(json['editDailyMeals'], true);
      // Unchanged keys must NOT be present
      expect(json.containsKey('viewProgram'), false);
      expect(json.containsKey('editMealsAndDays'), false);
      expect(json.containsKey('changePassword'), false);
      expect(json.containsKey('groups'), false);
      // Obsolete keys must NEVER be sent
      expect(json.containsKey('changeProgram'), false);
      expect(json.containsKey('changeDeliveryTime'), false);
    });

    test('ViewModel sends only changed nullable patch keys and expectedVersion', () async {
      final fakeRepo = FakeFamilyMemberRepository();
      final viewModel = createFamilyMemberViewModel(
        GetFamilyMemberDetailUseCase(fakeRepo),
        GetFamilyMemberAccessUseCase(fakeRepo),
        UpdateFamilyMemberAccessUseCase(fakeRepo),
        GetFamilyMemberPermissionsUseCase(fakeRepo),
        UpdateFamilyMemberPermissionsUseCase(fakeRepo),
        UpdateFamilyMemberBasicInfoUseCase(fakeRepo),
        RenewFamilyMemberSubscriptionUseCase(fakeRepo),
      );

      const initialPermissions = FamilyMemberPermissionsEntity(
        memberId: 'member-1',
        version: 3,
        values: {
          'editDailyMeals': false,
          'viewCalendar': true,
          'changePassword': false,
        },
        groups: [
          FamilyPermissionGroupEntity(
            code: 'g1',
            label: 'Group 1',
            permissions: [
              FamilyPermissionItemEntity(
                key: 'editDailyMeals',
                label: 'Edit Daily Meals',
                value: false,
              ),
              FamilyPermissionItemEntity(
                key: 'viewCalendar',
                label: 'View Calendar',
                value: true,
              ),
            ],
          ),
        ],
      );

      fakeRepo.getPermissionsResult = const ApiSuccessResult(data: initialPermissions);

      // Load initial permissions
      viewModel.doIntent(const LoadFamilyMemberPermissionsEvent('member-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(viewModel.state.permissions?.version, 3);
      expect(viewModel.state.permissionValues['editDailyMeals'], false);

      // Toggle editDailyMeals to true
      viewModel.doIntent(const ToggleFamilyPermissionEvent('editDailyMeals', true));

      const updatedPermissions = FamilyMemberPermissionsEntity(
        memberId: 'member-1',
        version: 4,
        values: {
          'editDailyMeals': true,
          'viewCalendar': true,
          'changePassword': false,
        },
        groups: [],
      );

      fakeRepo.updateResult = const ApiSuccessResult(data: updatedPermissions);

      // Save
      viewModel.doIntent(const UpdateFamilyMemberPermissionsEvent('member-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Check request sent to server
      expect(fakeRepo.updateCallCount, 1);
      final req = fakeRepo.lastUpdateRequest!;
      expect(req.expectedVersion, 3);
      expect(req.patch, {'editDailyMeals': true});
      // viewCalendar was unchanged, so not in patch
      expect(req.patch.containsKey('viewCalendar'), false);

      // State is updated with new version and values
      expect(viewModel.state.permissions?.version, 4);
      expect(viewModel.state.permissionValues['editDailyMeals'], true);
      expect(viewModel.state.saveSuccessCount, 1);
      expect(viewModel.state.isSaving, false);
    });

    test('ViewModel does not call update when no permission values changed', () async {
      final fakeRepo = FakeFamilyMemberRepository();
      final viewModel = createFamilyMemberViewModel(
        GetFamilyMemberDetailUseCase(fakeRepo),
        GetFamilyMemberAccessUseCase(fakeRepo),
        UpdateFamilyMemberAccessUseCase(fakeRepo),
        GetFamilyMemberPermissionsUseCase(fakeRepo),
        UpdateFamilyMemberPermissionsUseCase(fakeRepo),
        UpdateFamilyMemberBasicInfoUseCase(fakeRepo),
        RenewFamilyMemberSubscriptionUseCase(fakeRepo),
      );

      const initialPermissions = FamilyMemberPermissionsEntity(
        memberId: 'member-1',
        version: 3,
        values: {'editDailyMeals': false},
        groups: [],
      );

      fakeRepo.getPermissionsResult = const ApiSuccessResult(data: initialPermissions);
      viewModel.doIntent(const LoadFamilyMemberPermissionsEvent('member-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Attempt to save without changes
      viewModel.doIntent(const UpdateFamilyMemberPermissionsEvent('member-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(fakeRepo.updateCallCount, 0);
    });

    test('409 Conflict triggers fresh catalog load and discards stale patch', () async {
      final fakeRepo = FakeFamilyMemberRepository();
      final viewModel = createFamilyMemberViewModel(
        GetFamilyMemberDetailUseCase(fakeRepo),
        GetFamilyMemberAccessUseCase(fakeRepo),
        UpdateFamilyMemberAccessUseCase(fakeRepo),
        GetFamilyMemberPermissionsUseCase(fakeRepo),
        UpdateFamilyMemberPermissionsUseCase(fakeRepo),
        UpdateFamilyMemberBasicInfoUseCase(fakeRepo),
        RenewFamilyMemberSubscriptionUseCase(fakeRepo),
      );

      const initialPermissions = FamilyMemberPermissionsEntity(
        memberId: 'member-1',
        version: 2,
        values: {'editDailyMeals': false},
        groups: [],
      );

      fakeRepo.getPermissionsResult = const ApiSuccessResult(data: initialPermissions);
      viewModel.doIntent(const LoadFamilyMemberPermissionsEvent('member-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Change locally
      viewModel.doIntent(const ToggleFamilyPermissionEvent('editDailyMeals', true));

      // Return 409 conflict on update
      fakeRepo.updateResult = ApiErrorResult(
        failure: FamilyManagementFailure(
          errorMessage: 'Permissions changed',
          code: 'family.permissions_changed',
          statusCode: 409,
          isPermissionConflict: true,
          exception: const ApiException(
            message: 'Permissions changed',
            statusCode: 409,
            errorType: ApiErrorType.other,
            backendErrorCode: 'family.permissions_changed',
          ),
        ),
      );

      // Fresh permissions on server after conflict
      const serverFreshPermissions = FamilyMemberPermissionsEntity(
        memberId: 'member-1',
        version: 3,
        values: {'editDailyMeals': false, 'viewCalendar': true},
        groups: [],
      );
      fakeRepo.getPermissionsResult = const ApiSuccessResult(data: serverFreshPermissions);

      // Save
      viewModel.doIntent(const UpdateFamilyMemberPermissionsEvent('member-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Should have re-fetched permissions (getPermissionsCallCount == 2: initial + conflict refresh)
      expect(fakeRepo.getPermissionsCallCount, 2);
      expect(viewModel.state.permissions?.version, 3);
      // Stale toggle is discarded, local values match fresh server values
      expect(viewModel.state.permissionValues['editDailyMeals'], false);
      expect(viewModel.state.permissionValues['viewCalendar'], true);
      // saveSuccessCount was NOT incremented
      expect(viewModel.state.saveSuccessCount, 0);
      expect(viewModel.state.saveFailure, isNotNull);
    });

    test('403 Forbidden denial preserves error, reloads permissions, and does not claim success', () async {
      final fakeRepo = FakeFamilyMemberRepository();
      final viewModel = createFamilyMemberViewModel(
        GetFamilyMemberDetailUseCase(fakeRepo),
        GetFamilyMemberAccessUseCase(fakeRepo),
        UpdateFamilyMemberAccessUseCase(fakeRepo),
        GetFamilyMemberPermissionsUseCase(fakeRepo),
        UpdateFamilyMemberPermissionsUseCase(fakeRepo),
        UpdateFamilyMemberBasicInfoUseCase(fakeRepo),
        RenewFamilyMemberSubscriptionUseCase(fakeRepo),
      );

      const initialPermissions = FamilyMemberPermissionsEntity(
        memberId: 'member-1',
        version: 2,
        values: {'editDailyMeals': false},
        groups: [],
      );

      fakeRepo.getPermissionsResult = const ApiSuccessResult(data: initialPermissions);
      viewModel.doIntent(const LoadFamilyMemberPermissionsEvent('member-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      viewModel.doIntent(const ToggleFamilyPermissionEvent('editDailyMeals', true));

      fakeRepo.updateResult = ApiErrorResult(
        failure: FamilyManagementFailure(
          errorMessage: 'Forbidden',
          code: 'auth.forbidden',
          statusCode: 403,
          isAuthForbidden: true,
          exception: const ApiException(
            message: 'Forbidden',
            statusCode: 403,
            errorType: ApiErrorType.other,
            backendErrorCode: 'auth.forbidden',
          ),
        ),
      );

      viewModel.doIntent(const UpdateFamilyMemberPermissionsEvent('member-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(viewModel.state.saveSuccessCount, 0);
      expect(viewModel.state.saveFailure, isNotNull);
      final failure = viewModel.state.saveFailure as FamilyManagementFailure;
      expect(failure.statusCode, 403);
    });
  });
}
