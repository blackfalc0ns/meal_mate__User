import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_state.dart';

@injectable
class SubscriptionProgramsViewModel extends Cubit<SubscriptionProgramsState> {
  SubscriptionProgramsViewModel(
    this._getSubscriptionProgramsUseCase,
    this._getSubscriptionProgramBundlesUseCase,
  ) : super(const SubscriptionProgramsState());

  final GetSubscriptionProgramsUseCase _getSubscriptionProgramsUseCase;
  final GetSubscriptionProgramBundlesUseCase
  _getSubscriptionProgramBundlesUseCase;

  void doIntent(SubscriptionProgramsEvent event) {
    switch (event) {
      case GetSubscriptionProgramsEvent():
        _getSubscriptionPrograms();
      case GetSubscriptionProgramBundlesEvent():
        _getSubscriptionProgramBundles(event.programId);
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

  Future<void> _getSubscriptionProgramBundles(String programId) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, clearFailure: true));

    final result = await _getSubscriptionProgramBundlesUseCase(programId);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            bundles: result.data
                .where((bundle) => bundle.bundleId.isNotEmpty)
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
