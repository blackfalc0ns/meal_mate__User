import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilyAddressesViewModel extends Cubit<FamilyAddressesState> {
  FamilyAddressesViewModel(this._getFlow) : super(const FamilyAddressesState());

  final GetFamilyFlowCurrentUseCase _getFlow;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getFlow();
    switch (result) {
      case ApiSuccessResult():
        final missingAddressMembers = result.data.members
            .where(
              (member) =>
                  member.deliveryAddressId == null ||
                  member.deliveryAddressId!.isEmpty,
            )
            .toList();
        emit(
          state.copyWith(
            isLoading: false,
            familyName: result.data.name,
            members: missingAddressMembers.isEmpty
                ? result.data.members
                : missingAddressMembers,
            completed: result.data.members.isEmpty,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  void selectMember(int index) {
    if (index < 0 ||
        index >= state.members.length ||
        index == state.currentIndex) {
      return;
    }
    emit(state.copyWith(currentIndex: index, clearError: true));
  }

  void addressSaved() {
    if (state.members.isEmpty) return;
    final completedMemberIds = {
      ...state.completedMemberIds,
      state.currentMember!.memberId,
    };
    final isComplete = completedMemberIds.length == state.members.length;
    final nextIndex = isComplete
        ? state.currentIndex
        : state.members.indexWhere(
            (member) => !completedMemberIds.contains(member.memberId),
          );
    emit(
      state.copyWith(
        currentIndex: nextIndex,
        completedMemberIds: completedMemberIds,
        completed: isComplete,
        clearError: true,
      ),
    );
  }
}
