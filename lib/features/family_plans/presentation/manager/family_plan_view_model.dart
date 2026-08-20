import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';

@injectable
class FamilyPlanViewModel extends Cubit<FamilyPlanState> {
  FamilyPlanViewModel(
    this._getSubscriptionProgramsUseCase,
    this._getSubscriptionProgramBundlesUseCase,
    this._getSubscriptionDurationsUseCase,
  ) : super(const FamilyPlanState());

  final GetSubscriptionProgramsUseCase _getSubscriptionProgramsUseCase;
  final GetSubscriptionProgramBundlesUseCase
  _getSubscriptionProgramBundlesUseCase;
  final GetSubscriptionDurationsUseCase _getSubscriptionDurationsUseCase;

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
        emit(state.copyWith(selectedDurationIndex: event.durationIndex));
      case UpdateFamilyCustomDurationEvent():
        emit(state.copyWith(customDurationDays: event.durationDays));
      case ToggleFamilyFridayEvent():
        _toggleFriday(event.includeFriday);
      case SelectFamilyTierEvent():
        emit(state.copyWith(selectedTierIndex: event.tierIndex));
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
      case ApiErrorResult():
        emit(
          state.copyWith(
            isDurationsLoading: false,
            failure: result.failure,
          ),
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
}
