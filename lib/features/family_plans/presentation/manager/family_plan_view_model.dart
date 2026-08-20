import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';

@injectable
class FamilyPlanViewModel extends Cubit<FamilyPlanState> {
  FamilyPlanViewModel(
    this._getSubscriptionProgramsUseCase,
    this._getSubscriptionProgramBundlesUseCase,
    this._getSubscriptionDurationsUseCase,
    this._getSubscriptionTiersUseCase,
    this._getSubscriptionTierRestaurantsUseCase,
  ) : super(const FamilyPlanState());

  final GetSubscriptionProgramsUseCase _getSubscriptionProgramsUseCase;
  final GetSubscriptionProgramBundlesUseCase
  _getSubscriptionProgramBundlesUseCase;
  final GetSubscriptionDurationsUseCase _getSubscriptionDurationsUseCase;
  final GetSubscriptionTiersUseCase _getSubscriptionTiersUseCase;
  final GetSubscriptionTierRestaurantsUseCase
  _getSubscriptionTierRestaurantsUseCase;

  void doIntent(FamilyPlanEvent event) {
    switch (event) {
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
        _updateCustomDuration(event.durationDays);
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
    }
  }

  Future<void> _getPrograms() async {
    emit(
      state.copyWith(
        isProgramsLoading: true,
        clearFailure: true,
      ),
    );

    final result = await _getSubscriptionProgramsUseCase();

    switch (result) {
      case ApiSuccessResult():
        final programs =
            result.data.where((p) => p.programId.isNotEmpty).toList();
        emit(
          state.copyWith(
            isProgramsLoading: false,
            programs: programs,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isProgramsLoading: false,
            failure: result.failure,
          ),
        );
    }
  }

  void _selectProgram(int index) {
    emit(state.copyWith(selectedProgramIndex: index));
  }

  Future<void> _getBundles(String programId) async {
    emit(
      state.copyWith(
        isBundlesLoading: true,
        clearFailure: true,
      ),
    );

    final result = await _getSubscriptionProgramBundlesUseCase(programId);

    switch (result) {
      case ApiSuccessResult():
        final bundles =
            result.data.where((b) => b.bundleId.isNotEmpty).toList();
        emit(
          state.copyWith(
            isBundlesLoading: false,
            bundles: bundles,
          ),
        );
        if (bundles.isNotEmpty) {
          _getDurations(
            programId: programId,
            bundleId: bundles.first.bundleId,
            includeFriday: state.includeFriday,
          );
        }
      case ApiErrorResult():
        emit(
          state.copyWith(
            isBundlesLoading: false,
            failure: result.failure,
          ),
        );
    }
  }

  void _selectBundle(int index) {
    emit(state.copyWith(selectedBundleIndex: index));
    final bundle = state.selectedBundle;
    final programId = state.selectedProgram?.programId ?? bundle?.programId;
    if (programId != null && programId.isNotEmpty && bundle != null) {
      _getTiers(
        programId: programId,
        bundleId: bundle.bundleId,
        durationDays: state.selectedDurationDays,
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
        clearFailure: true,
      ),
    );

    final result = await _getSubscriptionDurationsUseCase(
      programId: programId,
      bundleId: bundleId,
      includeFriday: includeFriday,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isDurationsLoading: false,
            durations: result.data,
          ),
        );
        final defaultDuration =
            result.data.isNotEmpty ? result.data.first : null;
        if (defaultDuration != null) {
          _getTiers(
            programId: programId,
            bundleId: bundleId,
            durationDays: defaultDuration.durationDays,
            includeFriday: includeFriday,
          );
        }
      case ApiErrorResult():
        emit(
          state.copyWith(
            isDurationsLoading: false,
            failure: result.failure,
          ),
        );
    }
  }

  void _selectDuration(int index) {
    emit(state.copyWith(selectedDurationIndex: index));
    final bundle = state.selectedBundle;
    final programId = state.selectedProgram?.programId ?? bundle?.programId;
    if (programId != null && programId.isNotEmpty && bundle != null) {
      final duration =
          index >= 0 && index < state.durations.length
              ? state.durations[index]
              : null;
      _getTiers(
        programId: programId,
        bundleId: bundle.bundleId,
        durationDays: duration?.isCustom == true
            ? state.customDurationDays
            : duration?.durationDays,
        includeFriday: state.includeFriday,
      );
    }
  }

  void _updateCustomDuration(int? durationDays) {
    emit(state.copyWith(customDurationDays: durationDays));
    final bundle = state.selectedBundle;
    final programId = state.selectedProgram?.programId ?? bundle?.programId;
    if (programId != null && programId.isNotEmpty && bundle != null) {
      _getTiers(
        programId: programId,
        bundleId: bundle.bundleId,
        durationDays: durationDays,
        includeFriday: state.includeFriday,
      );
    }
  }

  void _toggleFriday(bool includeFriday) {
    emit(state.copyWith(includeFriday: includeFriday));
    final bundle = state.selectedBundle;
    final programId = state.selectedProgram?.programId ?? bundle?.programId;
    if (programId != null && programId.isNotEmpty && bundle != null) {
      _getDurations(
        programId: programId,
        bundleId: bundle.bundleId,
        includeFriday: includeFriday,
      );
    }
  }

  Future<void> _getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  }) async {
    emit(
      state.copyWith(
        isTiersLoading: true,
        clearFailure: true,
      ),
    );

    final result = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: durationDays,
      includeFriday: includeFriday,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isTiersLoading: false,
            tiers: result.data.where((t) => t.tier.isNotEmpty).toList(),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isTiersLoading: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _browseTierRestaurants(int tierIndex) async {
    emit(
      state.copyWith(
        selectedTierIndex: tierIndex,
        isRestaurantsView: true,
        isBrowseRestaurantsLoading: true,
        browsedTierIndex: tierIndex,
        clearBrowseRestaurants: true,
        clearBrowseRestaurantsFailure: true,
      ),
    );

    final tier =
        tierIndex >= 0 && tierIndex < state.tiers.length
            ? state.tiers[tierIndex]
            : null;

    final bundle = state.selectedBundle;
    final programId = state.selectedProgram?.programId ?? bundle?.programId;

    if (tier == null ||
        programId == null ||
        programId.isEmpty ||
        bundle == null) {
      emit(state.copyWith(isBrowseRestaurantsLoading: false));
      return;
    }

    final restaurantIds = tier.restaurants
        .map((r) => r.restaurantId)
        .where((id) => id.isNotEmpty)
        .toList();

    final result = await _getSubscriptionTierRestaurantsUseCase(
      programId: programId,
      bundleId: bundle.bundleId,
      tier: tier.tier,
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
}
