import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/repo/subscription_tier_repository.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector_skeleton.dart';
import 'package:meal_meat_user/features/family_package_days/domain/repo/family_package_days_repository.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/get_family_plan_durations_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/get_family_plan_tiers_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/save_family_member_plan_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_content.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_setup_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_options_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_tiers_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/repo/family_programs_repository.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_programs_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';

void main() {
  group('Family Package Days Skeletons & Errors UI', () {
    testWidgets(
      'renders general skeleton only when members are empty and flow is loading',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const Scaffold(body: FamilyPackageDaysSetupLoadingSkeleton()),
          ),
        );

        expect(
          find.byType(FamilyPackageDaysSetupLoadingSkeleton),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows section-specific skeleton for bundles, durations, and tiers independently',
      (tester) async {
        const member = FamilyMemberEntity(
          memberId: 'm-1',
          role: 2,
          displayName: 'Test Member',
          relationshipCode: 'child',
          gender: 1,
          ageYears: 10,
          setupStatus: 1,
          programId: 'prog-1',
          includeFriday: false,
          isCurrentUser: false,
        );

        // 1. Bundles loading
        const bundlesLoadingState = FamilyPackageDaysState(
          isBundlesLoading: true,
          currentFlow: FamilyFlowCurrentEntity(members: [member]),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: FamilyPackageDaysContent(
                state: bundlesLoadingState,
                onNextPressed: () {},
              ),
            ),
          ),
        );

        expect(
          find.byType(FamilyPackageOptionsLoadingSkeleton),
          findsOneWidget,
        );

        // 2. Durations loading
        const durationsLoadingState = FamilyPackageDaysState(
          isDurationsLoading: true,
          currentFlow: FamilyFlowCurrentEntity(members: [member]),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: FamilyPackageDaysContent(
                state: durationsLoadingState,
                onNextPressed: () {},
              ),
            ),
          ),
        );

        expect(
          find.byType(SubscriptionDurationSelectorSkeleton),
          findsOneWidget,
        );

        // 3. Tiers loading
        const tiersLoadingState = FamilyPackageDaysState(
          isTiersLoading: true,
          currentFlow: FamilyFlowCurrentEntity(members: [member]),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: FamilyPackageDaysContent(
                state: tiersLoadingState,
                onNextPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(FamilyPackageTiersLoadingSkeleton), findsOneWidget);
      },
    );

    testWidgets(
      'bundles failure shows inline error without hiding successful durations',
      (tester) async {
        const member = FamilyMemberEntity(
          memberId: 'm-1',
          role: 2,
          displayName: 'Test Member',
          relationshipCode: 'child',
          gender: 1,
          ageYears: 10,
          setupStatus: 1,
          programId: 'prog-1',
          includeFriday: false,
          isCurrentUser: false,
        );

        final durations = [_createTestDuration(20)];

        final state = FamilyPackageDaysState(
          bundlesFailure: ServerFailure(
            errorMessage: 'bundles error',
            code: '500',
            exception: const ApiException(
              message: 'bundles error',
              errorType: ApiErrorType.unknown,
            ),
          ),
          durations: durations,
          selectedDurationIndex: 0,
          currentFlow: const FamilyFlowCurrentEntity(members: [member]),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: FamilyPackageDaysContent(
                state: state,
                onNextPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(InlineApiErrorWidget), findsOneWidget);
        expect(find.text('20'), findsOneWidget);
      },
    );

    testWidgets(
      'tiers failure shows inline error without hiding successful bundles and durations',
      (tester) async {
        const member = FamilyMemberEntity(
          memberId: 'm-1',
          role: 2,
          displayName: 'Test Member',
          relationshipCode: 'child',
          gender: 1,
          ageYears: 10,
          setupStatus: 1,
          programId: 'prog-1',
          includeFriday: false,
          isCurrentUser: false,
        );

        final bundles = [_createTestBundle('b-1', 'باقة التوفير')];

        final state = FamilyPackageDaysState(
          bundles: bundles,
          selectedBundleIndex: 0,
          tiersFailure: ServerFailure(
            errorMessage: 'tiers error',
            code: '500',
            exception: const ApiException(
              message: 'tiers error',
              errorType: ApiErrorType.unknown,
            ),
          ),
          currentFlow: const FamilyFlowCurrentEntity(members: [member]),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: FamilyPackageDaysContent(
                state: state,
                onNextPressed: () {},
              ),
            ),
          ),
        );

        expect(find.text('باقة التوفير'), findsOneWidget);
        expect(find.byType(InlineApiErrorWidget), findsOneWidget);
      },
    );
  });

  group('Family Package Days ViewModel Deduplication & Concurrency', () {
    test('fetches tiers again when returning to a member', () async {
      final planRepo = _MockPlanRepository();
      final programsRepo = _MockProgramsRepository();
      final vm = FamilyPackageDaysViewModel(
        GetFamilyFlowCurrentUseCase(_MockFlowRepositoryWithTwoMembers()),
        GetFamilyProgramsUseCase(programsRepo),
        GetFamilyProgramBundlesUseCase(programsRepo),
        GetFamilyPlanDurationsUseCase(planRepo),
        GetFamilyPlanTiersUseCase(planRepo),
        GetSubscriptionTierRestaurantsUseCase(_MockTierRepository()),
        SaveFamilyMemberPlanUseCase(planRepo),
      );

      vm.doIntent(const GetFamilySubscriptionCurrentEvent());
      await vm.stream.firstWhere((s) => s.currentFlow != null);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final initialCalls = planRepo.tiersCallCount;

      vm.doIntent(const SelectFamilyMemberPackageDaysEvent(1));
      await Future<void>.delayed(const Duration(milliseconds: 400));
      vm.doIntent(const SelectFamilyMemberPackageDaysEvent(0));
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(planRepo.tiersCallCount, initialCalls + 2);
      await vm.close();
    });

    test(
      'shares in-flight requests rather than triggering duplicate calls',
      () async {
        final mockProgramsRepo = _MockProgramsRepository();
        final mockPlanRepo = _MockPlanRepository();

        final vm = FamilyPackageDaysViewModel(
          GetFamilyFlowCurrentUseCase(_MockFlowRepository()),
          GetFamilyProgramsUseCase(mockProgramsRepo),
          GetFamilyProgramBundlesUseCase(mockProgramsRepo),
          GetFamilyPlanDurationsUseCase(mockPlanRepo),
          GetFamilyPlanTiersUseCase(mockPlanRepo),
          GetSubscriptionTierRestaurantsUseCase(_MockTierRepository()),
          SaveFamilyMemberPlanUseCase(mockPlanRepo),
        );

        // Fire multiple simultaneous GetFamilyProgramsEvent
        vm.doIntent(const GetFamilyProgramsEvent());
        vm.doIntent(const GetFamilyProgramsEvent());

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(mockProgramsRepo.programsCallCount, 1);
        await vm.close();
      },
    );

    test('ignores stale response when member is switched rapidly', () async {
      final mockPlanRepo = _DelayedMockPlanRepository();
      final mockProgramsRepo = _MockProgramsRepository();

      final vm = FamilyPackageDaysViewModel(
        GetFamilyFlowCurrentUseCase(_MockFlowRepositoryWithTwoMembers()),
        GetFamilyProgramsUseCase(mockProgramsRepo),
        GetFamilyProgramBundlesUseCase(mockProgramsRepo),
        GetFamilyPlanDurationsUseCase(mockPlanRepo),
        GetFamilyPlanTiersUseCase(mockPlanRepo),
        GetSubscriptionTierRestaurantsUseCase(_MockTierRepository()),
        SaveFamilyMemberPlanUseCase(mockPlanRepo),
      );

      vm.doIntent(const GetFamilySubscriptionCurrentEvent());
      await vm.stream.firstWhere((s) => s.currentFlow != null);

      // Rapidly switch member from 0 to 1
      vm.doIntent(const SelectFamilyMemberPackageDaysEvent(1));

      // Wait for delayed tasks
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(vm.state.selectedMemberIndex, 1);
      expect(vm.state.selectedMember?.memberId, 'm-2');

      await vm.close();
    });

    test('debounces custom duration changes before reloading tiers', () async {
      final mockPlanRepo = _MockPlanRepository();
      final mockProgramsRepo = _MockProgramsRepository();

      final vm = FamilyPackageDaysViewModel(
        GetFamilyFlowCurrentUseCase(_MockFlowRepository()),
        GetFamilyProgramsUseCase(mockProgramsRepo),
        GetFamilyProgramBundlesUseCase(mockProgramsRepo),
        GetFamilyPlanDurationsUseCase(mockPlanRepo),
        GetFamilyPlanTiersUseCase(mockPlanRepo),
        GetSubscriptionTierRestaurantsUseCase(_MockTierRepository()),
        SaveFamilyMemberPlanUseCase(mockPlanRepo),
      );

      vm.doIntent(const GetFamilySubscriptionCurrentEvent());
      await vm.stream.firstWhere((s) => s.currentFlow != null);

      final initialTiersCalls = mockPlanRepo.tiersCallCount;

      // Rapid updates to custom duration
      vm.doIntent(const UpdateFamilyCustomDurationEvent(10));
      vm.doIntent(const UpdateFamilyCustomDurationEvent(12));
      vm.doIntent(const UpdateFamilyCustomDurationEvent(15));

      // Immediately after: should NOT have made 3 calls
      expect(mockPlanRepo.tiersCallCount, initialTiersCalls);

      // Wait for debounce timer (350ms) to fire
      await Future<void>.delayed(const Duration(milliseconds: 450));

      expect(mockPlanRepo.tiersCallCount, initialTiersCalls + 1);

      await vm.close();
    });

    test('saving plan updates flow and preserves save contract', () async {
      final mockPlanRepo = _MockPlanRepository();
      final mockProgramsRepo = _MockProgramsRepository();

      final vm = FamilyPackageDaysViewModel(
        GetFamilyFlowCurrentUseCase(_MockFlowRepository()),
        GetFamilyProgramsUseCase(mockProgramsRepo),
        GetFamilyProgramBundlesUseCase(mockProgramsRepo),
        GetFamilyPlanDurationsUseCase(mockPlanRepo),
        GetFamilyPlanTiersUseCase(mockPlanRepo),
        GetSubscriptionTierRestaurantsUseCase(_MockTierRepository()),
        SaveFamilyMemberPlanUseCase(mockPlanRepo),
      );

      vm.doIntent(const GetFamilySubscriptionCurrentEvent());
      await vm.stream.firstWhere((s) => s.currentFlow != null);

      final saved = await vm.saveMemberPlanAndWait(
        memberId: 'm-1',
        programId: 'prog-1',
        bundleId: 'bundle-1',
        tier: 1,
        durationDays: 20,
        includeFriday: false,
      );

      expect(saved, isTrue);
      expect(mockPlanRepo.saveCallCount, 1);
      expect(vm.state.isPlanSaving, isFalse);

      await vm.close();
    });

    test(
      'local plan completion updates isMemberPlanReady and completedMembersCount reactively',
      () {
        const member1 = FamilyMemberEntity(
          memberId: 'm-1',
          role: 1,
          displayName: 'wwss',
          relationshipCode: 'self',
          gender: 1,
          ageYears: 30,
          setupStatus: 2,
          programId: 'prog-1',
          includeFriday: false,
          isCurrentUser: true,
        );
        const member2 = FamilyMemberEntity(
          memberId: 'm-2',
          role: 2,
          displayName: 'wew',
          relationshipCode: 'child',
          gender: 1,
          ageYears: 5,
          setupStatus: 1,
          programId: 'prog-1',
          includeFriday: false,
          isCurrentUser: false,
        );

        const stateInitial = FamilyPackageDaysState(
          currentFlow: FamilyFlowCurrentEntity(
            members: [member1, member2],
          ),
          selectedMemberIndex: 1,
        );

        expect(stateInitial.isMemberPlanReady(member1), isTrue);
        expect(stateInitial.isMemberPlanReady(member2), isFalse);
        expect(stateInitial.completedMembersCount, 1);

        final stateWithSelections = stateInitial.copyWith(
          bundles: [_createTestBundle('bundle-1', 'Bundle 1')],
          selectedBundleIndex: 0,
          durations: [_createTestDuration(6)],
          selectedDurationIndex: 0,
          tiers: [_createTestTier('1')],
          selectedTierIndex: 0,
        );

        expect(stateWithSelections.isMemberPlanReady(member2), isTrue);
        expect(stateWithSelections.completedMembersCount, 2);
      },
    );
  });
}

SubscriptionTierEntity _createTestTier(String tier) {
  return SubscriptionTierEntity(
    tier: tier,
    nameAr: 'أساسي',
    nameEn: 'Basic',
    logoUrl: null,
    descriptionAr: '',
    descriptionEn: '',
    restaurantCount: 1,
    restaurants: const [],
    currencyCode: 'KWD',
    selectionCount: 1,
    isRecommended: false,
    includeFriday: false,
  );
}

SubscriptionDurationEntity _createTestDuration(int days) {
  return SubscriptionDurationEntity(
    durationDays: days,
    nameAr: '$days يوم',
    nameEn: '$days Days',
    selectionCount: 10,
    isPopular: false,
    isCustom: false,
    minDays: null,
    maxDays: null,
    badge: null,
    supportsFriday: true,
    includeFriday: false,
    fridayDays: 0,
    totalServiceDays: days,
    fridayOption: const SubscriptionFridayOptionEntity(
      code: 'none',
      nameAr: '',
      nameEn: '',
      defaultSelected: false,
      isEnabled: true,
    ),
    fridayAvailability: const SubscriptionFridayAvailabilityEntity(
      isAvailable: true,
      restaurantCount: 1,
      code: 'ok',
      messageAr: '',
      messageEn: '',
      displayType: 'default',
    ),
  );
}

SubscriptionBundleEntity _createTestBundle(String id, String name) {
  return SubscriptionBundleEntity(
    bundleId: id,
    programId: 'prog-1',
    code: id,
    nameAr: name,
    nameEn: name,
    descriptionAr: '',
    descriptionEn: '',
    imageUrl: null,
    mealsPerDay: 2,
    breakfastCount: 1,
    lunchCount: 1,
    dinnerCount: 0,
    snackCount: 0,
    slots: const [],
    restaurantCount: 1,
    restaurants: const [],
    selectionCount: 5,
    isMostSelected: false,
    badge: null,
  );
}

class _MockFlowRepository implements FamilySubscriptionSetupRepository {
  @override
  Future<ApiResult<FamilyFlowCurrentEntity>>
  getFamilySubscriptionCurrent() async {
    return const ApiSuccessResult(
      data: FamilyFlowCurrentEntity(
        name: 'Family',
        members: [
          FamilyMemberEntity(
            memberId: 'm-1',
            role: 2,
            displayName: 'Member One',
            relationshipCode: 'self',
            gender: 1,
            ageYears: 25,
            setupStatus: 1,
            programId: 'prog-1',
            includeFriday: false,
            isCurrentUser: false,
          ),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockFlowRepositoryWithTwoMembers
    implements FamilySubscriptionSetupRepository {
  @override
  Future<ApiResult<FamilyFlowCurrentEntity>>
  getFamilySubscriptionCurrent() async {
    return const ApiSuccessResult(
      data: FamilyFlowCurrentEntity(
        name: 'Family',
        members: [
          FamilyMemberEntity(
            memberId: 'm-1',
            role: 2,
            displayName: 'Member One',
            relationshipCode: 'self',
            gender: 1,
            ageYears: 25,
            setupStatus: 1,
            programId: 'prog-1',
            includeFriday: false,
            isCurrentUser: false,
          ),
          FamilyMemberEntity(
            memberId: 'm-2',
            role: 2,
            displayName: 'Member Two',
            relationshipCode: 'child',
            gender: 2,
            ageYears: 12,
            setupStatus: 1,
            programId: 'prog-1',
            includeFriday: false,
            isCurrentUser: false,
          ),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockProgramsRepository implements FamilyProgramsRepository {
  int programsCallCount = 0;

  @override
  Future<ApiResult<List<SubscriptionProgramEntity>>> getFamilyPrograms({
    int? page,
    int? pageSize,
  }) async {
    programsCallCount++;
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return const ApiSuccessResult(
      data: [
        SubscriptionProgramEntity(
          programId: 'prog-1',
          code: 'prog-1',
          shortCode: 'p1',
          nameAr: 'برنامج',
          nameEn: 'Program',
          descriptionAr: '',
          descriptionEn: '',
          keywordsAr: [],
          keywordsEn: [],
          imageUrl: null,
          bundleCount: 1,
          supportedSlots: [],
          fallbackImageAsset: '',
        ),
      ],
    );
  }

  @override
  Future<ApiResult<List<SubscriptionBundleEntity>>> getFamilyProgramBundles(
    String programId,
  ) async {
    return const ApiSuccessResult(data: []);
  }
}

class _MockTierRepository implements SubscriptionTierRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockPlanRepository implements FamilyPackageDaysRepository {
  int tiersCallCount = 0;
  int saveCallCount = 0;

  @override
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required bool includeFriday,
  }) async {
    return const ApiSuccessResult(data: []);
  }

  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    String? bundleId,
    int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  }) async {
    tiersCallCount++;
    return const ApiSuccessResult(data: []);
  }

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
    saveCallCount++;
    return const ApiSuccessResult(data: FamilyFlowCurrentEntity());
  }
}

class _DelayedMockPlanRepository implements FamilyPackageDaysRepository {
  @override
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required bool includeFriday,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const ApiSuccessResult(data: []);
  }

  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    String? bundleId,
    int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const ApiSuccessResult(data: []);
  }

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
    return const ApiSuccessResult(data: FamilyFlowCurrentEntity());
  }
}
