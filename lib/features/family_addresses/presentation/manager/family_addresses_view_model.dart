import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_event.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilyAddressesViewModel extends Cubit<FamilyAddressesState> {
  FamilyAddressesViewModel(
    this._getFlow, [
    FamilyFlowSnapshotStore? snapshotStore,
  ]) : _snapshotStore =
           snapshotStore ??
           (getIt.isRegistered<FamilyFlowSnapshotStore>()
               ? getIt<FamilyFlowSnapshotStore>()
               : FamilyFlowSnapshotStore()),
       super(const FamilyAddressesState());

  final GetFamilyFlowCurrentUseCase _getFlow;
  final FamilyFlowSnapshotStore _snapshotStore;
  int _activeLoadId = 0;

  void doIntent(FamilyAddressesEvent event) {
    switch (event) {
      case LoadFamilyAddressesEvent():
        unawaited(load(memberId: event.memberId));
      case SelectFamilyAddressMemberEvent():
        selectMember(event.index);
      case SaveFamilyMemberAddressEvent():
        addressSaved(
          memberId: event.memberId,
          savedAddress: event.savedAddress,
        );
      case ProceedToNextAddressStepEvent():
        proceedToNextStep();
      case ToggleApplyManagerAddressEvent():
        toggleApplyManagerAddress();
    }
  }

  Future<void> load({String? memberId}) async {
    final requestId = ++_activeLoadId;
    emit(state.copyWith(isLoading: true, clearError: true, clearFailure: true));
    final result = await _getFlow();
    if (isClosed || requestId != _activeLoadId) return;
    switch (result) {
      case ApiSuccessResult():
        final members = memberId == null
            ? result.data.members
            : result.data.members
                  .where((member) => member.memberId == memberId)
                  .toList();
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

    final targetMember = state.members.cast<FamilyMemberEntity?>().firstWhere(
      (m) => m?.memberId == targetMemberId,
      orElse: () => null,
    );
    if (targetMember == null) return;

    if (savedAddress != null &&
        targetMember.deliveryAddressId == savedAddress.addressId &&
        targetMember.deliveryAddress == savedAddress &&
        state.completedMemberIds.contains(targetMemberId)) {
      return;
    }

    if (savedAddress != null) {
      _snapshotStore.updateMemberDeliveryAddress(targetMemberId, savedAddress);
    }

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

  void toggleApplyManagerAddress() {
    if (state.members.isEmpty) return;
    final manager = state.manager;
    final managerAddress = manager?.deliveryAddress;
    final managerAddressId =
        manager?.deliveryAddressId ?? managerAddress?.addressId;

    if (state.isManagerAddressAppliedToAll) {
      final updatedMembers = state.members.map((m) {
        if (m.isManager) return m;
        _snapshotStore.clearMemberDeliveryAddress(m.memberId);
        return m.copyWith(clearDeliveryAddress: true);
      }).toList();

      final completedMemberIds = state.members
          .where(
            (m) =>
                m.isManager &&
                (m.deliveryAddress != null ||
                    (m.deliveryAddressId?.isNotEmpty ?? false)),
          )
          .map((m) => m.memberId)
          .toSet();

      emit(
        state.copyWith(
          members: updatedMembers,
          completedMemberIds: completedMemberIds,
          completed: false,
          addressSaveRevision: state.addressSaveRevision + 1,
          clearError: true,
        ),
      );
    } else {
      if (managerAddress == null &&
          (managerAddressId == null || managerAddressId.isEmpty)) {
        return;
      }
      final addressId = managerAddressId ?? managerAddress?.addressId ?? '';

      final updatedMembers = state.members.map((m) {
        if (managerAddress != null) {
          _snapshotStore.updateMemberDeliveryAddress(
            m.memberId,
            managerAddress,
          );
        }
        return m.copyWith(
          deliveryAddressId: addressId,
          deliveryAddress: managerAddress,
        );
      }).toList();

      final allMemberIds = updatedMembers.map((m) => m.memberId).toSet();
      emit(
        state.copyWith(
          members: updatedMembers,
          completedMemberIds: allMemberIds,
          completed: true,
          addressSaveRevision: state.addressSaveRevision + 1,
          clearError: true,
        ),
      );
    }
  }

  void proceedToNextStep() {
    if (state.members.isEmpty) return;
    final allCompleted =
        state.completed ||
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
