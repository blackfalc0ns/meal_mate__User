import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';

class FamilyPackageDaysState {
  const FamilyPackageDaysState({
    this.isCurrentFlowLoading = false,
    this.currentFlow,
    this.isProgramsLoading = false,
    this.programs = const [],
    this.selectedProgramIndex,
    this.isBundlesLoading = false,
    this.bundles = const [],
    this.selectedBundleIndex,
    this.isDurationsLoading = false,
    this.durations = const [],
    this.selectedDurationIndex,
    this.customDurationDays,
    this.includeFriday = false,
    this.isTiersLoading = false,
    this.tiers = const [],
    this.selectedTierIndex,
    this.isBrowseRestaurantsLoading = false,
    this.browseRestaurants = const [],
    this.browsedTierIndex,
    this.isRestaurantsView = false,
    this.browseRestaurantsFailure,
    this.selectedMemberIndex = 0,
    this.isPlanSaving = false,
    this.failure,
  });

  final bool isCurrentFlowLoading;
  final FamilyFlowCurrentEntity? currentFlow;

  final bool isProgramsLoading;
  final List<SubscriptionProgramEntity> programs;
  final int? selectedProgramIndex;

  final bool isBundlesLoading;
  final List<SubscriptionBundleEntity> bundles;
  final int? selectedBundleIndex;

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
  final bool isPlanSaving;
  final Failure? failure;

  bool get isLoading =>
      isCurrentFlowLoading ||
      isProgramsLoading ||
      isBundlesLoading ||
      isDurationsLoading ||
      isTiersLoading ||
      isPlanSaving;

  List<FamilyMemberEntity> get members => currentFlow?.members ?? const [];

  List<FamilyMemberEntity> get plannedMembers =>
      members.where((member) => member.hasProgram).toList();

  FamilyMemberEntity? get selectedMember {
    final list = members;
    if (list.isEmpty ||
        selectedMemberIndex < 0 ||
        selectedMemberIndex >= list.length) {
      return null;
    }
    return list[selectedMemberIndex];
  }

  bool get isConvertedFamilyDraft =>
      currentFlow?.managerPrepaid ??
      FamilyConversionDraftSession.isConvertedFamilyDraft;

  bool get isSelectedManagerPlanLocked =>
      isConvertedFamilyDraft && selectedMember?.isManager == true;

  SubscriptionProgramEntity? get selectedProgram {
    final index = selectedProgramIndex;
    if (index == null || index < 0 || index >= programs.length) return null;
    return programs[index];
  }

  SubscriptionBundleEntity? get selectedBundle {
    final index = selectedBundleIndex;
    if (index == null || index < 0 || index >= bundles.length) return null;
    return bundles[index];
  }

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

  FamilyPackageDaysState copyWith({
    bool? isCurrentFlowLoading,
    FamilyFlowCurrentEntity? currentFlow,
    bool? isProgramsLoading,
    List<SubscriptionProgramEntity>? programs,
    int? selectedProgramIndex,
    bool clearSelectedProgram = false,
    bool? isBundlesLoading,
    List<SubscriptionBundleEntity>? bundles,
    int? selectedBundleIndex,
    bool clearSelectedBundle = false,
    bool? isDurationsLoading,
    List<SubscriptionDurationEntity>? durations,
    int? selectedDurationIndex,
    bool clearSelectedDuration = false,
    int? customDurationDays,
    bool clearCustomDuration = false,
    bool? includeFriday,
    bool? isTiersLoading,
    List<SubscriptionTierEntity>? tiers,
    int? selectedTierIndex,
    bool clearSelectedTier = false,
    bool? isBrowseRestaurantsLoading,
    List<SubscriptionTierRestaurantBrowseEntity>? browseRestaurants,
    int? browsedTierIndex,
    bool? isRestaurantsView,
    Failure? browseRestaurantsFailure,
    int? selectedMemberIndex,
    bool? isPlanSaving,
    Failure? failure,
    bool clearFailure = false,
    bool clearBrowseRestaurants = false,
    bool clearBrowseRestaurantsFailure = false,
  }) {
    return FamilyPackageDaysState(
      isCurrentFlowLoading: isCurrentFlowLoading ?? this.isCurrentFlowLoading,
      currentFlow: currentFlow ?? this.currentFlow,
      isProgramsLoading: isProgramsLoading ?? this.isProgramsLoading,
      programs: programs ?? this.programs,
      selectedProgramIndex: clearSelectedProgram
          ? null
          : (selectedProgramIndex ?? this.selectedProgramIndex),
      isBundlesLoading: isBundlesLoading ?? this.isBundlesLoading,
      bundles: bundles ?? this.bundles,
      selectedBundleIndex: clearSelectedBundle
          ? null
          : (selectedBundleIndex ?? this.selectedBundleIndex),
      isDurationsLoading: isDurationsLoading ?? this.isDurationsLoading,
      durations: durations ?? this.durations,
      selectedDurationIndex: clearSelectedDuration
          ? null
          : (selectedDurationIndex ?? this.selectedDurationIndex),
      customDurationDays: clearCustomDuration
          ? null
          : (customDurationDays ?? this.customDurationDays),
      includeFriday: includeFriday ?? this.includeFriday,
      isTiersLoading: isTiersLoading ?? this.isTiersLoading,
      tiers: tiers ?? this.tiers,
      selectedTierIndex: clearSelectedTier
          ? null
          : (selectedTierIndex ?? this.selectedTierIndex),
      isBrowseRestaurantsLoading:
          isBrowseRestaurantsLoading ?? this.isBrowseRestaurantsLoading,
      browseRestaurants: clearBrowseRestaurants
          ? const []
          : (browseRestaurants ?? this.browseRestaurants),
      browsedTierIndex: browsedTierIndex ?? this.browsedTierIndex,
      isRestaurantsView: isRestaurantsView ?? this.isRestaurantsView,
      browseRestaurantsFailure: clearBrowseRestaurantsFailure
          ? null
          : (browseRestaurantsFailure ?? this.browseRestaurantsFailure),
      selectedMemberIndex: selectedMemberIndex ?? this.selectedMemberIndex,
      isPlanSaving: isPlanSaving ?? this.isPlanSaving,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
