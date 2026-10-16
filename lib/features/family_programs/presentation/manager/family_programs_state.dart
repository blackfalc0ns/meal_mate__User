import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilyProgramsState {
  const FamilyProgramsState({
    this.isCurrentFlowLoading = false,
    this.currentFlow,
    this.isProgramsLoading = false,
    this.isLoadingMorePrograms = false,
    this.hasMorePrograms = true,
    this.programsPage = 1,
    this.isPlanSaving = false,
    this.programs = const [],
    this.selectedProgramIndex,
    this.selectedMemberIndex = 0,
    this.failure,
  });

  final bool isCurrentFlowLoading;
  final FamilyFlowCurrentEntity? currentFlow;

  final bool isProgramsLoading;
  final bool isLoadingMorePrograms;
  final bool hasMorePrograms;
  final int programsPage;
  final bool isPlanSaving;
  final List<SubscriptionProgramEntity> programs;
  final int? selectedProgramIndex;

  final int selectedMemberIndex;
  final Failure? failure;

  bool get isLoading =>
      isCurrentFlowLoading || isProgramsLoading || isPlanSaving;

  List<FamilyMemberEntity> get members => currentFlow?.members ?? const [];

  FamilyMemberEntity? get selectedMember {
    final list = members;
    if (list.isEmpty ||
        selectedMemberIndex < 0 ||
        selectedMemberIndex >= list.length) {
      return null;
    }
    return list[selectedMemberIndex];
  }

  SubscriptionProgramEntity? get selectedProgram {
    final index = selectedProgramIndex;
    if (index == null || index < 0 || index >= programs.length) return null;
    return programs[index];
  }

  FamilyProgramsState copyWith({
    bool? isCurrentFlowLoading,
    FamilyFlowCurrentEntity? currentFlow,
    bool? isProgramsLoading,
    bool? isLoadingMorePrograms,
    bool? hasMorePrograms,
    int? programsPage,
    bool? isPlanSaving,
    List<SubscriptionProgramEntity>? programs,
    int? selectedProgramIndex,
    bool clearSelectedProgram = false,
    int? selectedMemberIndex,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FamilyProgramsState(
      isCurrentFlowLoading: isCurrentFlowLoading ?? this.isCurrentFlowLoading,
      currentFlow: currentFlow ?? this.currentFlow,
      isProgramsLoading: isProgramsLoading ?? this.isProgramsLoading,
      isLoadingMorePrograms:
          isLoadingMorePrograms ?? this.isLoadingMorePrograms,
      hasMorePrograms: hasMorePrograms ?? this.hasMorePrograms,
      programsPage: programsPage ?? this.programsPage,
      isPlanSaving: isPlanSaving ?? this.isPlanSaving,
      programs: programs ?? this.programs,
      selectedProgramIndex: clearSelectedProgram
          ? null
          : (selectedProgramIndex ?? this.selectedProgramIndex),
      selectedMemberIndex: selectedMemberIndex ?? this.selectedMemberIndex,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
