import 'package:flutter/foundation.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';

export 'subscription_plan_state_mapper.dart';

class SubscriptionPlanState {
  const SubscriptionPlanState({
    this.isDurationsLoading = false,
    this.isTiersLoading = false,
    this.isBrowseRestaurantsLoading = false,
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
    this.readiness,
    this.failure,
    this.browseRestaurantsFailure,
    this.readinessFailure,
  });

  final bool isDurationsLoading;
  final bool isTiersLoading;
  final bool isBrowseRestaurantsLoading;
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
  final SubscriptionReadinessEntity? readiness;
  final Failure? failure;
  final Failure? browseRestaurantsFailure;
  final Failure? readinessFailure;

  bool get hasFridayUnavailableFailure =>
      failure?.code == 'subscription_flow.friday_unavailable';

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
    SubscriptionReadinessEntity? readiness,
    Failure? failure,
    Failure? browseRestaurantsFailure,
    Failure? readinessFailure,
    bool clearSelectedDuration = false,
    bool clearSelectedTier = false,
    bool clearCustomDuration = false,
    bool clearBrowsedTier = false,
    bool clearBrowseRestaurants = false,
    bool clearReadiness = false,
    bool clearFailure = false,
    bool clearBrowseRestaurantsFailure = false,
    bool clearReadinessFailure = false,
  }) {
    return SubscriptionPlanState(
      isDurationsLoading: isDurationsLoading ?? this.isDurationsLoading,
      isTiersLoading: isTiersLoading ?? this.isTiersLoading,
      isBrowseRestaurantsLoading:
          isBrowseRestaurantsLoading ?? this.isBrowseRestaurantsLoading,
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
      readiness: clearReadiness ? null : readiness ?? this.readiness,
      failure: clearFailure ? null : failure ?? this.failure,
      browseRestaurantsFailure: clearBrowseRestaurantsFailure
          ? null
          : browseRestaurantsFailure ?? this.browseRestaurantsFailure,
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
        other.isReadinessLoading == isReadinessLoading &&
        other.isSuccess == isSuccess &&
        other.includeFriday == includeFriday &&
        other.selectedDurationIndex == selectedDurationIndex &&
        other.selectedTierIndex == selectedTierIndex &&
        other.customDurationDays == customDurationDays &&
        other.browsedTierIndex == browsedTierIndex &&
        other.readiness == readiness &&
        other.failure == failure &&
        other.browseRestaurantsFailure == browseRestaurantsFailure &&
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
        isReadinessLoading,
        isSuccess,
        includeFriday,
        selectedDurationIndex,
        selectedTierIndex,
        customDurationDays,
        browsedTierIndex,
        readiness,
        failure,
        browseRestaurantsFailure,
        readinessFailure,
        Object.hashAll(durations),
        Object.hashAll(tiers),
        Object.hashAll(browseRestaurants),
      ]);
}
