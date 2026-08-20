import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_restaurant_browse_entity.dart';

class FamilyPlanState {
  const FamilyPlanState({
    this.isProgramsLoading = false,
    this.programs = const [],
    this.selectedProgramIndex = 0,
    this.isBundlesLoading = false,
    this.bundles = const [],
    this.selectedBundleIndex = 0,
    this.isDurationsLoading = false,
    this.durations = const [],
    this.selectedDurationIndex = 2,
    this.customDurationDays,
    this.includeFriday = false,
    this.isTiersLoading = false,
    this.tiers = const [],
    this.selectedTierIndex = 1,
    this.isBrowseRestaurantsLoading = false,
    this.browseRestaurants = const [],
    this.browsedTierIndex,
    this.isRestaurantsView = false,
    this.browseRestaurantsFailure,
    this.selectedMemberIndex = 0,
    this.failure,
  });

  final bool isProgramsLoading;
  final List<SubscriptionProgramEntity> programs;
  final int selectedProgramIndex;

  final bool isBundlesLoading;
  final List<SubscriptionBundleEntity> bundles;
  final int selectedBundleIndex;

  final bool isDurationsLoading;
  final List<SubscriptionDurationEntity> durations;
  final int? selectedDurationIndex;
  final int? customDurationDays;
  final bool includeFriday;

  final bool isTiersLoading;
  final List<SubscriptionTierEntity> tiers;
  final int? selectedTierIndex;

  final bool isBrowseRestaurantsLoading;
  final List<SubscriptionTierRestaurantBrowseEntity> browseRestaurants;
  final int? browsedTierIndex;
  final bool isRestaurantsView;
  final Failure? browseRestaurantsFailure;

  final int selectedMemberIndex;
  final Failure? failure;

  bool get isLoading =>
      isProgramsLoading ||
      isBundlesLoading ||
      isDurationsLoading ||
      isTiersLoading;

  SubscriptionProgramEntity? get selectedProgram =>
      programs.isNotEmpty && selectedProgramIndex < programs.length
          ? programs[selectedProgramIndex]
          : null;

  SubscriptionBundleEntity? get selectedBundle =>
      bundles.isNotEmpty && selectedBundleIndex < bundles.length
          ? bundles[selectedBundleIndex]
          : null;

  SubscriptionDurationEntity? get selectedDuration {
    final index = selectedDurationIndex;
    if (index == null || index < 0 || index >= durations.length) return null;
    return durations[index];
  }

  int? get selectedDurationDays {
    final duration = selectedDuration;
    if (duration == null) return customDurationDays;
    return duration.isCustom ? customDurationDays : duration.durationDays;
  }

  SubscriptionTierEntity? get selectedTier {
    final index = selectedTierIndex;
    if (index == null || index < 0 || index >= tiers.length) return null;
    return tiers[index];
  }

  FamilyPlanState copyWith({
    bool? isProgramsLoading,
    List<SubscriptionProgramEntity>? programs,
    int? selectedProgramIndex,
    bool? isBundlesLoading,
    List<SubscriptionBundleEntity>? bundles,
    int? selectedBundleIndex,
    bool? isDurationsLoading,
    List<SubscriptionDurationEntity>? durations,
    int? selectedDurationIndex,
    int? customDurationDays,
    bool? includeFriday,
    bool? isTiersLoading,
    List<SubscriptionTierEntity>? tiers,
    int? selectedTierIndex,
    bool? isBrowseRestaurantsLoading,
    List<SubscriptionTierRestaurantBrowseEntity>? browseRestaurants,
    int? browsedTierIndex,
    bool? isRestaurantsView,
    Failure? browseRestaurantsFailure,
    int? selectedMemberIndex,
    Failure? failure,
    bool clearFailure = false,
    bool clearBrowseRestaurants = false,
    bool clearBrowseRestaurantsFailure = false,
  }) {
    return FamilyPlanState(
      isProgramsLoading: isProgramsLoading ?? this.isProgramsLoading,
      programs: programs ?? this.programs,
      selectedProgramIndex:
          selectedProgramIndex ?? this.selectedProgramIndex,
      isBundlesLoading: isBundlesLoading ?? this.isBundlesLoading,
      bundles: bundles ?? this.bundles,
      selectedBundleIndex: selectedBundleIndex ?? this.selectedBundleIndex,
      isDurationsLoading: isDurationsLoading ?? this.isDurationsLoading,
      durations: durations ?? this.durations,
      selectedDurationIndex:
          selectedDurationIndex ?? this.selectedDurationIndex,
      customDurationDays: customDurationDays ?? this.customDurationDays,
      includeFriday: includeFriday ?? this.includeFriday,
      isTiersLoading: isTiersLoading ?? this.isTiersLoading,
      tiers: tiers ?? this.tiers,
      selectedTierIndex: selectedTierIndex ?? this.selectedTierIndex,
      isBrowseRestaurantsLoading:
          isBrowseRestaurantsLoading ?? this.isBrowseRestaurantsLoading,
      browseRestaurants:
          clearBrowseRestaurants
              ? const []
              : (browseRestaurants ?? this.browseRestaurants),
      browsedTierIndex: browsedTierIndex ?? this.browsedTierIndex,
      isRestaurantsView: isRestaurantsView ?? this.isRestaurantsView,
      browseRestaurantsFailure:
          clearBrowseRestaurantsFailure
              ? null
              : (browseRestaurantsFailure ?? this.browseRestaurantsFailure),
      selectedMemberIndex:
          selectedMemberIndex ?? this.selectedMemberIndex,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
