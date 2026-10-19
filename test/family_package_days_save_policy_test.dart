import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/repo/subscription_tier_repository.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/get_family_plan_durations_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/get_family_plan_tiers_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/domain/repo/family_package_days_repository.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/save_family_member_plan_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_programs/domain/repo/family_programs_repository.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_programs_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

void main() {
  test('custom duration can be cleared when switching members', () {
    const state = FamilyPackageDaysState(customDurationDays: 12);

    expect(
      state.copyWith(clearCustomDuration: true).customDurationDays,
      isNull,
    );
  });

  test('plan edits stay local until the user continues', () async {
    final planRepository = _CountingPlanRepository();
    final programsRepository = _ProgramsRepository();
    final viewModel = FamilyPackageDaysViewModel(
      GetFamilyFlowCurrentUseCase(_FlowRepository()),
      GetFamilyProgramsUseCase(programsRepository),
      GetFamilyProgramBundlesUseCase(programsRepository),
      GetFamilyPlanDurationsUseCase(planRepository),
      GetFamilyPlanTiersUseCase(planRepository),
      GetSubscriptionTierRestaurantsUseCase(_TierRepository()),
      SaveFamilyMemberPlanUseCase(planRepository),
    );

    viewModel.doIntent(const GetFamilySubscriptionCurrentEvent());
    await viewModel.stream.firstWhere((state) => state.currentFlow != null);
    viewModel.doIntent(const UpdateFamilyCustomDurationEvent(12));
    await Future<void>.delayed(Duration.zero);

    expect(planRepository.requests, 0);

    await viewModel.saveMemberPlanAndWait(
      memberId: 'member-1',
      programId: 'program-1',
      bundleId: 'bundle-1',
      tier: 1,
      durationDays: 12,
      includeFriday: false,
    );
    expect(planRepository.requests, 1);
    await viewModel.close();
  });

  test(
    'saveAllMemberPlansAndWait does not send save request if member plan has not changed',
    () async {
      final planRepository = _CountingPlanRepository();
      final programsRepository = _ProgramsRepository();
      const completedMember = FamilyMemberEntity(
        memberId: 'member-1',
        role: 2,
        displayName: 'Member',
        relationshipCode: 'self',
        gender: 1,
        ageYears: 20,
        setupStatus: 2,
        includeFriday: false,
        isCurrentUser: false,
        programId: 'program-1',
        bundleId: 'bundle-1',
        selectedTier: 1,
        durationDays: 16,
        subscribeNow: true,
      );

      final viewModel = FamilyPackageDaysViewModel(
        GetFamilyFlowCurrentUseCase(
          _FlowRepository(
            const FamilyFlowCurrentEntity(members: [completedMember]),
          ),
        ),
        GetFamilyProgramsUseCase(programsRepository),
        GetFamilyProgramBundlesUseCase(programsRepository),
        GetFamilyPlanDurationsUseCase(planRepository),
        GetFamilyPlanTiersUseCase(planRepository),
        GetSubscriptionTierRestaurantsUseCase(_TierRepository()),
        SaveFamilyMemberPlanUseCase(planRepository),
      );

      viewModel.doIntent(const GetFamilySubscriptionCurrentEvent());
      await viewModel.stream.firstWhere((state) => state.currentFlow != null);

      // Initial state has completed plan from backend; user does not change anything.
      final saved = await viewModel.saveAllMemberPlansAndWait();
      expect(saved, isTrue);
      // Should NOT send any save requests because data hasn't changed!
      expect(planRepository.requests, 0);

      // If user modifies duration, saveAllMemberPlansAndWait should send 1 save request
      viewModel.doIntent(const UpdateFamilyCustomDurationEvent(20));
      await Future<void>.delayed(Duration.zero);

      final savedAfterEdit = await viewModel.saveAllMemberPlansAndWait();
      expect(savedAfterEdit, isTrue);
      expect(planRepository.requests, 1);

      // If user calls saveAllMemberPlansAndWait again without further edits, it should skip saving
      final savedAgain = await viewModel.saveAllMemberPlansAndWait();
      expect(savedAgain, isTrue);
      expect(planRepository.requests, 1);

      await viewModel.close();
    },
  );
}

class _FlowRepository implements FamilySubscriptionSetupRepository {
  _FlowRepository([this._flow]);

  final FamilyFlowCurrentEntity? _flow;

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>>
  getFamilySubscriptionCurrent() async => ApiSuccessResult(
    data:
        _flow ??
        const FamilyFlowCurrentEntity(
          members: [
            FamilyMemberEntity(
              memberId: 'member-1',
              role: 2,
              displayName: 'Member',
              relationshipCode: 'self',
              gender: 1,
              ageYears: 20,
              setupStatus: 1,
              includeFriday: false,
              isCurrentUser: false,
              programId: 'program-1',
            ),
          ],
        ),
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ProgramsRepository implements FamilyProgramsRepository {
  @override
  Future<ApiResult<List<SubscriptionProgramEntity>>> getFamilyPrograms({
    int? page,
    int? pageSize,
  }) async => const ApiSuccessResult(data: []);

  @override
  Future<ApiResult<List<SubscriptionBundleEntity>>> getFamilyProgramBundles(
    String programId,
  ) async => const ApiSuccessResult(data: []);
}

class _TierRepository implements SubscriptionTierRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _CountingPlanRepository implements FamilyPackageDaysRepository {
  int requests = 0;

  @override
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required bool includeFriday,
  }) async => const ApiSuccessResult(data: []);

  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    String? bundleId,
    int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  }) async => const ApiSuccessResult(data: []);

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> saveFamilyMemberPlan({
    required String memberId,
    bool clearPlan = false,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
    String? startDate,
  }) async {
    requests++;
    return const ApiSuccessResult(data: FamilyFlowCurrentEntity());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
