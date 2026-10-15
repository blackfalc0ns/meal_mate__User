import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_capabilities_usecase.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_home_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/repo/family_overview_repository.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/usecase/get_family_switcher_usecase.dart';

class FakeFamilyMemberRepository implements FamilyMemberRepository {
  List<FamilyCapabilityEntity> capabilitiesToReturn = const [];

  @override
  Future<ApiResult<List<FamilyCapabilityEntity>>> getMemberCapabilities(
    String memberId,
  ) async {
    return ApiSuccessResult(data: capabilitiesToReturn);
  }

  @override
  Future<ApiResult<void>> detachMember(String memberId) async =>
      const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<FamilyMemberDetailEntity>> getFamilyMemberDetail(
    String memberId, {
    String locale = 'ar',
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<FamilyMemberAccessEntity>> getMemberAccess(
    String memberId,
  ) async => throw UnimplementedError();

  @override
  Future<ApiResult<FamilyMemberAccessEntity>> updateMemberAccess(
    String memberId,
    UpdateFamilyMemberAccessRequestDto request,
  ) async => throw UnimplementedError();

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> getMemberPermissions(
    String memberId, {
    String locale = 'ar',
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> updateMemberPermissions(
    String memberId,
    UpdateFamilyMemberPermissionsRequestDto request, {
    String locale = 'ar',
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<void>> updateMemberBasicInfo(
    String memberId,
    FamilyMemberWriteRequestDto request,
  ) async => const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<void>> renewMemberSubscription(
    String renewalPath,
  ) async => const ApiSuccessResult(data: null);
}

class FakeFamilyOverviewRepository implements FamilyOverviewRepository {
  List<FamilyMemberSummaryEntity> switcherToReturn = const [];

  @override
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getFamilySwitcher({
    String locale = 'ar',
  }) async {
    return ApiSuccessResult(data: switcherToReturn);
  }

  @override
  Future<ApiResult<FamilyHomeEntity>> getFamilyHome({
    String locale = 'ar',
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getFamilyMembers({
    String locale = 'ar',
  }) async => throw UnimplementedError();
}

void main() {
  group('Task 3: Manager Home, Roster, Switcher, Detail & Capability Reads', () {
    test('GetFamilyMemberCapabilitiesUseCase delegates to repository and returns member capabilities', () async {
      final repo = FakeFamilyMemberRepository();
      repo.capabilitiesToReturn = [
        const FamilyCapabilityEntity(
          action: 'viewCalendar',
          allowed: true,
        ),
        const FamilyCapabilityEntity(
          action: 'editDailyMeals',
          allowed: false,
          reasonCode: 'permissions.read_only',
        ),
      ];

      final useCase = GetFamilyMemberCapabilitiesUseCase(repo);
      final result = await useCase('member-uuid-123');

      expect(result, isA<ApiSuccessResult<List<FamilyCapabilityEntity>>>());
      final data = (result as ApiSuccessResult<List<FamilyCapabilityEntity>>).data;
      expect(data.length, 2);
      expect(data[0].action, 'viewCalendar');
      expect(data[0].allowed, true);
      expect(data[1].action, 'editDailyMeals');
      expect(data[1].allowed, false);
      expect(data[1].reasonCode, 'permissions.read_only');
    });

    test('GetFamilySwitcherUseCase delegates to repository switcher route', () async {
      final repo = FakeFamilyOverviewRepository();
      repo.switcherToReturn = [
        const FamilyMemberSummaryEntity(
          memberId: 'm1',
          displayName: 'Yahya',
          role: 1,
          ageYears: 32,
          isPaused: false,
          subscriptionId: 'sub-1',
          programName: 'Balanced',
          remainingDays: 20,
          setupStatus: 3,
        ),
      ];

      final useCase = GetFamilySwitcherUseCase(repo);
      final result = await useCase();

      expect(result, isA<ApiSuccessResult<List<FamilyMemberSummaryEntity>>>());
      final data = (result as ApiSuccessResult<List<FamilyMemberSummaryEntity>>).data;
      expect(data.length, 1);
      expect(data[0].displayName, 'Yahya');
      expect(data[0].isManager, true);
    });

    test('FamilyMemberDetailEntity accurately distinguishes paid-preparing, detached, disabled, paused and setup-required', () {
      const paidPreparing = FamilyMemberDetailEntity(
        memberId: 'm1',
        displayName: 'Member 1',
        role: 2,
        ageYears: 25,
        isPaused: false,
        subscriptionId: 'sub-1',
        programName: 'Diet',
        remainingDays: 14,
        setupStatus: 3,
        canRenew: false,
        paymentStatus: 'Paid',
        fulfillmentStatus: 'Preparing',
      );
      expect(paidPreparing.isPaidPreparingCalendar, true);
      expect(paidPreparing.isDetached, false);
      expect(paidPreparing.isDisabled, false);

      const detached = FamilyMemberDetailEntity(
        memberId: 'm2',
        displayName: 'Member 2',
        role: 2,
        ageYears: 20,
        isPaused: false,
        subscriptionId: 'sub-2',
        programName: 'Keto',
        remainingDays: 10,
        setupStatus: 3,
        canRenew: false,
        accessStatus: 'Detached',
      );
      expect(detached.isDetached, true);
      expect(detached.isPaidPreparingCalendar, false);

      const disabled = FamilyMemberDetailEntity(
        memberId: 'm3',
        displayName: 'Member 3',
        role: 2,
        ageYears: 20,
        isPaused: true,
        subscriptionId: 'sub-3',
        programName: 'Keto',
        remainingDays: 10,
        setupStatus: 3,
        canRenew: false,
        accessStatus: 'Disabled',
      );
      expect(disabled.isDisabled, true);
      expect(disabled.isPaused, true);

      const setupRequired = FamilyMemberDetailEntity(
        memberId: 'm4',
        displayName: 'Member 4',
        role: 2,
        ageYears: 20,
        isPaused: false,
        subscriptionId: null,
        programName: '',
        remainingDays: 0,
        setupStatus: 0,
        canRenew: false,
      );
      expect(setupRequired.isSetupRequired, true);
      expect(setupRequired.hasPlan, false);
    });
  });
}
