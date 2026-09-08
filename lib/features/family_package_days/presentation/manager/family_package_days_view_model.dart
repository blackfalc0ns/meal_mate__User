import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/save_family_member_plan_usecase.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_programs_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilyPackageDaysViewModel extends Cubit<FamilyPlanState> {
  FamilyPackageDaysViewModel(
    this._getFamilyFlowCurrentUseCase,
    this._getFamilyProgramsUseCase,
    this._getFamilyProgramBundlesUseCase,
    this._getSubscriptionDurationsUseCase,
    this._getSubscriptionTiersUseCase,
    this._getSubscriptionTierRestaurantsUseCase,
    this._saveFamilyMemberPlanUseCase,
  ) : super(const FamilyPlanState());

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final GetFamilyProgramsUseCase _getFamilyProgramsUseCase;
  final GetFamilyProgramBundlesUseCase _getFamilyProgramBundlesUseCase;
  final GetSubscriptionDurationsUseCase _getSubscriptionDurationsUseCase;
  final GetSubscriptionTiersUseCase _getSubscriptionTiersUseCase;
  final GetSubscriptionTierRestaurantsUseCase
  _getSubscriptionTierRestaurantsUseCase;
  final SaveFamilyMemberPlanUseCase _saveFamilyMemberPlanUseCase;

  void _emit(FamilyPlanState state) {
    if (isClosed) return;
    emit(state);
  }

  void doIntent(FamilyPlanEvent event) {
    if (isClosed) return;
    switch (event) {
      case GetFamilySubscriptionCurrentEvent():
        _getFamilySubscriptionCurrent();
      case GetFamilyProgramsEvent():
        _getPrograms();
      case GetFamilyBundlesEvent():
        _getBundles(event.programId);
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
        _browseTierRestaurants(event.tierIndex);
      case CloseFamilyBrowseRestaurantsEvent():
        _emit(state.copyWith(isRestaurantsView: false));
      case SelectFamilyMemberEvent():
        _selectMember(event.memberIndex);
      case SelectFamilyMemberPackageDaysEvent():
        _selectMemberInPackageDays(event.memberIndex);
      case SaveFamilyMemberPlanEvent():
        _saveMemberPlan(
          memberId: event.memberId,
          programId: event.programId,
          bundleId: event.bundleId,
          tier: event.tier,
          durationDays: event.durationDays,
          includeFriday: event.includeFriday,
          startDate: event.startDate,
        );
    }
  }

  Future<void> _getFamilySubscriptionCurrent() async {
    _emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        final flow = result.data;
        _syncConvertedDraftFlag(flow);
        final firstPlannedIndex = flow.members.indexWhere(
          (member) => member.hasProgram,
        );
        final currentIndexIsPlanned =
            state.selectedMemberIndex >= 0 &&
            state.selectedMemberIndex < flow.members.length &&
            flow.members[state.selectedMemberIndex].hasProgram;
        final selectedIndex = currentIndexIsPlanned
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
        _emit(
          state.copyWith(
            isProgramsLoading: false,
            programs: result.data.where((p) => p.programId.isNotEmpty).toList(),
          ),
        );
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
        includeFriday: member.includeFriday,
        isRestaurantsView: false,
      ),
    );
    _loadMemberBundlesAndSelections(member);
  }

  Future<void> _loadMemberBundlesAndSelections(
    FamilyMemberEntity member,
  ) async {
    final programId =
        member.programId ??
        state.selectedProgram?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : null);
    if (programId == null || programId.isEmpty) return;
    _emit(state.copyWith(isBundlesLoading: true, clearFailure: true));
    final result = await _getFamilyProgramBundlesUseCase(programId);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        final bundles = result.data
            .where((b) => b.bundleId.isNotEmpty)
            .toList();
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
        if (bundles.isNotEmpty) {
          final targetBundle = bundleIdx != null
              ? bundles[bundleIdx]
              : bundles.first;
          await _getDurationsAndTiersForMember(
            programId: programId,
            bundleId: targetBundle.bundleId,
            member: member,
          );
        }
      case ApiErrorResult():
        _emit(state.copyWith(isBundlesLoading: false, failure: result.failure));
    }
  }

  Future<void> _getDurationsAndTiersForMember({
    required String programId,
    required String bundleId,
    required FamilyMemberEntity member,
  }) async {
    final shouldLoadDurations = state.durations.isEmpty;
    _emit(
      state.copyWith(
        isDurationsLoading: shouldLoadDurations,
        isTiersLoading: true,
        clearFailure: true,
      ),
    );
    final durationsResult = shouldLoadDurations
        ? await _getSubscriptionDurationsUseCase(
            programId: programId,
            bundleId: bundleId,
            includeFriday: member.includeFriday,
          )
        : null;
    if (isClosed) return;
    final tiersResult = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: member.durationDays,
      includeFriday: member.includeFriday,
      familyMemberId: member.memberId,
    );
    if (isClosed) return;
    final durations = durationsResult is ApiSuccessResult
        ? (durationsResult as ApiSuccessResult).data
        : state.durations;
    final tiers = tiersResult is ApiSuccessResult
        ? (tiersResult as ApiSuccessResult).data
        : state.tiers;
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
    final member = state.selectedMember;
    final updatedFlow = _updateLocalMemberInCurrentFlow(
      bundleId: bundle.bundleId,
    );
    _emit(
      state.copyWith(
        selectedBundleIndex: index,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );
    if (member != null) {
      _saveMemberPlan(memberId: member.memberId, bundleId: bundle.bundleId);
    }
    final progId = state.selectedProgram?.programId ?? member?.programId;
    if (progId != null && member != null) {
      _getDurations(
        programId: progId,
        bundleId: bundle.bundleId,
        includeFriday: state.includeFriday,
        familyMemberId: member.memberId,
      );
    }
  }

  Future<void> _getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
    required String familyMemberId,
  }) async {
    _emit(
      state.copyWith(
        isDurationsLoading: true,
        isTiersLoading: true,
        clearFailure: true,
      ),
    );
    final durationsResult = await _getSubscriptionDurationsUseCase(
      programId: programId,
      bundleId: bundleId,
      includeFriday: includeFriday,
    );
    if (isClosed) return;
    final tiersResult = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: state.selectedDurationDays,
      includeFriday: includeFriday,
      familyMemberId: familyMemberId,
    );
    if (isClosed) return;
    _emit(
      state.copyWith(
        isDurationsLoading: false,
        isTiersLoading: false,
        durations: durationsResult is ApiSuccessResult
            ? (durationsResult as ApiSuccessResult).data
            : state.durations,
        tiers: tiersResult is ApiSuccessResult
            ? (tiersResult as ApiSuccessResult).data
            : state.tiers,
      ),
    );
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
    final member = state.selectedMember;
    if (member != null && !duration.isCustom && days != null) {
      _saveMemberPlan(
        memberId: member.memberId,
        durationDays: days,
        includeFriday: state.includeFriday,
      );
      _reloadTiersForMember(member: member, durationDays: days);
    }
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
    final member = state.selectedMember;
    if (member != null && days > 0) {
      _saveMemberPlan(
        memberId: member.memberId,
        durationDays: days,
        includeFriday: state.includeFriday,
      );
      _reloadTiersForMember(member: member, durationDays: days);
    }
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
    final days = state.selectedDurationDays;
    if (member != null && days != null && days > 0) {
      _saveMemberPlan(
        memberId: member.memberId,
        durationDays: days,
        includeFriday: include,
      );
    }
    final progId = state.selectedProgram?.programId ?? member?.programId;
    final selectedBundle = state.selectedBundle;
    if (progId != null && selectedBundle != null && member != null) {
      _getDurations(
        programId: progId,
        bundleId: selectedBundle.bundleId,
        includeFriday: include,
        familyMemberId: member.memberId,
      );
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
    final member = state.selectedMember;
    if (member != null) {
      _saveMemberPlan(memberId: member.memberId, tier: tierInt);
    }
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

  Future<void> _reloadTiersForMember({
    required FamilyMemberEntity member,
    required int durationDays,
  }) async {
    final programId = state.selectedProgram?.programId ?? member.programId;
    final bundleId = state.selectedBundle?.bundleId ?? member.bundleId;
    if (programId == null || bundleId == null) return;

    _emit(state.copyWith(isTiersLoading: true, clearFailure: true));
    final result = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: durationDays,
      includeFriday: state.includeFriday,
      familyMemberId: member.memberId,
    );
    if (isClosed || state.selectedMember?.memberId != member.memberId) return;
    switch (result) {
      case ApiSuccessResult():
        _emit(state.copyWith(isTiersLoading: false, tiers: result.data));
      case ApiErrorResult():
        _emit(state.copyWith(isTiersLoading: false, failure: result.failure));
    }
  }

  Future<void> _saveMemberPlan({
    required String memberId,
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
    if (state.isConvertedFamilyDraft && member?.isManager == true) return;

    final result = await _saveFamilyMemberPlanUseCase(
      memberId: memberId,
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      durationDays: durationDays,
      includeFriday: includeFriday,
      startDate: startDate,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        _syncConvertedDraftFlag(result.data);
        _emit(state.copyWith(currentFlow: result.data, clearFailure: true));
      case ApiErrorResult():
        _emit(state.copyWith(failure: result.failure));
    }
  }

  Future<void> saveMemberPlanAndWait({
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
