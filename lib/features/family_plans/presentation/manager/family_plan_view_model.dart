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
import 'package:meal_meat_user/features/family_plans/domain/usecase/update_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_entity.dart';
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
        _getFamilySummary();
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
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: flow),
        );
        if (flow.members.isNotEmpty) {
          final member = (state.selectedMemberIndex >= 0 &&
                  state.selectedMemberIndex < flow.members.length)
              ? flow.members[state.selectedMemberIndex]
              : flow.members.first;
          if (member.programId != null && member.programId!.isNotEmpty) {
            _selectProgramById(member.programId!);
            _loadMemberBundlesAndSelections(member);
          }
        }
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  void _selectProgramById(String programId) {
    if (state.programs.isNotEmpty) {
      final idx = state.programs.indexWhere((p) => p.programId == programId);
      if (idx != -1) {
        emit(state.copyWith(selectedProgramIndex: idx));
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
        final programs = result.data
            .where((p) => p.programId.isNotEmpty)
            .toList();
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
    emit(state.copyWith(selectedProgramIndex: index));
    final member = state.selectedMember;
    if (member != null && state.programs.length > index) {
      final program = state.programs[index];
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
        selectedProgramIndex: progIdx ?? state.selectedProgramIndex,
        includeFriday: member.includeFriday,
        customDurationDays: member.durationDays,
      ),
    );

    _loadMemberBundlesAndSelections(member);
  }

  Future<void> _loadMemberBundlesAndSelections(FamilyMemberEntity member) async {
    final programId = member.programId ??
        state.selectedProgram?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : null);
    if (programId == null || programId.isEmpty) {
      return;
    }

    emit(state.copyWith(isBundlesLoading: true, clearFailure: true));
    final result = await _getFamilyProgramBundlesUseCase(programId);
    switch (result) {
      case ApiSuccessResult():
        final bundles =
            result.data.where((b) => b.bundleId.isNotEmpty).toList();
        int bundleIdx = 0;
        if (member.bundleId != null && member.bundleId!.isNotEmpty) {
          final foundIdx =
              bundles.indexWhere((b) => b.bundleId == member.bundleId);
          if (foundIdx != -1) {
            bundleIdx = foundIdx;
          }
        } else if (bundles.isNotEmpty) {
          // If member has no bundle selected yet, select & save first bundle
          _saveMemberPlan(
            memberId: member.memberId,
            bundleId: bundles.first.bundleId,
          );
        }

        emit(
          state.copyWith(
            isBundlesLoading: false,
            bundles: bundles,
            selectedBundleIndex: bundleIdx,
          ),
        );

        if (bundles.isNotEmpty) {
          final selectedBundle = bundles[bundleIdx];
          await _getDurationsAndTiersForMember(
            programId: programId,
            bundleId: selectedBundle.bundleId,
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

    int durationIdx = 0;
    if (member.durationDays != null) {
      final foundDurIdx =
          durations.indexWhere((d) => d.durationDays == member.durationDays);
      if (foundDurIdx != -1) {
        durationIdx = foundDurIdx;
      }
    } else if (durations.isNotEmpty) {
      final defaultIdx = durations.indexWhere((d) => d.durationDays == 26);
      if (defaultIdx != -1) {
        durationIdx = defaultIdx;
      }
    }

    int tierIdx = 0;
    if (member.selectedTier != null) {
      final foundTierIdx = tiers.indexWhere((t) {
        final tNum = _parseTierToInt(t.tier, t.nameEn) ?? (tiers.indexOf(t) + 1);
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
        selectedTierIndex: tierIdx,
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
        emit(state.copyWith(isBundlesLoading: false, bundles: bundles));
        if (bundles.isNotEmpty) {
          _getDurations(
            programId: programId,
            bundleId: bundles.first.bundleId,
            includeFriday: state.includeFriday,
          );
        }
      case ApiErrorResult():
        emit(state.copyWith(isBundlesLoading: false, failure: result.failure));
    }
  }

  void _selectBundle(int index) {
    emit(state.copyWith(selectedBundleIndex: index));
    final member = state.selectedMember;
    final bundle = state.bundles.length > index ? state.bundles[index] : null;
    final selectedProgram = state.selectedProgram;

    if (member != null && bundle != null) {
      _saveMemberPlan(
        memberId: member.memberId,
        bundleId: bundle.bundleId,
      );
    }

    final progId = selectedProgram?.programId ?? member?.programId;
    if (progId != null && bundle != null) {
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
      durationDays: null,
      includeFriday: includeFriday,
    );

    final durations = durationsResult is ApiSuccessResult
        ? (durationsResult as ApiSuccessResult).data
        : state.durations;

    final tiers = tiersResult is ApiSuccessResult
        ? (tiersResult as ApiSuccessResult).data
        : state.tiers;

    emit(
      state.copyWith(
        isDurationsLoading: false,
        isTiersLoading: false,
        durations: durations,
        tiers: tiers,
      ),
    );
  }

  void _selectDuration(int index) {
    emit(state.copyWith(selectedDurationIndex: index));
    final member = state.selectedMember;
    final duration =
        state.durations.length > index ? state.durations[index] : null;
    if (member != null &&
        duration != null &&
        !duration.isCustom &&
        duration.durationDays != null) {
      _saveMemberPlan(
        memberId: member.memberId,
        durationDays: duration.durationDays,
        includeFriday: state.includeFriday,
      );
    }
  }

  void _updateCustomDuration(int days) {
    emit(state.copyWith(customDurationDays: days));
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
    emit(state.copyWith(includeFriday: include));
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
    emit(state.copyWith(selectedTierIndex: tierIndex));
    final member = state.selectedMember;
    if (member != null && state.tiers.length > tierIndex) {
      final tier = state.tiers[tierIndex];
      final tierInt =
          _parseTierToInt(tier.tier, tier.nameEn) ?? (tierIndex + 1);
      _saveMemberPlan(
        memberId: member.memberId,
        tier: tierInt,
      );
    }
  }

  Future<void> _browseTierRestaurants(int tierIndex) async {
    final selectedTier = state.tiers.length > tierIndex
        ? state.tiers[tierIndex]
        : null;
    final selectedProgram = state.selectedProgram;
    final selectedBundle = state.selectedBundle;

    if (selectedTier == null ||
        selectedProgram == null ||
        selectedBundle == null) {
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
        .toList();

    final result = await _getSubscriptionTierRestaurantsUseCase(
      programId: selectedProgram.programId,
      bundleId: selectedBundle.bundleId,
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

  Future<void> _getFamilySummary() async {
    emit(state.copyWith(isSummaryLoading: true, clearFailure: true));
    final result = await _getFamilySummaryUseCase();
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isSummaryLoading: false, summary: result.data));
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
