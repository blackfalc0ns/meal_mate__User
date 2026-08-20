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
        emit(state.copyWith(selectedTierIndex: event.tierIndex));
      case BrowseFamilyTierRestaurantsEvent():
        _browseTierRestaurants(event.tierIndex);
      case CloseFamilyBrowseRestaurantsEvent():
        emit(state.copyWith(isRestaurantsView: false));
      case SelectFamilyMemberEvent():
        emit(state.copyWith(selectedMemberIndex: event.memberIndex));
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
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
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
        emit(state.copyWith(isProgramsLoading: false, programs: programs));
      case ApiErrorResult():
        emit(state.copyWith(isProgramsLoading: false, failure: result.failure));
    }
  }

  void _selectProgram(int index) {
    emit(state.copyWith(selectedProgramIndex: index));
  }

  Future<void> _getBundles(String programId) async {
    emit(state.copyWith(isBundlesLoading: true, clearFailure: true));
    final result = await _getFamilyProgramBundlesUseCase(programId);
    switch (result) {
      case ApiSuccessResult():
        final bundles = result.data
            .where((b) => b.bundleId.isNotEmpty)
            .toList();
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
    final selectedProgram = state.selectedProgram;
    final bundle = state.bundles.length > index ? state.bundles[index] : null;

    if (selectedProgram != null && bundle != null) {
      _getDurations(
        programId: selectedProgram.programId,
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
  }

  void _updateCustomDuration(int days) {
    emit(state.copyWith(customDurationDays: days));
  }

  void _toggleFriday(bool include) {
    emit(state.copyWith(includeFriday: include));
    final selectedProgram = state.selectedProgram;
    final selectedBundle = state.selectedBundle;

    if (selectedProgram != null && selectedBundle != null) {
      _getDurations(
        programId: selectedProgram.programId,
        bundleId: selectedBundle.bundleId,
        includeFriday: include,
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
    required String programId,
    required String bundleId,
    required int tier,
    required int durationDays,
    required bool includeFriday,
  }) async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
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
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
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
