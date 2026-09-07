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
            members: missingAddressMembers,
            completed: missingAddressMembers.isEmpty,
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

  void addressSaved() {
    if (state.members.isEmpty) return;
    final isLast = state.currentIndex == state.members.length - 1;
    emit(
      state.copyWith(
        currentIndex: isLast ? state.currentIndex : state.currentIndex + 1,
        completed: isLast,
        clearError: true,
      ),
    );
  }
}
