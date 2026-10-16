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
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_programs_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
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
    this._saveFamilyMemberPlanUseCase,
  ) : super(const FamilyPackageDaysState());

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final GetFamilyProgramsUseCase _getFamilyProgramsUseCase;
  final GetFamilyProgramBundlesUseCase _getFamilyProgramBundlesUseCase;
  final GetFamilyPlanDurationsUseCase _getFamilyPlanDurationsUseCase;
  final GetFamilyPlanTiersUseCase _getFamilyPlanTiersUseCase;
  final GetSubscriptionTierRestaurantsUseCase
  _getSubscriptionTierRestaurantsUseCase;
  final SaveFamilyMemberPlanUseCase _saveFamilyMemberPlanUseCase;
  int _tiersRequestToken = 0;
  int _flowRequestToken = 0;
  final Set<String> _memberLoadKeys = <String>{};
  final Map<String, List<SubscriptionBundleEntity>> _bundlesCache = {};
  final Map<String, List<SubscriptionDurationEntity>> _durationsCache = {};
  final Map<String, List<SubscriptionTierEntity>> _tiersCache = {};

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
        unawaited(_getPrograms());
      case GetFamilyBundlesEvent():
        unawaited(_getBundles(event.programId));
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
        if (member != null) await _loadMemberBundlesAndSelections(member);
      case ApiErrorResult():
        _emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _getPrograms() async {
    _emit(state.copyWith(isProgramsLoading: true, clearFailure: true));
    final result = await _getFamilyProgramsUseCase();
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        final programs = result.data
            .where((p) => p.programId.isNotEmpty)
            .toList();
        _emit(state.copyWith(isProgramsLoading: false, programs: programs));
        final member = state.selectedMember;
        if (member != null && state.bundles.isEmpty) {
          await _loadMemberBundlesAndSelections(member);
        }
      case ApiErrorResult():
        _emit(
          state.copyWith(isProgramsLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _getBundles(String programId) async {
    _emit(state.copyWith(isBundlesLoading: true, clearFailure: true));
    final result = await _getFamilyProgramBundlesUseCase(programId);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        _emit(
          state.copyWith(
            isBundlesLoading: false,
            bundles: result.data.where((b) => b.bundleId.isNotEmpty).toList(),
            clearSelectedBundle: true,
            clearSelectedDuration: true,
            clearSelectedTier: true,
          ),
        );
      case ApiErrorResult():
        _emit(state.copyWith(isBundlesLoading: false, failure: result.failure));
    }
  }

  void _selectMember(int index) {
    if (index < 0 || index >= state.members.length) return;
    _emit(state.copyWith(selectedMemberIndex: index));
  }

  void _selectMemberInPackageDays(int index) {
    if (index < 0 || index >= state.members.length) return;
    final member = state.members[index];
    _emit(
      state.copyWith(
        selectedMemberIndex: index,
        clearSelectedBundle: true,
        clearSelectedDuration: true,
        clearSelectedTier: true,
        tiers: const [],
        clearBrowseRestaurants: true,
        customDurationDays: member.durationDays,
        clearCustomDuration: member.durationDays == null,
        includeFriday: member.includeFriday,
        isRestaurantsView: false,
      ),
    );
    unawaited(_loadMemberBundlesAndSelections(member));
  }

  Future<void> _loadMemberBundlesAndSelections(
    FamilyMemberEntity member,
  ) async {
    final programId =
        member.programId ??
        state.selectedProgram?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : null);
    if (programId == null || programId.isEmpty) return;

    final loadKey =
        '${member.memberId}|$programId|${member.bundleId}|'
        '${member.durationDays}|${member.includeFriday}';
    if (!_memberLoadKeys.add(loadKey)) return;

    try {
      if (member.programId == null || member.programId!.isEmpty) {
        final updatedMembers = state.members.map((m) {
          if (m.memberId == member.memberId) {
            return m.copyWith(programId: programId);
          }
          return m;
        }).toList();
        final updatedFlow = state.currentFlow?.copyWith(
          members: updatedMembers,
        );
        _emit(state.copyWith(currentFlow: updatedFlow));
      }

      _emit(
        state.copyWith(
          isBundlesLoading: true,
          isDurationsLoading: true,
          isTiersLoading: true,
          clearFailure: true,
        ),
      );
      final bundlesKey = programId;
      final durationsKey = '$programId|${member.includeFriday}';
      final tiersKey = _tiersKey(
        programId: programId,
        bundleId: member.bundleId,
        durationDays: member.durationDays,
        includeFriday: member.includeFriday,
        familyMemberId: member.memberId,
      );
      final results = await Future.wait([
        _bundlesCache.containsKey(bundlesKey)
            ? Future<ApiResult<List<SubscriptionBundleEntity>>>.value(
                ApiSuccessResult(data: _bundlesCache[bundlesKey]!),
              )
            : _getFamilyProgramBundlesUseCase(programId),
        _durationsCache.containsKey(durationsKey)
            ? Future<ApiResult<List<SubscriptionDurationEntity>>>.value(
                ApiSuccessResult(data: _durationsCache[durationsKey]!),
              )
            : _getFamilyPlanDurationsUseCase(
                programId: programId,
                includeFriday: member.includeFriday,
              ),
        _tiersCache.containsKey(tiersKey)
            ? Future<ApiResult<List<SubscriptionTierEntity>>>.value(
                ApiSuccessResult(data: _tiersCache[tiersKey]!),
              )
            : _getFamilyPlanTiersUseCase(
                programId: programId,
                bundleId: member.bundleId,
                durationDays: member.durationDays,
                includeFriday: member.includeFriday,
                familyMemberId: member.memberId,
              ),
      ]);
      final result = results[0] as ApiResult<List<SubscriptionBundleEntity>>;
      if (isClosed || state.selectedMember?.memberId != member.memberId) return;
      switch (result) {
        case ApiSuccessResult():
          final bundles = result.data
              .where((b) => b.bundleId.isNotEmpty)
              .toList();
          _bundlesCache[bundlesKey] = bundles;
          int? bundleIdx;
          if (member.bundleId != null && member.bundleId!.isNotEmpty) {
            final foundIdx = bundles.indexWhere(
              (b) => b.bundleId == member.bundleId,
            );
            if (foundIdx != -1) bundleIdx = foundIdx;
          }
          _emit(
            state.copyWith(
              isBundlesLoading: false,
              bundles: bundles,
              selectedBundleIndex: bundleIdx,
              clearSelectedBundle: bundleIdx == null,
            ),
          );
          await _applyDurationsAndTiersForMember(
            member: member,
            durationsResult:
                results[1] as ApiResult<List<SubscriptionDurationEntity>>,
            tiersResult: results[2] as ApiResult<List<SubscriptionTierEntity>>,
          );
          final durationsResult =
              results[1] as ApiResult<List<SubscriptionDurationEntity>>;
          if (durationsResult case ApiSuccessResult(:final data)) {
            _durationsCache[durationsKey] = data;
          }
          final tiersResult =
              results[2] as ApiResult<List<SubscriptionTierEntity>>;
          if (tiersResult case ApiSuccessResult(:final data)) {
            _tiersCache[tiersKey] = data;
          }
        case ApiErrorResult():
          _emit(
            state.copyWith(
              isBundlesLoading: false,
              isDurationsLoading: false,
              isTiersLoading: false,
              failure: result.failure,
            ),
          );
      }
    } finally {
      _memberLoadKeys.remove(loadKey);
    }
  }

  String _tiersKey({
    required String programId,
    required String? bundleId,
    required int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  }) => '$programId|$bundleId|$durationDays|$includeFriday|$familyMemberId';

  Future<void> _applyDurationsAndTiersForMember({
    required FamilyMemberEntity member,
    required ApiResult<List<SubscriptionDurationEntity>> durationsResult,
    required ApiResult<List<SubscriptionTierEntity>> tiersResult,
  }) async {
    if (isClosed || state.selectedMember?.memberId != member.memberId) return;
    final durations = switch (durationsResult) {
      ApiSuccessResult(data: final data) => data,
      ApiErrorResult() => state.durations,
    };
    final tiers = switch (tiersResult) {
      ApiSuccessResult(data: final data) => data,
      ApiErrorResult() => const <SubscriptionTierEntity>[],
    };
    final failure = switch ((tiersResult, durationsResult)) {
      (ApiErrorResult(failure: final failure), _) => failure,
      (_, ApiErrorResult(failure: final failure)) => failure,
      _ => null,
    };
    final durationIdx = member.durationDays == null
        ? null
        : durations.indexWhere((d) => d.durationDays == member.durationDays);
    int? tierIdx;
    if (member.selectedTier != null) {
      final foundTierIdx = tiers.indexWhere(
        (t) =>
            (_parseTierToInt(t.tier, t.nameEn) ?? (tiers.indexOf(t) + 1)) ==
            member.selectedTier,
      );
      if (foundTierIdx != -1) tierIdx = foundTierIdx;
    }
    _emit(
      state.copyWith(
        isDurationsLoading: false,
        isTiersLoading: false,
        durations: durations,
        tiers: tiers,
        selectedDurationIndex: durationIdx != null && durationIdx >= 0
            ? durationIdx
            : null,
        clearSelectedDuration: durationIdx == null || durationIdx < 0,
        selectedTierIndex: tierIdx,
        clearSelectedTier: tierIdx == null,
        includeFriday: member.includeFriday,
        customDurationDays: member.durationDays,
        clearCustomDuration: member.durationDays == null,
        failure: failure,
        clearFailure: failure == null,
      ),
    );
  }

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

  void _selectBundle(int index) {
    if (state.isSelectedManagerPlanLocked) return;
    final bundle = state.bundles.length > index ? state.bundles[index] : null;
    if (bundle == null) return;
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
    unawaited(_reloadTiersForCurrentPlan(durationDays: days));
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
    final requestToken = ++_tiersRequestToken;

    _emit(
      state.copyWith(
        isTiersLoading: true,
        tiers: const [],
        clearSelectedTier: true,
      ),
    );

    final cacheKey = _tiersKey(
      programId: programId,
      bundleId: selectedBundleId,
      durationDays: days,
      includeFriday: friday,
      familyMemberId: member.memberId,
    );
    final result = _tiersCache[cacheKey] != null
        ? ApiSuccessResult<List<SubscriptionTierEntity>>(
            data: _tiersCache[cacheKey]!,
          )
        : await _getFamilyPlanTiersUseCase(
            programId: programId,
            bundleId: selectedBundleId,
            durationDays: days,
            includeFriday: friday,
            familyMemberId: member.memberId,
          );
    if (result case ApiSuccessResult(:final data)) {
      _tiersCache[cacheKey] = data;
    }
    if (isClosed || requestToken != _tiersRequestToken) return;
    if (result case ApiSuccessResult(:final data)) {
      if (state.selectedMember?.memberId != member.memberId ||
          state.selectedBundle?.bundleId != selectedBundleId ||
          state.customDurationDays != days ||
          state.includeFriday != friday) {
        return;
      }
      _emit(state.copyWith(isTiersLoading: false, tiers: data));
    } else {
      _emit(state.copyWith(isTiersLoading: false));
    }
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
    final updatedMember = member.copyWith(
      bundleId: bundleId ?? member.bundleId,
      selectedTier: selectedTier ?? member.selectedTier,
      durationDays: durationDays ?? member.durationDays,
      includeFriday: includeFriday ?? member.includeFriday,
    );
    final updatedMembers = List<FamilyMemberEntity>.from(flow.members);
    updatedMembers[idx] = updatedMember;
    return flow.copyWith(members: updatedMembers);
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
    bundle ??= state.bundles.isNotEmpty ? state.bundles.first : null;
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
}
