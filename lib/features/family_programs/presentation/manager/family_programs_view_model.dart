import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/save_family_member_plan_usecase.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_programs_usecase.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_event.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilyProgramsViewModel extends Cubit<FamilyPlanState> {
  FamilyProgramsViewModel(
    this._getFamilyFlowCurrentUseCase,
    this._getFamilyProgramsUseCase,
    this._saveFamilyMemberPlanUseCase, [
    FamilyFlowSnapshotStore? snapshotStore,
  ])  : _snapshotStore = snapshotStore ??
            (getIt.isRegistered<FamilyFlowSnapshotStore>()
                ? getIt<FamilyFlowSnapshotStore>()
                : FamilyFlowSnapshotStore()),
        super(const FamilyPlanState());

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final GetFamilyProgramsUseCase _getFamilyProgramsUseCase;
  final SaveFamilyMemberPlanUseCase _saveFamilyMemberPlanUseCase;
  final FamilyFlowSnapshotStore _snapshotStore;
  final Map<String, String> _pendingProgramIds = {};

  void doIntent(FamilyPlanEvent event) {
    switch (event) {
      case GetFamilySubscriptionCurrentEvent():
        _getFamilySubscriptionCurrent();
      case GetFamilyProgramsEvent():
        _getPrograms();
      case SelectFamilyProgramEvent():
        _selectProgram(event.programIndex);
      case SelectFamilyMemberEvent():
        _selectMember(event.memberIndex);
      case SaveFamilyProgramsEvent():
        _savePendingPrograms();
    }
  }

  Future<void> _getFamilySubscriptionCurrent() async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    switch (result) {
      case ApiSuccessResult():
        final flow = result.data;
        final selectedIndex =
            (state.selectedMemberIndex >= 0 &&
                state.selectedMemberIndex < flow.members.length)
            ? state.selectedMemberIndex
            : 0;
        emit(
          state.copyWith(
            isCurrentFlowLoading: false,
            currentFlow: flow,
            selectedMemberIndex: selectedIndex,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _getPrograms() async {
    emit(state.copyWith(isProgramsLoading: true, clearFailure: true));
    final result = await _getFamilyProgramsUseCase();
    switch (result) {
      case ApiSuccessResult():
        final programs = result.data
            .where((p) => p.programId.isNotEmpty)
            .toList();
        int? progIdx;
        final selectedMember = state.selectedMember;
        if (selectedMember?.programId != null &&
            selectedMember!.programId!.isNotEmpty) {
          final found = programs.indexWhere(
            (p) => p.programId == selectedMember.programId,
          );
          if (found != -1) progIdx = found;
        }
        emit(
          state.copyWith(
            isProgramsLoading: false,
            programs: programs,
            selectedProgramIndex: progIdx,
            clearSelectedProgram: progIdx == null,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isProgramsLoading: false, failure: result.failure));
    }
  }

  void _selectProgram(int index) {
    final program = state.programs.length > index
        ? state.programs[index]
        : null;
    if (program == null) return;

    final updatedFlow = _updateLocalMemberInCurrentFlow(
      programId: program.programId,
    );
    emit(
      state.copyWith(
        selectedProgramIndex: index,
        currentFlow: updatedFlow ?? state.currentFlow,
      ),
    );

    final member = state.selectedMember;
    if (member != null) {
      _pendingProgramIds[member.memberId] = program.programId;
      _snapshotStore.updateMemberProgram(member.memberId, program.programId);
    }
  }

  void _selectMember(int index) {
    if (index < 0 || index >= state.members.length) return;
    final member = state.members[index];
    int? progIdx;
    if (member.programId != null &&
        member.programId!.isNotEmpty &&
        state.programs.isNotEmpty) {
      final found = state.programs.indexWhere(
        (p) => p.programId == member.programId,
      );
      if (found != -1) progIdx = found;
    }
    emit(
      state.copyWith(
        selectedMemberIndex: index,
        selectedProgramIndex: progIdx,
        clearSelectedProgram: progIdx == null,
      ),
    );
  }

  FamilyFlowCurrentEntity? _updateLocalMemberInCurrentFlow({
    String? programId,
  }) {
    final flow = state.currentFlow;
    if (flow == null || state.members.isEmpty) return null;
    final idx = state.selectedMemberIndex;
    if (idx < 0 || idx >= flow.members.length) return null;
    final member = flow.members[idx];
    final updatedMembers = List<FamilyMemberEntity>.from(flow.members);
    updatedMembers[idx] = member.copyWith(
      programId: programId ?? member.programId,
    );
    return flow.copyWith(members: updatedMembers);
  }

  Future<void> _savePendingPrograms() async {
    if (state.isPlanSaving || _pendingProgramIds.isEmpty) return;
    emit(state.copyWith(isPlanSaving: true, clearFailure: true));
    final changes = Map<String, String>.of(_pendingProgramIds);
    for (final change in changes.entries) {
      final result = await _saveFamilyMemberPlanUseCase(
        memberId: change.key,
        programId: change.value,
      );
      if (isClosed) return;
      switch (result) {
        case ApiSuccessResult():
          if (_pendingProgramIds[change.key] == change.value) {
            _pendingProgramIds.remove(change.key);
          }
          final flow = result.data;
          _snapshotStore.updateMemberProgram(change.key, change.value);
          emit(
            state.copyWith(
              currentFlow: flow.copyWith(
                members: flow.members
                    .map(
                      (member) => member.copyWith(
                        programId: member.memberId == change.key
                            ? change.value
                            : (_pendingProgramIds[member.memberId] ??
                                member.programId),
                      ),
                    )
                    .toList(),
              ),
              clearFailure: true,
            ),
          );
        case ApiErrorResult():
          emit(state.copyWith(isPlanSaving: false, failure: result.failure));
          return;
      }
    }
    emit(state.copyWith(isPlanSaving: false));
  }
}
