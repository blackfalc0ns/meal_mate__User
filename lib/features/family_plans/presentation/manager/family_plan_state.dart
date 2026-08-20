import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/entities/subscription_program_entity.dart';

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
    this.selectedTierIndex = 1,
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

  final int selectedTierIndex;
  final int selectedMemberIndex;
  final Failure? failure;

  bool get isLoading =>
      isProgramsLoading || isBundlesLoading || isDurationsLoading;

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
    int? selectedTierIndex,
    int? selectedMemberIndex,
    Failure? failure,
    bool clearFailure = false,
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
      selectedTierIndex: selectedTierIndex ?? this.selectedTierIndex,
      selectedMemberIndex:
          selectedMemberIndex ?? this.selectedMemberIndex,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
