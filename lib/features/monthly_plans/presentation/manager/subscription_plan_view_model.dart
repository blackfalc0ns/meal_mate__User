import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/constants/durations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_readiness_usecase.dart';

@injectable
class SubscriptionPlanViewModel extends Cubit<SubscriptionPlanState> {
  SubscriptionPlanViewModel(
    this._getSubscriptionDurationsUseCase,
    this._getSubscriptionTiersUseCase,
    this._getSubscriptionTierRestaurantsUseCase,
    this._getSubscriptionReadinessUseCase,
  ) : super(const SubscriptionPlanState());

  final GetSubscriptionDurationsUseCase _getSubscriptionDurationsUseCase;
  final GetSubscriptionTiersUseCase _getSubscriptionTiersUseCase;
  final GetSubscriptionTierRestaurantsUseCase
  _getSubscriptionTierRestaurantsUseCase;
  final GetSubscriptionReadinessUseCase _getSubscriptionReadinessUseCase;

  Timer? _customDurationDebounceTimer;

  void doIntent(SubscriptionPlanEvent event) {
    switch (event) {
      case GetSubscriptionDurationsEvent():
        unawaited(
          _getDurations(
            programId: event.programId,
            bundleId: event.bundleId,
            includeFriday: event.includeFriday,
          ),
        );
      case ToggleSubscriptionFridayEvent():
        if (event.includeFriday && !state.canToggleFriday) return;
        unawaited(
          _toggleFriday(
            programId: event.programId,
            bundleId: event.bundleId,
            includeFriday: event.includeFriday,
          ),
        );
      case SelectSubscriptionDurationEvent():
        unawaited(
          _selectDuration(
            programId: event.programId,
            bundleId: event.bundleId,
            durationIndex: event.durationIndex,
          ),
        );
      case UpdateCustomSubscriptionDurationEvent():
        unawaited(
          _updateCustomDuration(
            programId: event.programId,
            bundleId: event.bundleId,
            durationDays: event.durationDays,
          ),
        );
      case SelectSubscriptionTierEvent():
        emit(state.copyWith(selectedTierIndex: event.tierIndex));
      case BrowseSubscriptionTierRestaurantsEvent():
        unawaited(
          _browseTierRestaurants(
            programId: event.programId,
            bundleId: event.bundleId,
            tierIndex: event.tierIndex,
          ),
        );
      case CloseSubscriptionTierRestaurantsEvent():
        _closeTierRestaurants();
      case CheckSubscriptionReadinessEvent():
        unawaited(
          _checkReadiness(
            SubscriptionSummaryRequestEntity(
              includeFriday: event.includeFriday,
              durationDays: event.durationDays,
              tier: event.tier,
              bundleId: event.bundleId,
              programId: event.programId,
            ),
          ),
        );
    }
  }

  Future<void> _getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) async {
    _customDurationDebounceTimer?.cancel();
    emit(
      state.copyWith(
        isDurationsLoading: true,
        isTiersLoading: true,
        isSuccess: false,
        includeFriday: includeFriday,
        clearSelectedDuration: true,
        clearSelectedTier: true,
        clearCustomDuration: true,
        clearFailure: true,
      ),
    );

    final result = await _fetchDurationsAndTiers(
      programId: programId,
      bundleId: bundleId,
      includeFriday: includeFriday,
      durationDays: null,
    );

    if (isClosed) return;

    if (result.failure != null) {
      emit(
        state.copyWith(
          isDurationsLoading: false,
          isTiersLoading: false,
          isSuccess: false,
          durations: result.durations ?? state.durations,
          failure: result.failure,
        ),
      );
      return;
    }

    final validTiers = result.tiers ?? const [];
    emit(
      state.copyWith(
        isDurationsLoading: false,
        isTiersLoading: false,
        isSuccess: true,
        durations: result.durations ?? const [],
        tiers: validTiers,
        selectedTierIndex:
            state.selectedTierIndex ?? (validTiers.isNotEmpty ? 0 : null),
      ),
    );
  }

  Future<void> _toggleFriday({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) async {
    _customDurationDebounceTimer?.cancel();

    final selectedDuration = state.selectedDuration;
    final isCustom = selectedDuration?.isCustom ?? false;
    final shouldFetchTiers = selectedDuration != null &&
        (!isCustom || state.isSelectedDurationValid);

    emit(
      state.copyWith(
        includeFriday: includeFriday,
        isTiersLoading: shouldFetchTiers,
        clearFailure: true,
      ),
    );

    if (!shouldFetchTiers) return;

    final durationDays = isCustom
        ? state.customDurationDays
        : selectedDuration.durationDays;

    final result = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: durationDays,
      includeFriday: includeFriday,
    );

    _handleTiersResult(result);
  }

  Future<void> _selectDuration({
    required String programId,
    required String bundleId,
    required int durationIndex,
  }) async {
    if (durationIndex < 0 || durationIndex >= state.durations.length) return;

    _customDurationDebounceTimer?.cancel();
    final duration = state.durations[durationIndex];

    emit(
      state.copyWith(
        isTiersLoading: !duration.isCustom,
        isSuccess: false,
        selectedDurationIndex: durationIndex,
        clearCustomDuration: !duration.isCustom,
        clearFailure: true,
      ),
    );

    if (duration.isCustom) return;

    final result = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: duration.durationDays,
      includeFriday: state.includeFriday,
    );

    _handleTiersResult(result);
  }

  Future<void> _updateCustomDuration({
    required String programId,
    required String bundleId,
    required int? durationDays,
  }) async {
    _customDurationDebounceTimer?.cancel();

    emit(
      state.copyWith(
        customDurationDays: durationDays,
        clearCustomDuration: durationDays == null,
        clearFailure: true,
      ),
    );

    if (!state.isSelectedDurationValid) {
      emit(state.copyWith(isTiersLoading: false));
      return;
    }

    emit(state.copyWith(isTiersLoading: true, isSuccess: false));

    _customDurationDebounceTimer = Timer(AppDurations.debounce, () async {
      if (isClosed) return;
      final result = await _getSubscriptionTiersUseCase(
        programId: programId,
        bundleId: bundleId,
        durationDays: state.selectedDurationDays,
        includeFriday: state.includeFriday,
      );

      _handleTiersResult(result);
    });
  }

  Future<void> _browseTierRestaurants({
    required String programId,
    required String bundleId,
    required int tierIndex,
  }) async {
    if (tierIndex < 0 || tierIndex >= state.tiers.length) return;

    final tier = state.tiers[tierIndex];
    emit(
      state.copyWith(
        isBrowseRestaurantsLoading: true,
        browsedTierIndex: tierIndex,
        clearBrowseRestaurants: true,
        clearBrowseRestaurantsFailure: true,
      ),
    );

    final result = await _getSubscriptionTierRestaurantsUseCase(
      programId: programId,
      bundleId: bundleId,
      tier: tier.tier,
    );

    if (isClosed) return;

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

  void _closeTierRestaurants() {
    emit(
      state.copyWith(
        clearBrowsedTier: true,
        clearBrowseRestaurants: true,
        clearBrowseRestaurantsFailure: true,
        isBrowseRestaurantsLoading: false,
      ),
    );
  }

  Future<void> _checkReadiness(SubscriptionSummaryRequestEntity request) async {
    emit(
      state.copyWith(
        isReadinessLoading: true,
        clearReadiness: true,
        clearReadinessFailure: true,
      ),
    );

    final result = await _getSubscriptionReadinessUseCase(request);

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isReadinessLoading: false,
            readiness: result.data,
            clearReadinessFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isReadinessLoading: false,
            readinessFailure: result.failure,
          ),
        );
    }
  }

  Future<
    ({
      List<SubscriptionDurationEntity>? durations,
      List<SubscriptionTierEntity>? tiers,
      Failure? failure,
    })
  >
  _fetchDurationsAndTiers({
    required String programId,
    required String bundleId,
    required bool includeFriday,
    required int? durationDays,
  }) async {
    final results = await Future.wait([
      _getSubscriptionDurationsUseCase(
        programId: programId,
        bundleId: bundleId,
        includeFriday: includeFriday,
      ),
      _getSubscriptionTiersUseCase(
        programId: programId,
        bundleId: bundleId,
        durationDays: durationDays,
        includeFriday: includeFriday,
      ),
    ]);

    final durationsResult =
        results[0] as ApiResult<List<SubscriptionDurationEntity>>;
    final tiersResult = results[1] as ApiResult<List<SubscriptionTierEntity>>;

    if (durationsResult is ApiErrorResult<List<SubscriptionDurationEntity>>) {
      return (durations: null, tiers: null, failure: durationsResult.failure);
    }

    final validDurations =
        (durationsResult as ApiSuccessResult<List<SubscriptionDurationEntity>>)
            .data
            .where(
              (duration) =>
                  (duration.durationDays ?? 0) > 0 || duration.isCustom,
            )
            .toList();

    if (tiersResult is ApiErrorResult<List<SubscriptionTierEntity>>) {
      return (
        durations: validDurations,
        tiers: null,
        failure: tiersResult.failure,
      );
    }

    final validTiers =
        (tiersResult as ApiSuccessResult<List<SubscriptionTierEntity>>).data
            .where((tier) => tier.tier.isNotEmpty)
            .toList();

    return (durations: validDurations, tiers: validTiers, failure: null);
  }

  void _handleTiersResult(ApiResult<List<SubscriptionTierEntity>> result) {
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final validTiers = result.data
            .where((tier) => tier.tier.isNotEmpty)
            .toList();
        final currentSelected = state.selectedTierIndex ?? 0;
        final targetSelected = validTiers.isNotEmpty
            ? (currentSelected < validTiers.length ? currentSelected : 0)
            : null;
        emit(
          state.copyWith(
            isTiersLoading: false,
            isSuccess: true,
            tiers: validTiers,
            selectedTierIndex: targetSelected,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isTiersLoading: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }


  @override
  Future<void> close() {
    _customDurationDebounceTimer?.cancel();
    return super.close();
  }
}
