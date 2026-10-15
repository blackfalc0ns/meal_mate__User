import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilyAddressesViewModel extends Cubit<FamilyAddressesState> {
  FamilyAddressesViewModel(this._getFlow) : super(const FamilyAddressesState());

  final GetFamilyFlowCurrentUseCase _getFlow;
  int _activeLoadId = 0;

  Future<void> load({String? memberId}) async {
    final requestId = ++_activeLoadId;
    emit(state.copyWith(isLoading: true, clearError: true, clearFailure: true));
    final result = await _getFlow();
    if (isClosed || requestId != _activeLoadId) return;
    switch (result) {
      case ApiSuccessResult():
        final members = result.data.members;
        final targetIndex = memberId != null
            ? members.indexWhere((m) => m.memberId == memberId)
            : -1;
        final completedMemberIds = members
            .where((member) => member.deliveryAddressId?.isNotEmpty ?? false)
            .map((member) => member.memberId)
            .toSet();
        final firstPendingIndex = members.indexWhere(
          (member) => !completedMemberIds.contains(member.memberId),
        );
        final initialIndex = targetIndex >= 0
            ? targetIndex
            : (firstPendingIndex < 0 ? 0 : firstPendingIndex);
        emit(
          state.copyWith(
            isLoading: false,
            clearFailure: true,
            familyName: result.data.name,
            members: members,
            currentIndex: initialIndex,
            completedMemberIds: completedMemberIds,
            completed: members.isEmpty,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            failure: result.failure,
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

  void addressSaved({String? memberId, CustomerAddressEntity? savedAddress}) {
    if (state.members.isEmpty) return;
    final targetMemberId = memberId ?? state.currentMember?.memberId;
    if (targetMemberId == null) return;

    final updatedMembers = state.members.map((m) {
      if (m.memberId == targetMemberId) {
        return m.copyWith(
          deliveryAddressId: savedAddress?.addressId ?? m.deliveryAddressId,
          deliveryAddress: savedAddress ?? m.deliveryAddress,
        );
      }
      return m;
    }).toList();

    final completedMemberIds = {...state.completedMemberIds, targetMemberId};
    final isComplete = completedMemberIds.length == updatedMembers.length;
    final nextIndex = isComplete
        ? state.currentIndex
        : updatedMembers.indexWhere(
            (member) => !completedMemberIds.contains(member.memberId),
          );
    emit(
      state.copyWith(
        members: updatedMembers,
        currentIndex: nextIndex < 0 ? state.currentIndex : nextIndex,
        completedMemberIds: completedMemberIds,
        completed: isComplete,
        addressSaveRevision: state.addressSaveRevision + 1,
        clearError: true,
      ),
    );
  }

  void proceedToNextStep() {
    if (state.members.isEmpty) return;
    final allCompleted =
        state.completedMemberIds.length == state.members.length;
    if (!allCompleted) return;
    emit(
      state.copyWith(
        completed: true,
        addressSaveRevision: state.addressSaveRevision + 1,
      ),
    );
  }
}
