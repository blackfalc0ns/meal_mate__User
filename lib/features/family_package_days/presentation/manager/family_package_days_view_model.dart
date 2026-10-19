import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/save_family_member_plan_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/get_family_plan_durations_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/get_family_plan_tiers_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_programs_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilyPackageDaysViewModel extends Cubit<FamilyPackageDaysState> {
  FamilyPackageDaysViewModel(
    this._getFamilyFlowCurrentUseCase,
    this._getFamilyProgramsUseCase,
    this._getFamilyProgramBundlesUseCase,
    this._getFamilyPlanDurationsUseCase,
    this._getFamilyPlanTiersUseCase,
    this._getSubscriptionTierRestaurantsUseCase,
    this._saveFamilyMemberPlanUseCase, [
    FamilyFlowSnapshotStore? snapshotStore,
  ]) : _snapshotStore = snapshotStore ?? FamilyFlowSnapshotStore(),
       super(const FamilyPackageDaysState());

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final GetFamilyProgramsUseCase _getFamilyProgramsUseCase;
  final GetFamilyProgramBundlesUseCase _getFamilyProgramBundlesUseCase;
  final GetFamilyPlanDurationsUseCase _getFamilyPlanDurationsUseCase;
  final GetFamilyPlanTiersUseCase _getFamilyPlanTiersUseCase;
  final GetSubscriptionTierRestaurantsUseCase
  _getSubscriptionTierRestaurantsUseCase;
  final SaveFamilyMemberPlanUseCase _saveFamilyMemberPlanUseCase;
  final FamilyFlowSnapshotStore _snapshotStore;

  int _tiersRequestToken = 0;
  int _flowRequestToken = 0;
  int _memberSelectionToken = 0;

  final Map<String, List<SubscriptionBundleEntity>> _bundlesCache = {};
  final Map<String, List<SubscriptionDurationEntity>> _durationsCache = {};

  final Map<String, Future<ApiResult<List<SubscriptionProgramEntity>>>>
  _inFlightPrograms = {};
  final Map<String, Future<ApiResult<List<SubscriptionBundleEntity>>>>
  _inFlightBundles = {};
  final Map<String, Future<ApiResult<List<SubscriptionDurationEntity>>>>
  _inFlightDurations = {};
  final Map<String, Future<ApiResult<List<SubscriptionTierEntity>>>>
  _inFlightTiers = {};
  final Map<String, Future<void>> _inFlightMemberLoads = {};

  Timer? _customDurationDebounce;

  void _emit(FamilyPackageDaysState state) {
    if (isClosed) return;
    emit(state);
  }

  void doIntent(FamilyPackageDaysEvent event) {
    if (isClosed) return;
    switch (event) {
      case GetFamilySubscriptionCurrentEvent():
        unawaited(_getFamilySubscriptionCurrent(memberId: event.memberId));
      case GetFamilyProgramsEvent():
        unawaited(_loadPrograms());
      case GetFamilyBundlesEvent():
        unawaited(_loadBundles(event.programId));
      case SelectFamilyBundleEvent():
        _selectBundle(event.bundleIndex);
      case SelectFamilyDurationEvent():
        _selectDuration(event.durationIndex);
      case UpdateFamilyCustomDurationEvent():
        _updateCustomDuration(event.durationDays ?? 0);
      case ToggleFamilyFridayEvent():
        _toggleFriday(event.includeFriday);
      case SelectFamilyTierEvent():
        _selectTier(event.tierIndex);
      case BrowseFamilyTierRestaurantsEvent():
        unawaited(_browseTierRestaurants(event.tierIndex));
      case CloseFamilyBrowseRestaurantsEvent():
        _emit(state.copyWith(isRestaurantsView: false));
      case SelectFamilyMemberEvent():
        _selectMember(event.memberIndex);
      case SelectFamilyMemberPackageDaysEvent():
        _selectMemberInPackageDays(event.memberIndex);
      case SaveFamilyMemberPlanEvent():
        unawaited(
          _saveMemberPlan(
            memberId: event.memberId,
            programId: event.programId,
            bundleId: event.bundleId,
            tier: event.tier,
            durationDays: event.durationDays,
            includeFriday: event.includeFriday,
            startDate: event.startDate,
          ),
        );
      case ClearFamilyMemberPlanEvent():
        unawaited(_saveMemberPlan(memberId: event.memberId, clearPlan: true));
      case RetryFamilyBundlesEvent():
        unawaited(_retryBundles());
      case RetryFamilyDurationsEvent():
        unawaited(_retryDurations());
      case RetryFamilyTiersEvent():
        unawaited(_retryTiers());
    }
  }

  Future<void> _getFamilySubscriptionCurrent({String? memberId}) async {
    final token = ++_flowRequestToken;
    _emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    if (isClosed || token != _flowRequestToken) return;
    switch (result) {
      case ApiSuccessResult():
        final flow = result.data;
        _syncConvertedDraftFlag(flow);
        final firstPlannedIndex = flow.members.indexWhere(
          (member) => member.hasProgram && member.memberSubscriptionId == null,
        );
        final targetIndex = flow.members.indexWhere(
          (member) => member.memberId == memberId,
        );
        final currentIndexIsPlanned =
            state.selectedMemberIndex >= 0 &&
            state.selectedMemberIndex < flow.members.length &&
            flow.members[state.selectedMemberIndex].hasProgram &&
            flow.members[state.selectedMemberIndex].memberSubscriptionId ==
                null;
        final selectedIndex = targetIndex >= 0
            ? targetIndex
            : currentIndexIsPlanned
            ? state.selectedMemberIndex
            : (firstPlannedIndex >= 0 ? firstPlannedIndex : 0);
        final member = flow.members.isNotEmpty
            ? flow.members[selectedIndex]
            : null;
        _emit(
          state.copyWith(
            isCurrentFlowLoading: false,
            currentFlow: flow,
            selectedMemberIndex: selectedIndex,
            includeFriday: member?.includeFriday ?? state.includeFriday,
            customDurationDays:
                member?.durationDays ?? state.customDurationDays,
          ),
        );
        if (member != null) {
          final memberToken = ++_memberSelectionToken;
          await _loadMemberData(member, memberToken: memberToken);
        }
      case ApiErrorResult():
        _emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _loadPrograms() async {
    const key = 'programs';
    final inFlight = _inFlightPrograms[key];
    final Future<ApiResult<List<SubscriptionProgramEntity>>> future;
    if (inFlight != null) {
      future = inFlight;
    } else {
      _emit(
        state.copyWith(isProgramsLoading: true, clearProgramsFailure: true),
      );
      future = _getFamilyProgramsUseCase();
      _inFlightPrograms[key] = future;
    }

    final result = await future;
    _inFlightPrograms.remove(key);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final programs = result.data
            .where((p) => p.programId.isNotEmpty)
            .toList();
        _emit(
          state.copyWith(
            isProgramsLoading: false,
            programs: programs,
            clearProgramsFailure: true,
          ),
        );
        final member = state.selectedMember;
        if (member != null && state.bundles.isEmpty) {
          await _loadMemberData(member, memberToken: _memberSelectionToken);
        }
      case ApiErrorResult():
        _emit(
          state.copyWith(
            isProgramsLoading: false,
            programsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadBundles(
    String programId, {
    FamilyMemberEntity? member,
    int? memberToken,
  }) async {
    final cached = _bundlesCache[programId];
    if (cached != null) {
      if (isClosed) return;
      if (memberToken != null && memberToken != _memberSelectionToken) return;
      int? bundleIdx;
      final targetBundleId = member?.bundleId ?? state.selectedBundle?.bundleId;
      if (targetBundleId != null && targetBundleId.isNotEmpty) {
        final found = cached.indexWhere(
          (b) => b.bundleId == targetBundleId && b.canSelect,
        );
        if (found != -1) bundleIdx = found;
      }
      _emit(
        state.copyWith(
          isBundlesLoading: false,
          bundles: cached,
          selectedBundleIndex: bundleIdx,
          clearSelectedBundle: bundleIdx == null,
          clearBundlesFailure: true,
        ),
      );
      return;
    }

    final inFlight = _inFlightBundles[programId];
    final Future<ApiResult<List<SubscriptionBundleEntity>>> future;
    if (inFlight != null) {
      future = inFlight;
    } else {
      _emit(state.copyWith(isBundlesLoading: true, clearBundlesFailure: true));
      future = _getFamilyProgramBundlesUseCase(programId);
      _inFlightBundles[programId] = future;
    }

    final result = await future;
    _inFlightBundles.remove(programId);
    if (isClosed) return;
    if (memberToken != null && memberToken != _memberSelectionToken) return;

    switch (result) {
      case ApiSuccessResult():
        final bundles = result.data
            .where((b) => b.bundleId.isNotEmpty)
            .toList();
        _bundlesCache[programId] = bundles;
        int? bundleIdx;
        final targetBundleId =
            member?.bundleId ?? state.selectedBundle?.bundleId;
        if (targetBundleId != null && targetBundleId.isNotEmpty) {
          final found = bundles.indexWhere(
            (b) => b.bundleId == targetBundleId && b.canSelect,
          );
          if (found != -1) bundleIdx = found;
        }
        _emit(
          state.copyWith(
            isBundlesLoading: false,
            bundles: bundles,
            selectedBundleIndex: bundleIdx,
            clearSelectedBundle: bundleIdx == null,
            clearBundlesFailure: true,
          ),
        );
      case ApiErrorResult():
        _emit(
          state.copyWith(
            isBundlesLoading: false,
            bundlesFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadDurations({
    required String programId,
    required bool includeFriday,
    FamilyMemberEntity? member,
    int? memberToken,
  }) async {
    final durationsKey = '$programId|$includeFriday';
    final cached = _durationsCache[durationsKey];
    if (cached != null) {
      if (isClosed) return;
      if (memberToken != null && memberToken != _memberSelectionToken) return;
      final targetDays = member?.durationDays ?? state.customDurationDays;
      int? durationIdx;
      if (targetDays != null) {
        final found = cached.indexWhere((d) => d.durationDays == targetDays);
        if (found != -1) durationIdx = found;
      }
      _emit(
        state.copyWith(
          isDurationsLoading: false,
          durations: cached,
          selectedDurationIndex: durationIdx,
          clearSelectedDuration: durationIdx == null,
          customDurationDays: targetDays,
          clearCustomDuration: targetDays == null,
          includeFriday: includeFriday,
          clearDurationsFailure: true,
        ),
      );
      return;
    }

    final inFlight = _inFlightDurations[durationsKey];
    final Future<ApiResult<List<SubscriptionDurationEntity>>> future;
    if (inFlight != null) {
      future = inFlight;
    } else {
      _emit(
        state.copyWith(isDurationsLoading: true, clearDurationsFailure: true),
      );
      future = _getFamilyPlanDurationsUseCase(
        programId: programId,
        includeFriday: includeFriday,
      );
      _inFlightDurations[durationsKey] = future;
    }

    final result = await future;
    _inFlightDurations.remove(durationsKey);
    if (isClosed) return;
    if (memberToken != null && memberToken != _memberSelectionToken) return;

    switch (result) {
      case ApiSuccessResult():
        final durations = result.data;
        _durationsCache[durationsKey] = durations;
        final targetDays = member?.durationDays ?? state.customDurationDays;
        int? durationIdx;
        if (targetDays != null) {
          final found = durations.indexWhere(
            (d) => d.durationDays == targetDays,
          );
          if (found != -1) durationIdx = found;
        }
        _emit(
          state.copyWith(
            isDurationsLoading: false,
            durations: durations,
            selectedDurationIndex: durationIdx,
            clearSelectedDuration: durationIdx == null,
            customDurationDays: targetDays,
            clearCustomDuration: targetDays == null,
            includeFriday: includeFriday,
            clearDurationsFailure: true,
          ),
        );
      case ApiErrorResult():
        _emit(
          state.copyWith(
            isDurationsLoading: false,
            durationsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadTiers({
    required String programId,
    String? bundleId,
    int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
    FamilyMemberEntity? member,
    int? memberToken,
  }) async {
    final tiersKey = _tiersKey(
      programId: programId,
      bundleId: bundleId,
      durationDays: durationDays,
      includeFriday: includeFriday,
      familyMemberId: familyMemberId,
    );
    final requestToken = ++_tiersRequestToken;

    final inFlight = _inFlightTiers[tiersKey];
    final Future<ApiResult<List<SubscriptionTierEntity>>> future;
    if (inFlight != null) {
      future = inFlight;
    } else {
      _emit(
        state.copyWith(
          isTiersLoading: true,
          clearTiersFailure: true,
          clearSelectedTier: member?.selectedTier == null,
        ),
      );
      future = _getFamilyPlanTiersUseCase(
        programId: programId,
        bundleId: bundleId,
        durationDays: durationDays,
        includeFriday: includeFriday,
        familyMemberId: familyMemberId,
      );
      _inFlightTiers[tiersKey] = future;
    }

    final result = await future;
    _inFlightTiers.remove(tiersKey);
    if (isClosed) return;
    if (memberToken != null && memberToken != _memberSelectionToken) return;
    if (requestToken != _tiersRequestToken) return;

    switch (result) {
      case ApiSuccessResult():
        final tiers = result.data;
        int? tierIdx;
        final targetTier = member?.selectedTier;
        if (targetTier != null) {
          final found = tiers.indexWhere(
            (t) =>
                (_parseTierToInt(t.tier, t.nameEn) ?? (tiers.indexOf(t) + 1)) ==
                targetTier,
          );
          if (found != -1) tierIdx = found;
        }
        _emit(
          state.copyWith(
            isTiersLoading: false,
            tiers: tiers,
            selectedTierIndex: tierIdx,
            clearSelectedTier: tierIdx == null,
            clearTiersFailure: true,
          ),
        );
      case ApiErrorResult():
        _emit(
          state.copyWith(isTiersLoading: false, tiersFailure: result.failure),
        );
    }
  }

  Future<void> _loadMemberData(
    FamilyMemberEntity member, {
    int? memberToken,
  }) async {
    final programId =
        member.programId ??
        state.selectedProgram?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : null);
    if (programId == null || programId.isEmpty) return;

    final loadKey =
        '${member.memberId}|$programId|${member.bundleId}|'
        '${member.durationDays}|${member.includeFriday}';

    final inFlight = _inFlightMemberLoads[loadKey];
    if (inFlight != null) {
      await inFlight;
      return;
    }

    final future = _doLoadMemberData(
      member,
      programId,
      memberToken: memberToken,
    );
    _inFlightMemberLoads[loadKey] = future;
    try {
      await future;
    } finally {
      _inFlightMemberLoads.remove(loadKey);
    }
  }

  Future<void> _doLoadMemberData(
    FamilyMemberEntity member,
    String programId, {
    int? memberToken,
  }) async {
    if (member.programId == null || member.programId!.isEmpty) {
      final updatedMembers = state.members.map((m) {
        if (m.memberId == member.memberId) {
          return m.copyWith(programId: programId);
        }
        return m;
      }).toList();
      final updatedFlow = state.currentFlow?.copyWith(members: updatedMembers);
      if (updatedFlow != null) _snapshotStore.update(updatedFlow);
      _emit(state.copyWith(currentFlow: updatedFlow));
    }

    await Future.wait([
      _loadBundles(programId, member: member, memberToken: memberToken),
      _loadDurations(
        programId: programId,
        includeFriday: member.includeFriday,
        member: member,
        memberToken: memberToken,
      ),
      _loadTiers(
        programId: programId,
        bundleId: member.bundleId,
        durationDays: member.durationDays,
        includeFriday: member.includeFriday,
        familyMemberId: member.memberId,
        member: member,
        memberToken: memberToken,
      ),
    ]);
  }

  String _tiersKey({
    required String programId,
    required String? bundleId,
    required int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  }) => '$programId|$bundleId|$durationDays|$includeFriday|$familyMemberId';

  int? _parseTierToInt(String tierStr, [String? nameEn]) {
    final direct = int.tryParse(tierStr);
    if (direct != null) return direct;
    final lower = tierStr.toLowerCase().trim();
    final name = (nameEn ?? '').toLowerCase().trim();
    if (lower == 'basic' ||
        lower == 'select' ||
        lower == '1' ||
        name.contains('basic')) {
      return 1;
    }
    if (lower == 'platinum' ||
        lower == 'plat' ||
        lower == 'plus' ||
        lower == '2' ||
        name.contains('plat') ||
        name.contains('plus')) {
      return 2;
    }
    if (lower == 'elite' ||
        lower == 'max' ||
        lower == '3' ||
        name.contains('elite') ||
        name.contains('max')) {
      return 3;
    }
    return null;
  }

  void _selectMember(int index) {
    if (index < 0 || index >= state.members.length) return;
    _emit(state.copyWith(selectedMemberIndex: index));
  }

  void _selectMemberInPackageDays(int index) {
    if (index < 0 || index >= state.members.length) return;
    if (index == state.selectedMemberIndex && !state.isMemberChanging) return;
    final member = state.members[index];
    final memberToken = ++_memberSelectionToken;

    _emit(
      state.copyWith(
        selectedMemberIndex: index,
        isMemberChanging: true,
        clearSelectedBundle:
            member.bundleId == null || member.bundleId!.isEmpty,
        clearSelectedDuration: member.durationDays == null,
        clearSelectedTier: member.selectedTier == null,
        clearBrowseRestaurants: true,
        customDurationDays: member.durationDays,
        clearCustomDuration: member.durationDays == null,
        includeFriday: member.includeFriday,
        isRestaurantsView: false,
        clearBundlesFailure: true,
        clearDurationsFailure: true,
        clearTiersFailure: true,
      ),
    );
    unawaited(_loadMemberDataWithShimmer(member, memberToken: memberToken));
  }

  Future<void> _loadMemberDataWithShimmer(
    FamilyMemberEntity member, {
    int? memberToken,
  }) async {
    final stopwatch = Stopwatch()..start();
    await _loadMemberData(member, memberToken: memberToken);
    final elapsed = stopwatch.elapsedMilliseconds;
    if (elapsed < 350) {
      await Future<void>.delayed(Duration(milliseconds: 350 - elapsed));
    }
    if (isClosed ||
        (memberToken != null && memberToken != _memberSelectionToken)) {
      return;
    }
    _emit(state.copyWith(isMemberChanging: false));
  }

  void _selectBundle(int index) {
    if (state.isSelectedManagerPlanLocked) return;
    final bundle = state.bundles.length > index ? state.bundles[index] : null;
    if (bundle == null || !bundle.canSelect) return;
    final updatedFlow = _updateLocalMemberInCurrentFlow(
      bundleId: bundle.bundleId,
    );
    _emit(
      state.copyWith(
        selectedBundleIndex: index,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );
    unawaited(_reloadTiersForCurrentPlan(bundleId: bundle.bundleId));
  }

  void _selectDuration(int index) {
    if (state.isSelectedManagerPlanLocked) return;
    final duration = state.durations.length > index
        ? state.durations[index]
        : null;
    if (duration == null) return;
    final days = duration.durationDays;
    final updatedFlow = _updateLocalMemberInCurrentFlow(
      durationDays: days,
      includeFriday: state.includeFriday,
    );
    _emit(
      state.copyWith(
        selectedDurationIndex: index,
        customDurationDays: days,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );
    unawaited(_reloadTiersForCurrentPlan(durationDays: days));
  }

  void _updateCustomDuration(int days) {
    if (state.isSelectedManagerPlanLocked) return;
    final updatedFlow = _updateLocalMemberInCurrentFlow(
      durationDays: days,
      includeFriday: state.includeFriday,
    );
    _emit(
      state.copyWith(
        customDurationDays: days,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );
    _customDurationDebounce?.cancel();
    _customDurationDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!isClosed) {
        unawaited(_reloadTiersForCurrentPlan(durationDays: days));
      }
    });
  }

  void _toggleFriday(bool include) {
    if (state.isSelectedManagerPlanLocked) return;
    final updatedFlow = _updateLocalMemberInCurrentFlow(includeFriday: include);
    _emit(
      state.copyWith(
        includeFriday: include,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );
    final member = state.selectedMember;
    final programId = state.selectedProgram?.programId ?? member?.programId;
    if (programId != null && programId.isNotEmpty) {
      unawaited(
        _loadDurations(
          programId: programId,
          includeFriday: include,
          member: member,
          memberToken: _memberSelectionToken,
        ),
      );
    }
    unawaited(_reloadTiersForCurrentPlan(includeFriday: include));
  }

  Future<void> _reloadTiersForCurrentPlan({
    String? bundleId,
    int? durationDays,
    bool? includeFriday,
  }) async {
    final member = state.selectedMember;
    if (member == null) return;
    final programId = state.selectedProgram?.programId ?? member.programId;
    if (programId == null || programId.isEmpty) return;
    final selectedBundleId =
        bundleId ?? state.selectedBundle?.bundleId ?? member.bundleId;
    final days =
        durationDays ?? state.customDurationDays ?? member.durationDays;
    final friday = includeFriday ?? state.includeFriday;

    await _loadTiers(
      programId: programId,
      bundleId: selectedBundleId,
      durationDays: days,
      includeFriday: friday,
      familyMemberId: member.memberId,
      member: member,
      memberToken: _memberSelectionToken,
    );
  }

  void _selectTier(int tierIndex) {
    if (state.isSelectedManagerPlanLocked) return;
    final tier = state.tiers.length > tierIndex ? state.tiers[tierIndex] : null;
    if (tier == null) return;
    final tierInt = _parseTierToInt(tier.tier, tier.nameEn) ?? (tierIndex + 1);
    final updatedFlow = _updateLocalMemberInCurrentFlow(selectedTier: tierInt);
    _emit(
      state.copyWith(
        selectedTierIndex: tierIndex,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );
  }

  Future<void> _retryBundles() async {
    final member = state.selectedMember;
    final programId =
        state.selectedProgram?.programId ??
        member?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : null);
    if (programId == null || programId.isEmpty) return;
    _bundlesCache.remove(programId);
    await _loadBundles(
      programId,
      member: member,
      memberToken: _memberSelectionToken,
    );
  }

  Future<void> _retryDurations() async {
    final member = state.selectedMember;
    final programId =
        state.selectedProgram?.programId ??
        member?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : null);
    if (programId == null || programId.isEmpty) return;
    final friday = state.includeFriday;
    _durationsCache.remove('$programId|$friday');
    await _loadDurations(
      programId: programId,
      includeFriday: friday,
      member: member,
      memberToken: _memberSelectionToken,
    );
  }

  Future<void> _retryTiers() async {
    final member = state.selectedMember;
    if (member == null) return;
    final programId = state.selectedProgram?.programId ?? member.programId;
    if (programId == null || programId.isEmpty) return;
    final selectedBundleId = state.selectedBundle?.bundleId ?? member.bundleId;
    final days = state.customDurationDays ?? member.durationDays;
    final friday = state.includeFriday;
    await _loadTiers(
      programId: programId,
      bundleId: selectedBundleId,
      durationDays: days,
      includeFriday: friday,
      familyMemberId: member.memberId,
      member: member,
      memberToken: _memberSelectionToken,
    );
  }

  FamilyFlowCurrentEntity? _updateLocalMemberInCurrentFlow({
    String? bundleId,
    int? selectedTier,
    int? durationDays,
    bool? includeFriday,
  }) {
    final flow = state.currentFlow;
    if (flow == null || state.members.isEmpty) return null;
    final idx = state.selectedMemberIndex;
    if (idx < 0 || idx >= flow.members.length) return null;
    final member = flow.members[idx];
    final programId =
        member.programId ??
        state.selectedProgram?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : null);
    final updatedMember = member.copyWith(
      programId: programId,
      bundleId: bundleId ?? member.bundleId,
      selectedTier: selectedTier ?? member.selectedTier,
      durationDays: durationDays ?? member.durationDays,
      includeFriday: includeFriday ?? member.includeFriday,
    );
    final updatedMembers = List<FamilyMemberEntity>.from(flow.members);
    updatedMembers[idx] = updatedMember;
    final updatedFlow = flow.copyWith(members: updatedMembers);
    _snapshotStore.update(updatedFlow);
    return updatedFlow;
  }

  Future<void> _browseTierRestaurants(int tierIndex) async {
    if (state.isSelectedManagerPlanLocked) return;
    final selectedTier = (tierIndex >= 0 && tierIndex < state.tiers.length)
        ? state.tiers[tierIndex]
        : null;
    if (selectedTier == null) return;
    final member = state.selectedMember;
    final programId =
        state.selectedProgram?.programId ??
        member?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : '');
    SubscriptionBundleEntity? bundle = state.selectedBundle;
    if (bundle == null && member?.bundleId != null) {
      for (final b in state.bundles) {
        if (b.bundleId == member!.bundleId) bundle = b;
      }
    }
    bundle ??=
        state.bundles.where((b) => b.canSelect).firstOrNull ??
        (state.bundles.isNotEmpty ? state.bundles.first : null);
    if (programId.isEmpty || bundle == null || member == null) return;
    _emit(
      state.copyWith(
        isBrowseRestaurantsLoading: true,
        isRestaurantsView: true,
        browsedTierIndex: tierIndex,
        selectedTierIndex: tierIndex,
        clearFailure: true,
      ),
    );
    final result = await _getSubscriptionTierRestaurantsUseCase(
      programId: programId,
      bundleId: bundle.bundleId,
      tier: selectedTier.tier,
      familyMemberId: member.memberId,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        _emit(
          state.copyWith(
            isBrowseRestaurantsLoading: false,
            browseRestaurants: result.data,
          ),
        );
      case ApiErrorResult():
        _emit(
          state.copyWith(
            isBrowseRestaurantsLoading: false,
            browseRestaurantsFailure: result.failure,
          ),
        );
    }
  }

  Future<bool> _saveMemberPlan({
    required String memberId,
    bool clearPlan = false,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
    String? startDate,
  }) async {
    final member = state.members
        .where((item) => item.memberId == memberId)
        .firstOrNull;
    if (member?.memberSubscriptionId != null) return false;
    if (state.isConvertedFamilyDraft && member?.isManager == true) return true;

    _emit(state.copyWith(isPlanSaving: true));
    final result = await _saveFamilyMemberPlanUseCase(
      memberId: memberId,
      clearPlan: clearPlan,
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      durationDays: durationDays,
      includeFriday: includeFriday,
      startDate: startDate,
    );
    if (isClosed) return false;
    switch (result) {
      case ApiSuccessResult():
        _syncConvertedDraftFlag(result.data);
        _snapshotStore.update(result.data);
        _emit(
          state.copyWith(
            currentFlow: result.data,
            isPlanSaving: false,
            clearFailure: true,
            clearSelectedBundle: clearPlan,
            clearSelectedDuration: clearPlan,
            clearSelectedTier: clearPlan,
            clearCustomDuration: clearPlan,
          ),
        );
        return true;
      case ApiErrorResult():
        _emit(state.copyWith(isPlanSaving: false, failure: result.failure));
        return false;
    }
  }

  Future<bool> saveMemberPlanAndWait({
    required String memberId,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
    String? startDate,
  }) => _saveMemberPlan(
    memberId: memberId,
    programId: programId,
    bundleId: bundleId,
    tier: tier,
    durationDays: durationDays,
    includeFriday: includeFriday,
    startDate: startDate,
  );

  Future<bool> saveAllMemberPlansAndWait() async {
    final members = state.currentFlow?.members ?? state.members;
    for (final member in members.where((m) => m.subscribeNow)) {
      final programId = member.programId;
      final bundleId = member.bundleId;
      final durationDays = member.durationDays;
      final tier = member.selectedTier;
      if (programId == null ||
          programId.isEmpty ||
          bundleId == null ||
          bundleId.isEmpty ||
          durationDays == null ||
          durationDays <= 0 ||
          tier == null) {
        continue;
      }
      final saved = await _saveMemberPlan(
        memberId: member.memberId,
        programId: programId,
        bundleId: bundleId,
        tier: tier,
        durationDays: durationDays,
        includeFriday: member.includeFriday,
      );
      if (!saved) return false;
    }
    return true;
  }

  void _syncConvertedDraftFlag(FamilyFlowCurrentEntity flow) {
    if (flow.status == 3) {
      FamilyConversionDraftSession.clearConvertedFamilyDraft();
      return;
    }
    if (flow.managerPrepaid) {
      FamilyConversionDraftSession.markConvertedFamilyDraft();
    } else {
      FamilyConversionDraftSession.clearConvertedFamilyDraft();
    }
  }

  @override
  Future<void> close() {
    _customDurationDebounce?.cancel();
    return super.close();
  }
}
