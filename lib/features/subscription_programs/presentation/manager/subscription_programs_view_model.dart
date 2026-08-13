import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_state.dart';

@injectable
class SubscriptionProgramsViewModel extends Cubit<SubscriptionProgramsState> {
  SubscriptionProgramsViewModel(this._getSubscriptionProgramsUseCase)
    : super(const SubscriptionProgramsState());

  final GetSubscriptionProgramsUseCase _getSubscriptionProgramsUseCase;

  void doIntent(SubscriptionProgramsEvent event) {
    switch (event) {
      case GetSubscriptionProgramsEvent():
        _getSubscriptionPrograms();
    }
  }

  Future<void> _getSubscriptionPrograms() async {
    emit(state.copyWith(isLoading: true, isSuccess: false, clearFailure: true));

    final result = await _getSubscriptionProgramsUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            programs: result.data
                .where((program) => program.programId.isNotEmpty)
                .toList(),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }
}
