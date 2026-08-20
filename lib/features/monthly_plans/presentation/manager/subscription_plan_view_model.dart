import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tiers_usecase.dart';
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

  void doIntent(SubscriptionPlanEvent event) {
    switch (event) {
      case GetSubscriptionDurationsEvent():
        _getDurations(
          programId: event.programId,
          bundleId: event.bundleId,
          includeFriday: event.includeFriday,
        );
      case ToggleSubscriptionFridayEvent():
        if (event.includeFriday && !state.canToggleFriday) return;
        _getDurations(
          programId: event.programId,
          bundleId: event.bundleId,
          includeFriday: event.includeFriday,
        );
      case SelectSubscriptionDurationEvent():
        _selectDuration(
          programId: event.programId,
          bundleId: event.bundleId,
          durationIndex: event.durationIndex,
        );
      case UpdateCustomSubscriptionDurationEvent():
        _updateCustomDuration(
          programId: event.programId,
          bundleId: event.bundleId,
          durationDays: event.durationDays,
        );
      case SelectSubscriptionTierEvent():
        emit(state.copyWith(selectedTierIndex: event.tierIndex));
      case BrowseSubscriptionTierRestaurantsEvent():
        _browseTierRestaurants(
          programId: event.programId,
          bundleId: event.bundleId,
          tierIndex: event.tierIndex,
        );
      case CheckSubscriptionReadinessEvent():
        _checkReadiness(
          SubscriptionSummaryRequestEntity(
            includeFriday: event.includeFriday,
            durationDays: event.durationDays,
            tier: event.tier,
            bundleId: event.bundleId,
            programId: event.programId,
          ),
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
        isSuccess: false,
        includeFriday: includeFriday,
        clearSelectedDuration: true,
        clearSelectedTier: true,
        clearCustomDuration: true,
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

    switch (durationsResult) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isDurationsLoading: false,
            isSuccess: true,
            durations: durationsResult.data
                .where(
                  (duration) =>
                      (duration.durationDays ?? 0) > 0 || duration.isCustom,
                )
                .toList(),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isDurationsLoading: false,
            isTiersLoading: false,
            isSuccess: false,
            failure: durationsResult.failure,
          ),
        );
        return;
    }

    switch (tiersResult) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isTiersLoading: false,
            isSuccess: true,
            tiers: tiersResult.data
                .where((tier) => tier.tier.isNotEmpty)
                .toList(),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isTiersLoading: false,
            isSuccess: false,
            failure: tiersResult.failure,
          ),
        );
    }
  }

  Future<void> _selectDuration({
    required String programId,
    required String bundleId,
    required int durationIndex,
  }) async {
    if (durationIndex < 0 || durationIndex >= state.durations.length) return;

    final duration = state.durations[durationIndex];

    emit(
      state.copyWith(
        isTiersLoading: !duration.isCustom,
        isSuccess: false,
        selectedDurationIndex: durationIndex,
        clearCustomDuration: !duration.isCustom,
        clearSelectedTier: true,
        clearFailure: true,
      ),
    );

    if (duration.isCustom) {
      emit(state.copyWith(tiers: const [], isTiersLoading: false));
      return;
    }

    final result = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: duration.durationDays,
      includeFriday: state.includeFriday,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isTiersLoading: false,
            isSuccess: true,
            tiers: result.data.where((tier) => tier.tier.isNotEmpty).toList(),
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

  Future<void> _updateCustomDuration({
    required String programId,
    required String bundleId,
    required int? durationDays,
  }) async {
    emit(
      state.copyWith(
        customDurationDays: durationDays,
        tiers: const [],
        isTiersLoading: false,
        clearSelectedTier: true,
        clearCustomDuration: durationDays == null,
        clearFailure: true,
      ),
    );

    if (!state.isSelectedDurationValid) return;

    emit(state.copyWith(isTiersLoading: true, isSuccess: false));

    final result = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: state.selectedDurationDays,
      includeFriday: state.includeFriday,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isTiersLoading: false,
            isSuccess: true,
            tiers: result.data.where((tier) => tier.tier.isNotEmpty).toList(),
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

  Future<void> _browseTierRestaurants({
    required String programId,
    required String bundleId,
    required int tierIndex,
  }) async {
    if (tierIndex < 0 || tierIndex >= state.tiers.length) return;

    final tier = state.tiers[tierIndex];
    final restaurantIds = tier.restaurants
        .map((restaurant) => restaurant.restaurantId)
        .where((restaurantId) => restaurantId.isNotEmpty)
        .toList();

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

  Future<void> _checkReadiness(SubscriptionSummaryRequestEntity request) async {
    emit(
      state.copyWith(
        isReadinessLoading: true,
        clearReadiness: true,
        clearReadinessFailure: true,
      ),
    );

    final result = await _getSubscriptionReadinessUseCase(request);

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
}
