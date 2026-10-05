import 'package:flutter/foundation.dart';
import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_tier_design.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';

export 'subscription_plan_state_mapper.dart';
export 'subscription_tier_design.dart';


class SubscriptionPlanState {
  const SubscriptionPlanState({
    this.isDurationsLoading = false,
    this.isTiersLoading = false,
    this.isBrowseRestaurantsLoading = false,
    this.isBrowseRestaurantsLoadingMore = false,
    this.isReadinessLoading = false,
    this.isSuccess = false,
    this.includeFriday = false,
    this.durations = const [],
    this.tiers = const [],
    this.selectedDurationIndex,
    this.selectedTierIndex,
    this.customDurationDays,
    this.browsedTierIndex,
    this.browseRestaurants = const [],
    this.browseRestaurantsPagination,
    this.browsingProgramId,
    this.browsingBundleId,
    this.browsingTier,
    this.readiness,
    this.failure,
    this.browseRestaurantsFailure,
    this.browseRestaurantsLoadMoreFailure,
    this.readinessFailure,
  });

  final bool isDurationsLoading;
  final bool isTiersLoading;
  final bool isBrowseRestaurantsLoading;
  final bool isBrowseRestaurantsLoadingMore;
  final bool isReadinessLoading;
  final bool isSuccess;
  final bool includeFriday;
  final List<SubscriptionDurationEntity> durations;
  final List<SubscriptionTierEntity> tiers;
  final int? selectedDurationIndex;
  final int? selectedTierIndex;
  final int? customDurationDays;
  final int? browsedTierIndex;
  final List<SubscriptionTierRestaurantBrowseEntity> browseRestaurants;
  final PaginationEntity? browseRestaurantsPagination;
  final String? browsingProgramId;
  final String? browsingBundleId;
  final String? browsingTier;
  final SubscriptionReadinessEntity? readiness;
  final Failure? failure;
  final Failure? browseRestaurantsFailure;
  final Failure? browseRestaurantsLoadMoreFailure;
  final Failure? readinessFailure;


  bool get hasFridayUnavailableFailure =>
      failure?.code == 'subscription_flow.friday_unavailable';

  SubscriptionTierDesign get resolvedTierDesign {
    if (tiers.isEmpty) return SubscriptionTierDesign.current;
    final firstDesignId = tiers.first.theme?.designId;
    final allMatch = tiers.every((t) => t.theme?.designId == firstDesignId);
    if (!allMatch) {
      return SubscriptionTierDesign.current;
    }
    return resolveSubscriptionTierDesign(
      firstDesignId,
      supportsClassic: false,
      supportsAurora: false,
    );
  }


  SubscriptionDurationEntity? get selectedDuration {
    final index = selectedDurationIndex;
    if (index == null || index < 0 || index >= durations.length) return null;
    return durations[index];
  }

  SubscriptionTierEntity? get selectedTier {
    final index = selectedTierIndex;
    if (index == null || index < 0 || index >= tiers.length) return null;
    return tiers[index];
  }

  SubscriptionTierEntity? get browsedTier {
    final index = browsedTierIndex;
    if (index == null || index < 0 || index >= tiers.length) return null;
    return tiers[index];
  }

  bool get isBrowsingRestaurants => browsedTierIndex != null;

  bool get canToggleFriday =>
      selectedDuration?.canToggleFriday ??
      durations.any((duration) => duration.canToggleFriday);

  int? get selectedDurationDays {
    final duration = selectedDuration;
    if (duration == null) return null;
    return duration.isCustom ? customDurationDays : duration.durationDays;
  }

  bool get isSelectedDurationValid {
    final duration = selectedDuration;
    if (duration == null) return false;
    if (!duration.isCustom) return duration.durationDays != null;
    final days = customDurationDays;
    if (days == null) return false;
    final minDays = duration.minDays;
    final maxDays = duration.maxDays;
    if (minDays == null || maxDays == null) return false;
    if (days < minDays || days > maxDays) return false;
    return !presetDurationDays.contains(days);
  }

  Set<int> get presetDurationDays => durations
      .where((duration) => !duration.isCustom)
      .map((duration) => duration.durationDays)
      .whereType<int>()
      .where((days) => days > 0)
      .toSet();

  String fridayUnavailableMessage(String localeName) {
    final duration = selectedDuration;
    if (duration != null) {
      return duration.fridayAvailability.unavailableMessage(localeName);
    }

    if (canToggleFriday) return '';

    for (final duration in durations) {
      final message = duration.fridayAvailability.unavailableMessage(
        localeName,
      );
      if (message.isNotEmpty) return message;
    }

    return '';
  }

  SubscriptionPlanState copyWith({
    bool? isDurationsLoading,
    bool? isTiersLoading,
    bool? isBrowseRestaurantsLoading,
    bool? isBrowseRestaurantsLoadingMore,
    bool? isReadinessLoading,
    bool? isSuccess,
    bool? includeFriday,
    List<SubscriptionDurationEntity>? durations,
    List<SubscriptionTierEntity>? tiers,
    int? selectedDurationIndex,
    int? selectedTierIndex,
    int? customDurationDays,
    int? browsedTierIndex,
    List<SubscriptionTierRestaurantBrowseEntity>? browseRestaurants,
    PaginationEntity? browseRestaurantsPagination,
    String? browsingProgramId,
    String? browsingBundleId,
    String? browsingTier,
    SubscriptionReadinessEntity? readiness,
    Failure? failure,
    Failure? browseRestaurantsFailure,
    Failure? browseRestaurantsLoadMoreFailure,
    Failure? readinessFailure,
    bool clearSelectedDuration = false,
    bool clearSelectedTier = false,
    bool clearCustomDuration = false,
    bool clearBrowsedTier = false,
    bool clearBrowseRestaurants = false,
    bool clearBrowseRestaurantsPagination = false,
    bool clearBrowsingContext = false,
    bool clearReadiness = false,
    bool clearFailure = false,
    bool clearBrowseRestaurantsFailure = false,
    bool clearBrowseRestaurantsLoadMoreFailure = false,
    bool clearReadinessFailure = false,
  }) {
    return SubscriptionPlanState(
      isDurationsLoading: isDurationsLoading ?? this.isDurationsLoading,
      isTiersLoading: isTiersLoading ?? this.isTiersLoading,
      isBrowseRestaurantsLoading:
          isBrowseRestaurantsLoading ?? this.isBrowseRestaurantsLoading,
      isBrowseRestaurantsLoadingMore:
          isBrowseRestaurantsLoadingMore ?? this.isBrowseRestaurantsLoadingMore,
      isReadinessLoading: isReadinessLoading ?? this.isReadinessLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      includeFriday: includeFriday ?? this.includeFriday,
      durations: durations ?? this.durations,
      tiers: tiers ?? this.tiers,
      selectedDurationIndex: clearSelectedDuration
          ? null
          : selectedDurationIndex ?? this.selectedDurationIndex,
      selectedTierIndex: clearSelectedTier
          ? null
          : selectedTierIndex ?? this.selectedTierIndex,
      customDurationDays: clearCustomDuration
          ? null
          : customDurationDays ?? this.customDurationDays,
      browsedTierIndex: clearBrowsedTier
          ? null
          : browsedTierIndex ?? this.browsedTierIndex,
      browseRestaurants: clearBrowseRestaurants
          ? const []
          : browseRestaurants ?? this.browseRestaurants,
      browseRestaurantsPagination: clearBrowseRestaurantsPagination
          ? null
          : browseRestaurantsPagination ?? this.browseRestaurantsPagination,
      browsingProgramId: clearBrowsingContext
          ? null
          : browsingProgramId ?? this.browsingProgramId,
      browsingBundleId: clearBrowsingContext
          ? null
          : browsingBundleId ?? this.browsingBundleId,
      browsingTier: clearBrowsingContext
          ? null
          : browsingTier ?? this.browsingTier,
      readiness: clearReadiness ? null : readiness ?? this.readiness,
      failure: clearFailure ? null : failure ?? this.failure,
      browseRestaurantsFailure: clearBrowseRestaurantsFailure
          ? null
          : browseRestaurantsFailure ?? this.browseRestaurantsFailure,
      browseRestaurantsLoadMoreFailure: clearBrowseRestaurantsLoadMoreFailure
          ? null
          : browseRestaurantsLoadMoreFailure ?? this.browseRestaurantsLoadMoreFailure,
      readinessFailure: clearReadinessFailure
          ? null
          : readinessFailure ?? this.readinessFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionPlanState &&
        other.isDurationsLoading == isDurationsLoading &&
        other.isTiersLoading == isTiersLoading &&
        other.isBrowseRestaurantsLoading == isBrowseRestaurantsLoading &&
        other.isBrowseRestaurantsLoadingMore == isBrowseRestaurantsLoadingMore &&
        other.isReadinessLoading == isReadinessLoading &&
        other.isSuccess == isSuccess &&
        other.includeFriday == includeFriday &&
        other.selectedDurationIndex == selectedDurationIndex &&
        other.selectedTierIndex == selectedTierIndex &&
        other.customDurationDays == customDurationDays &&
        other.browsedTierIndex == browsedTierIndex &&
        other.browseRestaurantsPagination == browseRestaurantsPagination &&
        other.browsingProgramId == browsingProgramId &&
        other.browsingBundleId == browsingBundleId &&
        other.browsingTier == browsingTier &&
        other.readiness == readiness &&
        other.failure == failure &&
        other.browseRestaurantsFailure == browseRestaurantsFailure &&
        other.browseRestaurantsLoadMoreFailure == browseRestaurantsLoadMoreFailure &&
        other.readinessFailure == readinessFailure &&
        listEquals(other.durations, durations) &&
        listEquals(other.tiers, tiers) &&
        listEquals(other.browseRestaurants, browseRestaurants);
  }

  @override
  int get hashCode => Object.hashAll([
        isDurationsLoading,
        isTiersLoading,
        isBrowseRestaurantsLoading,
        isBrowseRestaurantsLoadingMore,
        isReadinessLoading,
        isSuccess,
        includeFriday,
        selectedDurationIndex,
        selectedTierIndex,
        customDurationDays,
        browsedTierIndex,
        browseRestaurantsPagination,
        browsingProgramId,
        browsingBundleId,
        browsingTier,
        readiness,
        failure,
        browseRestaurantsFailure,
        browseRestaurantsLoadMoreFailure,
        readinessFailure,
        Object.hashAll(durations),
        Object.hashAll(tiers),
        Object.hashAll(browseRestaurants),
      ]);
}
