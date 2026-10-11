import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/constants/durations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_page_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_readiness_usecase.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_restaurant_availability_usecase.dart';

@injectable
class SubscriptionPlanViewModel extends Cubit<SubscriptionPlanState> {
  SubscriptionPlanViewModel(
    this._getSubscriptionDurationsUseCase,
    this._getSubscriptionTiersUseCase,
    this._getSubscriptionTierRestaurantsUseCase,
    this._getSubscriptionReadinessUseCase, [
    this._getSubscriptionTierRestaurantsPageUseCase,
    this._getSubscriptionRestaurantAvailabilityUseCase,
  ]) : super(const SubscriptionPlanState());

  @visibleForTesting
  SubscriptionPlanViewModel.withState(
    this._getSubscriptionDurationsUseCase,
    this._getSubscriptionTiersUseCase,
    this._getSubscriptionTierRestaurantsUseCase,
    this._getSubscriptionReadinessUseCase, {
    this._getSubscriptionTierRestaurantsPageUseCase,
    this._getSubscriptionRestaurantAvailabilityUseCase,
    SubscriptionPlanState? initialState,
  }) : super(initialState ?? const SubscriptionPlanState());

  final GetSubscriptionDurationsUseCase _getSubscriptionDurationsUseCase;
  final GetSubscriptionTiersUseCase _getSubscriptionTiersUseCase;
  final GetSubscriptionTierRestaurantsUseCase
  _getSubscriptionTierRestaurantsUseCase;
  final GetSubscriptionReadinessUseCase _getSubscriptionReadinessUseCase;
  final GetSubscriptionTierRestaurantsPageUseCase?
  _getSubscriptionTierRestaurantsPageUseCase;
  final GetSubscriptionRestaurantAvailabilityUseCase?
  _getSubscriptionRestaurantAvailabilityUseCase;

  Timer? _customDurationDebounceTimer;
  int _browseGeneration = 0;
  int _tiersGeneration = 0;

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
        if (event.tierIndex >= 0 && event.tierIndex < state.tiers.length) {
          if (!state.tiers[event.tierIndex].effectiveCanSelect) {
            return;
          }
        }
        emit(state.copyWith(selectedTierIndex: event.tierIndex));
      case InvalidateSubscriptionPlanContextEvent():
        _customDurationDebounceTimer?.cancel();
        _tiersGeneration++;
        _browseGeneration++;
        emit(
          state.copyWith(
            isTiersLoading: false,
            tiers: const [],
            clearSelectedTier: true,
            clearCustomDuration: true,
            clearFailure: true,
          ),
        );
      case SelectSubscriptionPlanStartDateEvent():
        emit(state.copyWith(selectedStartDate: event.startDate));
        if (state.isBrowsingRestaurants && state.browsedTierIndex != null) {
          unawaited(
            _browseTierRestaurants(
              programId: state.browsingProgramId ?? '',
              bundleId: state.browsingBundleId ?? '',
              tierIndex: state.browsedTierIndex!,
              startDate: event.startDate,
            ),
          );
        }
      case BrowseSubscriptionTierRestaurantsEvent():
        unawaited(
          _browseTierRestaurants(
            programId: event.programId,
            bundleId: event.bundleId,
            tierIndex: event.tierIndex,
            startDate: event.startDate,
          ),
        );
      case CloseSubscriptionTierRestaurantsEvent():
        _closeTierRestaurants();
      case LoadMoreSubscriptionTierRestaurantsEvent():
        unawaited(_loadMoreTierRestaurants());
      case RetrySubscriptionTierRestaurantsEvent():
        _retryTierRestaurants();
      case CheckSubscriptionReadinessEvent():
        unawaited(
          _checkReadiness(
            SubscriptionSummaryRequestEntity(
              includeFriday: event.includeFriday,
              durationDays: event.durationDays,
              tier: event.tier,
              bundleId: event.bundleId,
              programId: event.programId,
              startDate: state.selectedStartDate ?? '',
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
    final generation = ++_tiersGeneration;

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

    if (isClosed || generation != _tiersGeneration) return;

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
    final currentSelected = state.selectedTierIndex;
    int? targetSelected;
    if (currentSelected != null &&
        currentSelected < validTiers.length &&
        validTiers[currentSelected].effectiveCanSelect) {
      targetSelected = currentSelected;
    } else {
      final firstSelectable = validTiers.indexWhere(
        (t) => t.effectiveCanSelect,
      );
      targetSelected = firstSelectable != -1 ? firstSelectable : null;
    }
    emit(
      state.copyWith(
        isDurationsLoading: false,
        isTiersLoading: false,
        isSuccess: true,
        durations: result.durations ?? const [],
        tiers: validTiers,
        selectedTierIndex: targetSelected,
      ),
    );
  }

  Future<void> _toggleFriday({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) async {
    _customDurationDebounceTimer?.cancel();
    final generation = ++_tiersGeneration;

    final selectedDuration = state.selectedDuration;
    final isCustom = selectedDuration?.isCustom ?? false;
    final shouldFetchTiers =
        selectedDuration != null &&
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
      startDate: state.selectedStartDate,
    );

    _handleTiersResult(result, generation);
    if (state.isBrowsingRestaurants && state.browsedTierIndex != null) {
      unawaited(
        _browseTierRestaurants(
          programId: state.browsingProgramId ?? programId,
          bundleId: state.browsingBundleId ?? bundleId,
          tierIndex: state.browsedTierIndex!,
          startDate: state.selectedStartDate,
          forceRefresh: true,
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

    _customDurationDebounceTimer?.cancel();
    final generation = ++_tiersGeneration;
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
      startDate: state.selectedStartDate,
    );

    _handleTiersResult(result, generation);
    if (state.isBrowsingRestaurants && state.browsedTierIndex != null) {
      unawaited(
        _browseTierRestaurants(
          programId: state.browsingProgramId ?? programId,
          bundleId: state.browsingBundleId ?? bundleId,
          tierIndex: state.browsedTierIndex!,
          startDate: state.selectedStartDate,
          forceRefresh: true,
        ),
      );
    }
  }

  Future<void> _updateCustomDuration({
    required String programId,
    required String bundleId,
    required int? durationDays,
  }) async {
    _customDurationDebounceTimer?.cancel();
    final generation = ++_tiersGeneration;

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
      if (isClosed || generation != _tiersGeneration) return;
      final result = await _getSubscriptionTiersUseCase(
        programId: programId,
        bundleId: bundleId,
        durationDays: state.selectedDurationDays,
        includeFriday: state.includeFriday,
        startDate: state.selectedStartDate,
      );

      _handleTiersResult(result, generation);
      if (state.isBrowsingRestaurants && state.browsedTierIndex != null) {
        unawaited(
          _browseTierRestaurants(
            programId: state.browsingProgramId ?? programId,
            bundleId: state.browsingBundleId ?? bundleId,
            tierIndex: state.browsedTierIndex!,
            startDate: state.selectedStartDate,
            forceRefresh: true,
          ),
        );
      }
    });
  }

  Future<void> _browseTierRestaurants({
    required String programId,
    required String bundleId,
    required int tierIndex,
    String? startDate,
    bool forceRefresh = false,
  }) async {
    if (tierIndex < 0 || tierIndex >= state.tiers.length) return;

    final tier = state.tiers[tierIndex];
    final effectiveStartDate = startDate ?? state.selectedStartDate;

    if (!forceRefresh &&
        !state.isBrowseRestaurantsLoading &&
        state.browsedTierIndex == tierIndex &&
        state.browsingProgramId == programId &&
        state.browsingBundleId == bundleId &&
        state.browsingTier == tier.tier &&
        state.browsingDurationDays == state.selectedDurationDays &&
        state.browsingStartDate == effectiveStartDate &&
        state.browsingIncludeFriday == state.includeFriday &&
        state.browseRestaurants.isNotEmpty &&
        state.browseRestaurantsFailure == null) {
      return;
    }

    final generation = ++_browseGeneration;

    emit(
      state.copyWith(
        isBrowseRestaurantsLoading: true,
        isBrowseRestaurantsLoadingMore: false,
        browsedTierIndex: tierIndex,
        browsingProgramId: programId,
        browsingBundleId: bundleId,
        browsingTier: tier.tier,
        browsingDurationDays: state.selectedDurationDays,
        browsingStartDate: effectiveStartDate,
        browsingIncludeFriday: state.includeFriday,
        selectedStartDate: effectiveStartDate,
        clearBrowseRestaurants: true,
        clearBrowseRestaurantsFailure: true,
        clearBrowseRestaurantsLoadMoreFailure: true,
        clearBrowseRestaurantsPagination: true,
        clearBrowseAvailability: true,
        clearBrowseTotalCount: true,
      ),
    );

    final hasEffectiveStartDate =
        effectiveStartDate != null && effectiveStartDate.trim().isNotEmpty;

    if (_getSubscriptionRestaurantAvailabilityUseCase != null &&
        hasEffectiveStartDate) {
      final request = SubscriptionSummaryRequestEntity(
        programId: programId,
        bundleId: bundleId,
        tier: tier.tier,
        durationDays: state.selectedDurationDays ?? 0,
        startDate: effectiveStartDate,
        includeFriday: state.includeFriday,
        restaurantsPage: 1,
        restaurantsPageSize: 10,
      );

      final result = await _getSubscriptionRestaurantAvailabilityUseCase(
        request,
      );

      if (isClosed || generation != _browseGeneration) return;

      switch (result) {
        case ApiSuccessResult():
          final availability = result.data.availability;
          final isAvailable =
              availability.status == 'available' &&
              !availability.isNoPreparedRestaurants &&
              availability.effectiveCanSelect;

          if (!isAvailable) {
            final failureCode = availability.isNoPreparedRestaurants
                ? SubscriptionErrorCodes.noPreparedRestaurants
                : (availability.messageCode.isNotEmpty
                      ? availability.messageCode
                      : (availability.failureReasons.isNotEmpty
                            ? availability.failureReasons.first
                            : availability.status));

            emit(
              state.copyWith(
                isBrowseRestaurantsLoading: false,
                browseRestaurants: const [],
                browseRestaurantsPagination: result.data.pagination,
                browseAvailability: availability,
                browseTotalCount: 0,
                browseRestaurantsFailure: Failure(
                  code: failureCode,
                  errorMessage: '',
                ),
              ),
            );
            return;
          }

          final validItems = result.data.restaurants
              .where((r) => r.restaurantId.trim().isNotEmpty)
              .map((r) => r.toBrowseEntity())
              .toList();

          emit(
            state.copyWith(
              isBrowseRestaurantsLoading: false,
              browseRestaurants: validItems,
              browseRestaurantsPagination: result.data.pagination,
              browseAvailability: availability,
              browseTotalCount: result.data.totalCount,
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
      return;
    }

    if (_getSubscriptionTierRestaurantsPageUseCase != null) {
      final result = await _getSubscriptionTierRestaurantsPageUseCase(
        programId: programId,
        bundleId: bundleId,
        tier: tier.tier,
        durationDays: state.selectedDurationDays,
        startDate: effectiveStartDate,
        includeFriday: state.includeFriday,
        page: 1,
        pageSize: 10,
      );

      if (isClosed || generation != _browseGeneration) return;

      switch (result) {
        case ApiSuccessResult():
          final validItems = result.data.items
              .where((r) => r.restaurantId.trim().isNotEmpty)
              .toList();
          emit(
            state.copyWith(
              isBrowseRestaurantsLoading: false,
              browseRestaurants: validItems,
              browseRestaurantsPagination: result.data.pagination,
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
      return;
    }

    if (_getSubscriptionRestaurantAvailabilityUseCase != null) {
      emit(
        state.copyWith(
          isBrowseRestaurantsLoading: false,
          browseAvailability: const SubscriptionAvailabilityEntity(
            status: 'selection_required',
            coveredRestaurantCount: 0,
            eligibleRestaurantCount: 0,
            effectiveStartDate: '',
            messageCode: 'subscription_flow.selection_required',
          ),
          browseTotalCount: 0,
          browseRestaurants: const [],
        ),
      );
      return;
    }

    final result = await _getSubscriptionTierRestaurantsUseCase(
      programId: programId,
      bundleId: bundleId,
      tier: tier.tier,
      durationDays: state.selectedDurationDays,
      startDate: effectiveStartDate,
      includeFriday: state.includeFriday,
    );

    if (isClosed || generation != _browseGeneration) return;

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

  Future<void> _loadMoreTierRestaurants() async {
    if (state.isBrowseRestaurantsLoading ||
        state.isBrowseRestaurantsLoadingMore) {
      return;
    }

    final pagination = state.browseRestaurantsPagination;
    if (pagination != null && !pagination.hasNextPage) {
      return;
    }

    final programId = state.browsingProgramId;
    final bundleId = state.browsingBundleId;
    final tier = state.browsingTier;
    if (programId == null || bundleId == null || tier == null) {
      return;
    }

    final nextPage = (pagination?.page ?? 1) + 1;
    final generation = _browseGeneration;

    emit(
      state.copyWith(
        isBrowseRestaurantsLoadingMore: true,
        clearBrowseRestaurantsLoadMoreFailure: true,
      ),
    );

    final effectiveBrowsingStartDate =
        state.browsingStartDate ?? state.selectedStartDate;
    final hasBrowsingStartDate =
        effectiveBrowsingStartDate != null &&
        effectiveBrowsingStartDate.trim().isNotEmpty;

    if (_getSubscriptionRestaurantAvailabilityUseCase != null &&
        hasBrowsingStartDate) {
      final request = SubscriptionSummaryRequestEntity(
        programId: programId,
        bundleId: bundleId,
        tier: tier,
        durationDays:
            state.browsingDurationDays ?? state.selectedDurationDays ?? 0,
        startDate: effectiveBrowsingStartDate,
        includeFriday: state.browsingIncludeFriday ?? state.includeFriday,
        restaurantsPage: nextPage,
        restaurantsPageSize: pagination?.pageSize ?? 10,
      );

      final result = await _getSubscriptionRestaurantAvailabilityUseCase(
        request,
      );

      if (isClosed || generation != _browseGeneration) return;

      switch (result) {
        case ApiSuccessResult():
          final existingIds = state.browseRestaurants
              .map((r) => r.restaurantId)
              .toSet();
          final newItems = result.data.restaurants
              .where(
                (r) =>
                    r.restaurantId.trim().isNotEmpty &&
                    !existingIds.contains(r.restaurantId),
              )
              .map((r) => r.toBrowseEntity())
              .toList();
          emit(
            state.copyWith(
              isBrowseRestaurantsLoadingMore: false,
              browseRestaurants: [...state.browseRestaurants, ...newItems],
              browseRestaurantsPagination: result.data.pagination,
              browseAvailability: result.data.availability,
              browseTotalCount: result.data.totalCount,
              clearBrowseRestaurantsLoadMoreFailure: true,
            ),
          );
        case ApiErrorResult():
          emit(
            state.copyWith(
              isBrowseRestaurantsLoadingMore: false,
              browseRestaurantsLoadMoreFailure: result.failure,
            ),
          );
      }
      return;
    }

    if (_getSubscriptionTierRestaurantsPageUseCase == null) {
      return;
    }

    final result = await _getSubscriptionTierRestaurantsPageUseCase(
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      durationDays: state.browsingDurationDays ?? state.selectedDurationDays,
      startDate: effectiveBrowsingStartDate,
      includeFriday: state.browsingIncludeFriday ?? state.includeFriday,
      page: nextPage,
      pageSize: pagination?.pageSize ?? 10,
    );

    if (isClosed || generation != _browseGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final existingIds = state.browseRestaurants
            .map((r) => r.restaurantId)
            .toSet();
        final newItems = result.data.items
            .where(
              (r) =>
                  r.restaurantId.trim().isNotEmpty &&
                  !existingIds.contains(r.restaurantId),
            )
            .toList();
        emit(
          state.copyWith(
            isBrowseRestaurantsLoadingMore: false,
            browseRestaurants: [...state.browseRestaurants, ...newItems],
            browseRestaurantsPagination: result.data.pagination,
            clearBrowseRestaurantsLoadMoreFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isBrowseRestaurantsLoadingMore: false,
            browseRestaurantsLoadMoreFailure: result.failure,
          ),
        );
    }
  }

  void _retryTierRestaurants() {
    if (state.browseRestaurantsLoadMoreFailure != null) {
      unawaited(_loadMoreTierRestaurants());
    } else if (state.browseRestaurantsFailure != null) {
      final browsedIndex = state.browsedTierIndex;
      final programId = state.browsingProgramId;
      final bundleId = state.browsingBundleId;
      if (browsedIndex != null && programId != null && bundleId != null) {
        unawaited(
          _browseTierRestaurants(
            programId: programId,
            bundleId: bundleId,
            tierIndex: browsedIndex,
            startDate: state.browsingStartDate ?? state.selectedStartDate,
          ),
        );
      }
    }
  }

  void _closeTierRestaurants() {
    _browseGeneration++;
    emit(
      state.copyWith(
        clearBrowsedTier: true,
        clearBrowseRestaurants: true,
        clearBrowseRestaurantsFailure: true,
        clearBrowseRestaurantsLoadMoreFailure: true,
        clearBrowseRestaurantsPagination: true,
        clearBrowseAvailability: true,
        clearBrowseTotalCount: true,
        clearBrowsingContext: true,
        isBrowseRestaurantsLoading: false,
        isBrowseRestaurantsLoadingMore: false,
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
        startDate: state.selectedStartDate,
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

  void _handleTiersResult(
    ApiResult<List<SubscriptionTierEntity>> result,
    int generation,
  ) {
    if (isClosed || generation != _tiersGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final validTiers = result.data
            .where((tier) => tier.tier.isNotEmpty)
            .toList();
        final currentSelected = state.selectedTierIndex;
        int? targetSelected;
        if (currentSelected != null &&
            currentSelected < validTiers.length &&
            validTiers[currentSelected].effectiveCanSelect) {
          targetSelected = currentSelected;
        } else {
          final firstSelectable = validTiers.indexWhere(
            (t) => t.effectiveCanSelect,
          );
          targetSelected = firstSelectable != -1 ? firstSelectable : null;
        }
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
