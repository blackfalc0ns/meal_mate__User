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

  void doIntent(FamilyPlanEvent event) {
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
        emit(state.copyWith(isRestaurantsView: false));
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
        );
    }
  }

  Future<void> _getFamilySubscriptionCurrent() async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    switch (result) {
      case ApiSuccessResult():
        final flow = result.data;
        final selectedIndex =
            (state.selectedMemberIndex >= 0 &&
                state.selectedMemberIndex < flow.members.length)
            ? state.selectedMemberIndex
            : 0;
        final member = flow.members.isNotEmpty
            ? flow.members[selectedIndex]
            : null;
        emit(
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
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _getPrograms() async {
    emit(state.copyWith(isProgramsLoading: true, clearFailure: true));
    final result = await _getFamilyProgramsUseCase();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isProgramsLoading: false,
            programs: result.data.where((p) => p.programId.isNotEmpty).toList(),
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isProgramsLoading: false, failure: result.failure));
    }
  }

  Future<void> _getBundles(String programId) async {
    emit(state.copyWith(isBundlesLoading: true, clearFailure: true));
    final result = await _getFamilyProgramBundlesUseCase(programId);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isBundlesLoading: false,
            bundles: result.data.where((b) => b.bundleId.isNotEmpty).toList(),
            clearSelectedBundle: true,
            clearSelectedDuration: true,
            clearSelectedTier: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isBundlesLoading: false, failure: result.failure));
    }
  }

  void _selectMember(int index) {
    if (index < 0 || index >= state.members.length) return;
    emit(state.copyWith(selectedMemberIndex: index));
  }

  void _selectMemberInPackageDays(int index) {
    if (index < 0 || index >= state.members.length) return;
    final member = state.members[index];
    emit(
      state.copyWith(
        selectedMemberIndex: index,
        clearSelectedBundle: true,
        clearSelectedDuration: true,
        clearSelectedTier: true,
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
    emit(state.copyWith(isBundlesLoading: true, clearFailure: true));
    final result = await _getFamilyProgramBundlesUseCase(programId);
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
        emit(
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
        emit(state.copyWith(isBundlesLoading: false, failure: result.failure));
    }
  }

  Future<void> _getDurationsAndTiersForMember({
    required String programId,
    required String bundleId,
    required FamilyMemberEntity member,
  }) async {
    emit(
      state.copyWith(
        isDurationsLoading: true,
        isTiersLoading: true,
        clearFailure: true,
      ),
    );
    final durationsResult = await _getSubscriptionDurationsUseCase(
      programId: programId,
      bundleId: bundleId,
      includeFriday: member.includeFriday,
    );
    final tiersResult = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: member.durationDays,
      includeFriday: member.includeFriday,
    );
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
    emit(
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
    final bundle = state.bundles.length > index ? state.bundles[index] : null;
    if (bundle == null) return;
    final member = state.selectedMember;
    final updatedFlow = _updateLocalMemberInCurrentFlow(
      bundleId: bundle.bundleId,
    );
    emit(
      state.copyWith(
        selectedBundleIndex: index,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );
    if (member != null) {
      _saveMemberPlan(memberId: member.memberId, bundleId: bundle.bundleId);
    }
    final progId = state.selectedProgram?.programId ?? member?.programId;
    if (progId != null) {
      _getDurations(
        programId: progId,
        bundleId: bundle.bundleId,
        includeFriday: state.includeFriday,
      );
    }
  }

  Future<void> _getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) async {
    emit(
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
    final tiersResult = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: state.selectedDurationDays,
      includeFriday: includeFriday,
    );
    emit(
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
    final duration = state.durations.length > index
        ? state.durations[index]
        : null;
    if (duration == null) return;
    final days = duration.durationDays;
    final updatedFlow = _updateLocalMemberInCurrentFlow(
      durationDays: days,
      includeFriday: state.includeFriday,
    );
    emit(
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
    }
  }

  void _updateCustomDuration(int days) {
    final updatedFlow = _updateLocalMemberInCurrentFlow(
      durationDays: days,
      includeFriday: state.includeFriday,
    );
    emit(
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
    }
  }

  void _toggleFriday(bool include) {
    final updatedFlow = _updateLocalMemberInCurrentFlow(includeFriday: include);
    emit(
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
    if (progId != null && selectedBundle != null) {
      _getDurations(
        programId: progId,
        bundleId: selectedBundle.bundleId,
        includeFriday: include,
      );
    }
  }

  void _selectTier(int tierIndex) {
    final tier = state.tiers.length > tierIndex ? state.tiers[tierIndex] : null;
    if (tier == null) return;
    final tierInt = _parseTierToInt(tier.tier, tier.nameEn) ?? (tierIndex + 1);
    final updatedFlow = _updateLocalMemberInCurrentFlow(selectedTier: tierInt);
    emit(
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
    if (programId.isEmpty || bundle == null) return;
    emit(
      state.copyWith(
        isBrowseRestaurantsLoading: true,
        isRestaurantsView: true,
        browsedTierIndex: tierIndex,
        selectedTierIndex: tierIndex,
        clearFailure: true,
      ),
    );
    final restaurantIds = selectedTier.restaurants
        .map((r) => r.restaurantId)
        .where((id) => id.isNotEmpty)
        .toList();
    final result = await _getSubscriptionTierRestaurantsUseCase(
      programId: programId,
      bundleId: bundle.bundleId,
      tier: selectedTier.tier,
      restaurantIds: restaurantIds,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isBrowseRestaurantsLoading: false,
            browseRestaurants: result.data,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isBrowseRestaurantsLoading: false,
            browseRestaurantsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _saveMemberPlan({
    required String memberId,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
  }) async {
    final result = await _saveFamilyMemberPlanUseCase(
      memberId: memberId,
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      durationDays: durationDays,
      includeFriday: includeFriday,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(currentFlow: result.data, clearFailure: true));
      case ApiErrorResult():
        emit(state.copyWith(failure: result.failure));
    }
  }
}
