import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_shared/presentation/manager/family_subscription_flow_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilySubscriptionFlowViewModel
    extends Cubit<FamilySubscriptionFlowState> {
  FamilySubscriptionFlowViewModel(
    this._getFamilyFlowCurrentUseCase,
    this._snapshotStore,
  ) : super(FamilySubscriptionFlowState(flow: _snapshotStore.current));

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final FamilyFlowSnapshotStore _snapshotStore;

  Future<void> load({bool forceRefresh = false}) async {
    final cached = _snapshotStore.current;
    if (!forceRefresh && cached != null) {
      emit(state.copyWith(flow: cached, isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(data: final flow):
        _snapshotStore.update(flow);
        emit(state.copyWith(isLoading: false, flow: flow));
      case ApiErrorResult(failure: final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  void updateFlow(FamilyFlowCurrentEntity flow) {
    _snapshotStore.update(flow);
    emit(state.copyWith(flow: flow));
  }

  void updateMemberAddress(String memberId, CustomerAddressEntity address) {
    _snapshotStore.updateMemberDeliveryAddress(memberId, address);
    if (_snapshotStore.current != null) {
      emit(state.copyWith(flow: _snapshotStore.current));
    }
  }

  void updateMemberAllergies(
    String memberId,
    List<FamilyMemberAllergySelection> allergies,
  ) {
    _snapshotStore.updateMemberAllergies(memberId, allergies);
    if (_snapshotStore.current != null) {
      emit(state.copyWith(flow: _snapshotStore.current));
    }
  }
}
