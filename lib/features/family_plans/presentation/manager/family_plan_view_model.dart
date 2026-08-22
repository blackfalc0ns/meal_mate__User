import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/add_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/checkout_family_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/delete_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_flow_current_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_programs_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_relationships_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_size_packages_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_summary_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/save_family_member_plan_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/update_family_group_usecase.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/update_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';

@injectable
class FamilyPlanViewModel extends Cubit<FamilyPlanState> {
  FamilyPlanViewModel(
    this._getFamilySizePackagesUseCase,
    this._getFamilyFlowCurrentUseCase,
    this._updateFamilyGroupUseCase,
    this._getFamilyRelationshipsUseCase,
    this._addFamilyMemberUseCase,
    this._updateFamilyMemberUseCase,
    this._deleteFamilyMemberUseCase,
    this._getFamilyProgramsUseCase,
    this._getFamilyProgramBundlesUseCase,
    this._getSubscriptionDurationsUseCase,
    this._getSubscriptionTiersUseCase,
    this._getSubscriptionTierRestaurantsUseCase,
    this._saveFamilyMemberPlanUseCase,
    this._getFamilySummaryUseCase,
    this._getFamilyPaymentMethodsUseCase,
    this._checkoutFamilySubscriptionUseCase,
    this._getCustomerAddressesUseCase,
  ) : super(const FamilyPlanState());

  final GetFamilySizePackagesUseCase _getFamilySizePackagesUseCase;
  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final UpdateFamilyGroupUseCase _updateFamilyGroupUseCase;
  final GetFamilyRelationshipsUseCase _getFamilyRelationshipsUseCase;
  final AddFamilyMemberUseCase _addFamilyMemberUseCase;
  final UpdateFamilyMemberUseCase _updateFamilyMemberUseCase;
  final DeleteFamilyMemberUseCase _deleteFamilyMemberUseCase;
  final GetFamilyProgramsUseCase _getFamilyProgramsUseCase;
  final GetFamilyProgramBundlesUseCase _getFamilyProgramBundlesUseCase;
  final GetSubscriptionDurationsUseCase _getSubscriptionDurationsUseCase;
  final GetSubscriptionTiersUseCase _getSubscriptionTiersUseCase;
  final GetSubscriptionTierRestaurantsUseCase
  _getSubscriptionTierRestaurantsUseCase;
  final SaveFamilyMemberPlanUseCase _saveFamilyMemberPlanUseCase;
  final GetFamilySummaryUseCase _getFamilySummaryUseCase;
  final GetFamilyPaymentMethodsUseCase _getFamilyPaymentMethodsUseCase;
  final CheckoutFamilySubscriptionUseCase _checkoutFamilySubscriptionUseCase;
  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;

  void doIntent(FamilyPlanEvent event) {
    switch (event) {
      case GetFamilySizePackagesEvent():
        _getFamilySizePackages();
      case SelectFamilySizePackageEvent():
        emit(state.copyWith(selectedPackage: event.package));
      case GetFamilySubscriptionCurrentEvent():
        _getFamilySubscriptionCurrent();
      case UpdateFamilyGroupEvent():
        _updateFamilyGroup(
          name: event.name,
          familyPackageId: event.familyPackageId,
        );
      case GetFamilyRelationshipsEvent():
        _getFamilyRelationships();
      case GetFamilyAddressesEvent():
        _getFamilyAddresses();
      case AddFamilyMemberEvent():
        _addFamilyMember(
          displayName: event.displayName,
          relationshipCode: event.relationshipCode,
          gender: event.gender,
          ageYears: event.ageYears,
          deliveryAddressId: event.deliveryAddressId,
        );
      case UpdateFamilyMemberEvent():
        _updateFamilyMember(
          memberId: event.memberId,
          displayName: event.displayName,
          relationshipCode: event.relationshipCode,
          gender: event.gender,
          ageYears: event.ageYears,
          deliveryAddressId: event.deliveryAddressId,
        );
      case DeleteFamilyMemberEvent():
        _deleteFamilyMember(event.memberId);
      case GetFamilyProgramsEvent():
        _getPrograms();
      case SelectFamilyProgramEvent():
        _selectProgram(event.programIndex);
      case GetFamilyBundlesEvent():
        _getBundles(event.programId);
      case SelectFamilyBundleEvent():
        _selectBundle(event.bundleIndex);
      case GetFamilyDurationsEvent():
        _getDurations(
          programId: event.programId,
          bundleId: event.bundleId,
          includeFriday: event.includeFriday,
        );
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
      case GetFamilySummaryEvent():
        _getFamilySummary(memberId: event.memberId);
      case GetFamilyPaymentMethodsEvent():
        _getFamilyPaymentMethods();
      case SelectFamilyPaymentMethodEvent():
        emit(state.copyWith(selectedPaymentMethod: event.paymentMethod));
      case CheckoutFamilySubscriptionEvent():
        _checkoutFamilySubscription(
          callbackUrl: event.callbackUrl,
          errorUrl: event.errorUrl,
          paymentMethodId: event.paymentMethodId,
        );
    }
  }

  Future<void> _getFamilySizePackages() async {
    emit(state.copyWith(isPackagesLoading: true, clearFailure: true));
    final result = await _getFamilySizePackagesUseCase();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isPackagesLoading: false,
            packages: result.data,
            selectedPackage:
                state.selectedPackage ??
                (result.data.isNotEmpty ? result.data.first : null),
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isPackagesLoading: false, failure: result.failure));
    }
  }

  Future<void> _getFamilySubscriptionCurrent() async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    switch (result) {
      case ApiSuccessResult():
        final flow = result.data;
        final selectedIndex = (state.selectedMemberIndex >= 0 &&
                state.selectedMemberIndex < flow.members.length)
            ? state.selectedMemberIndex
            : 0;
        final member =
            flow.members.isNotEmpty ? flow.members[selectedIndex] : null;

        emit(
          state.copyWith(
            isCurrentFlowLoading: false,
            currentFlow: flow,
            selectedMemberIndex: selectedIndex,
            includeFriday: member?.includeFriday ?? state.includeFriday,
            customDurationDays: member?.durationDays ?? state.customDurationDays,
          ),
        );

        if (member != null) {
          _selectProgramById(member.programId);
          await _loadMemberBundlesAndSelections(member);
        }
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  void _selectProgramById(String? programId) {
    if (programId == null || programId.isEmpty) {
      emit(state.copyWith(clearSelectedProgram: true));
      return;
    }
    if (state.programs.isNotEmpty) {
      final idx = state.programs.indexWhere((p) => p.programId == programId);
      if (idx != -1) {
        emit(state.copyWith(selectedProgramIndex: idx));
      } else {
        emit(state.copyWith(clearSelectedProgram: true));
      }
    }
  }

  Future<void> _updateFamilyGroup({
    required String name,
    String? familyPackageId,
  }) async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _updateFamilyGroupUseCase(
      name: name,
      familyPackageId: familyPackageId ?? state.selectedPackage?.id,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _getFamilyRelationships() async {
    final result = await _getFamilyRelationshipsUseCase();
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(relationships: result.data));
      case ApiErrorResult():
        emit(state.copyWith(failure: result.failure));
    }
  }

  Future<void> _getFamilyAddresses() async {
    final result = await _getCustomerAddressesUseCase();
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(addresses: result.data));
      case ApiErrorResult():
        emit(state.copyWith(failure: result.failure));
    }
  }

  Future<void> _addFamilyMember({
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _addFamilyMemberUseCase(
      displayName: displayName,
      relationshipCode: relationshipCode,
      gender: gender,
      ageYears: ageYears,
      deliveryAddressId: deliveryAddressId,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _updateFamilyMember({
    required String memberId,
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _updateFamilyMemberUseCase(
      memberId: memberId,
      displayName: displayName,
      relationshipCode: relationshipCode,
      gender: gender,
      ageYears: ageYears,
      deliveryAddressId: deliveryAddressId,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _deleteFamilyMember(String memberId) async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _deleteFamilyMemberUseCase(memberId);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
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
        final programs =
            result.data.where((p) => p.programId.isNotEmpty).toList();
        int? progIdx;
        final selectedMember = state.selectedMember;
        if (selectedMember?.programId != null &&
            selectedMember!.programId!.isNotEmpty) {
          final found = programs.indexWhere(
            (p) => p.programId == selectedMember.programId,
          );
          if (found != -1) {
            progIdx = found;
          }
        }
        emit(
          state.copyWith(
            isProgramsLoading: false,
            programs: programs,
            selectedProgramIndex: progIdx,
            clearSelectedProgram: progIdx == null,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isProgramsLoading: false, failure: result.failure));
    }
  }

  void _selectProgram(int index) {
    final program =
        state.programs.length > index ? state.programs[index] : null;
    if (program == null) return;

    final updatedFlow = _updateLocalMemberInCurrentFlow(
      programId: program.programId,
    );

    emit(
      state.copyWith(
        selectedProgramIndex: index,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );

    final member = state.selectedMember;
    if (member != null) {
      _saveMemberPlan(
        memberId: member.memberId,
        programId: program.programId,
      );
    }
  }

  void _selectMember(int index) {
    if (index < 0 || index >= state.members.length) return;
    final member = state.members[index];

    int? progIdx;
    if (member.programId != null &&
        member.programId!.isNotEmpty &&
        state.programs.isNotEmpty) {
      final found = state.programs.indexWhere(
        (p) => p.programId == member.programId,
      );
      if (found != -1) {
        progIdx = found;
      }
    }

    emit(
      state.copyWith(
        selectedMemberIndex: index,
        selectedProgramIndex: progIdx,
        clearSelectedProgram: progIdx == null,
        includeFriday: member.includeFriday,
        customDurationDays: member.durationDays,
      ),
    );
  }

  void _selectMemberInPackageDays(int index) {
    if (index < 0 || index >= state.members.length) return;
    final member = state.members[index];

    int? progIdx;
    if (member.programId != null &&
        member.programId!.isNotEmpty &&
        state.programs.isNotEmpty) {
      final found = state.programs.indexWhere(
        (p) => p.programId == member.programId,
      );
      if (found != -1) {
        progIdx = found;
      }
    }

    emit(
      state.copyWith(
        selectedMemberIndex: index,
        selectedProgramIndex: progIdx,
        clearSelectedProgram: progIdx == null,
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

  Future<void> _loadMemberBundlesAndSelections(FamilyMemberEntity member) async {
    final programId = member.programId ??
        state.selectedProgram?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : null);
    if (programId == null || programId.isEmpty) {
      emit(
        state.copyWith(
          clearSelectedBundle: true,
          clearSelectedDuration: true,
          clearSelectedTier: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isBundlesLoading: true, clearFailure: true));
    final result = await _getFamilyProgramBundlesUseCase(programId);
    switch (result) {
      case ApiSuccessResult():
        final bundles =
            result.data.where((b) => b.bundleId.isNotEmpty).toList();

        int? bundleIdx;
        if (member.bundleId != null && member.bundleId!.isNotEmpty) {
          final foundIdx =
              bundles.indexWhere((b) => b.bundleId == member.bundleId);
          if (foundIdx != -1) {
            bundleIdx = foundIdx;
          }
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
          final targetBundle =
              bundleIdx != null ? bundles[bundleIdx] : bundles.first;
          await _getDurationsAndTiersForMember(
            programId: programId,
            bundleId: targetBundle.bundleId,
            member: member,
          );
        } else {
          emit(
            state.copyWith(
              isDurationsLoading: false,
              isTiersLoading: false,
              clearSelectedDuration: true,
              clearSelectedTier: true,
            ),
          );
        }
      case ApiErrorResult():
        emit(
          state.copyWith(
            isBundlesLoading: false,
            clearSelectedBundle: true,
            clearSelectedDuration: true,
            clearSelectedTier: true,
            failure: result.failure,
          ),
        );
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

    int? durationIdx;
    if (member.durationDays != null) {
      final foundDurIdx =
          durations.indexWhere((d) => d.durationDays == member.durationDays);
      if (foundDurIdx != -1) {
        durationIdx = foundDurIdx;
      }
    }

    int? tierIdx;
    if (member.selectedTier != null) {
      final foundTierIdx = tiers.indexWhere((t) {
        final tNum =
            _parseTierToInt(t.tier, t.nameEn) ?? (tiers.indexOf(t) + 1);
        return tNum == member.selectedTier;
      });
      if (foundTierIdx != -1) {
        tierIdx = foundTierIdx;
      } else if (member.selectedTier! >= 1 &&
          member.selectedTier! <= tiers.length) {
        tierIdx = member.selectedTier! - 1;
      }
    }

    emit(
      state.copyWith(
        isDurationsLoading: false,
        isTiersLoading: false,
        durations: durations,
        tiers: tiers,
        selectedDurationIndex: durationIdx,
        clearSelectedDuration: durationIdx == null,
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

  Future<void> _getBundles(String programId) async {
    emit(state.copyWith(isBundlesLoading: true, clearFailure: true));
    final result = await _getFamilyProgramBundlesUseCase(programId);
    switch (result) {
      case ApiSuccessResult():
        final bundles =
            result.data.where((b) => b.bundleId.isNotEmpty).toList();
        emit(
          state.copyWith(
            isBundlesLoading: false,
            bundles: bundles,
            clearSelectedBundle: true,
            clearSelectedDuration: true,
            clearSelectedTier: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isBundlesLoading: false, failure: result.failure));
    }
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
      _saveMemberPlan(
        memberId: member.memberId,
        bundleId: bundle.bundleId,
      );
    }

    final selectedProgram = state.selectedProgram;
    final progId = selectedProgram?.programId ?? member?.programId;
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

    final durations = durationsResult is ApiSuccessResult
        ? (durationsResult as ApiSuccessResult).data
        : state.durations;

    final tiers = tiersResult is ApiSuccessResult
        ? (tiersResult as ApiSuccessResult).data
        : state.tiers;

    final member = state.selectedMember;
    int? durIdx = state.selectedDurationIndex;
    if (durIdx != null && durIdx >= durations.length) {
      durIdx = null;
    } else if (durIdx == null && member?.durationDays != null) {
      final days = member!.durationDays;
      final f = durations.indexWhere((d) => d.durationDays == days);
      if (f != -1) durIdx = f;
    }

    int? tierIdx = state.selectedTierIndex;
    if (tierIdx != null && tierIdx >= tiers.length) {
      tierIdx = null;
    } else if (tierIdx == null && member?.selectedTier != null) {
      final selectedTier = member!.selectedTier;
      final f = tiers.indexWhere((t) {
        final tNum =
            _parseTierToInt(t.tier, t.nameEn) ?? (tiers.indexOf(t) + 1);
        return tNum == selectedTier;
      });
      if (f != -1) tierIdx = f;
    }

    emit(
      state.copyWith(
        isDurationsLoading: false,
        isTiersLoading: false,
        durations: durations,
        tiers: tiers,
        selectedDurationIndex: durIdx,
        clearSelectedDuration: durIdx == null,
        selectedTierIndex: tierIdx,
        clearSelectedTier: tierIdx == null,
      ),
    );
  }

  void _selectDuration(int index) {
    final duration =
        state.durations.length > index ? state.durations[index] : null;
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
    final updatedFlow = _updateLocalMemberInCurrentFlow(
      includeFriday: include,
    );

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

    final selectedProgram = state.selectedProgram;
    final selectedBundle = state.selectedBundle;
    final progId = selectedProgram?.programId ?? member?.programId;

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

    final tierInt =
        _parseTierToInt(tier.tier, tier.nameEn) ?? (tierIndex + 1);

    final updatedFlow = _updateLocalMemberInCurrentFlow(
      selectedTier: tierInt,
    );

    emit(
      state.copyWith(
        selectedTierIndex: tierIndex,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );

    final member = state.selectedMember;
    if (member != null) {
      _saveMemberPlan(
        memberId: member.memberId,
        tier: tierInt,
      );
    }
  }

  FamilyFlowCurrentEntity? _updateLocalMemberInCurrentFlow({
    String? programId,
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
      programId: programId ?? member.programId,
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
    final programId = state.selectedProgram?.programId ??
        member?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : '');

    SubscriptionBundleEntity? bundle = state.selectedBundle;
    if (bundle == null && member?.bundleId != null) {
      for (final b in state.bundles) {
        if (b.bundleId == member!.bundleId) {
          bundle = b;
          break;
        }
      }
    }
    bundle ??= state.bundles.isNotEmpty ? state.bundles.first : null;

    if (programId.isEmpty || bundle == null) {
      return;
    }

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
        emit(
          state.copyWith(
            currentFlow: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(failure: result.failure),
        );
    }
  }

  Future<void> _getFamilySummary({String? memberId}) async {
    emit(
      state.copyWith(
        isSummaryLoading: true,
        selectedSummaryMemberId: memberId ?? state.selectedSummaryMemberId,
        clearFailure: true,
      ),
    );
    final result = await _getFamilySummaryUseCase(memberId: memberId);
    switch (result) {
      case ApiSuccessResult():
        final summary = result.data;
        final activeMemberId =
            memberId ?? summary.selectedMember?.memberId ?? state.selectedSummaryMemberId;
        emit(
          state.copyWith(
            isSummaryLoading: false,
            summary: summary,
            selectedSummaryMemberId: activeMemberId,
          ),
        );
        _getFamilyPaymentMethods();
      case ApiErrorResult():
        emit(state.copyWith(isSummaryLoading: false, failure: result.failure));
    }
  }

  Future<void> _getFamilyPaymentMethods() async {
    final amount = state.summary?.finalPrice ?? 0.0;
    final result = await _getFamilyPaymentMethodsUseCase(amount);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            paymentMethods: result.data,
            selectedPaymentMethod:
                state.selectedPaymentMethod ??
                (result.data.isNotEmpty ? result.data.first : null),
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(failure: result.failure));
    }
  }

  Future<void> _checkoutFamilySubscription({
    required String callbackUrl,
    required String errorUrl,
    required int paymentMethodId,
  }) async {
    emit(state.copyWith(isCheckoutLoading: true, clearFailure: true));
    final result = await _checkoutFamilySubscriptionUseCase(
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      paymentMethodId: paymentMethodId,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCheckoutLoading: false, checkoutResult: result.data),
        );
      case ApiErrorResult():
        emit(state.copyWith(isCheckoutLoading: false, failure: result.failure));
    }
  }
}
