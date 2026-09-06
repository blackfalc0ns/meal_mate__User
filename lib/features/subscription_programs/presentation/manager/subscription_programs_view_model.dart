import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/check_subscription_prerequisites_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_state.dart';

@injectable
class SubscriptionProgramsViewModel extends Cubit<SubscriptionProgramsState> {
  SubscriptionProgramsViewModel(
    this._getSubscriptionProgramsUseCase,
    this._getSubscriptionProgramBundlesUseCase,
    this._checkSubscriptionPrerequisitesUseCase,
  ) : super(const SubscriptionProgramsState());

  final GetSubscriptionProgramsUseCase _getSubscriptionProgramsUseCase;
  final GetSubscriptionProgramBundlesUseCase
  _getSubscriptionProgramBundlesUseCase;
  final CheckSubscriptionPrerequisitesUseCase
  _checkSubscriptionPrerequisitesUseCase;

  void doIntent(SubscriptionProgramsEvent event) {
    switch (event) {
      case GetSubscriptionProgramsEvent():
        _getSubscriptionPrograms();
      case GetSubscriptionProgramBundlesEvent():
        _getSubscriptionProgramBundles(event.programId);
      case CheckSubscriptionPrerequisitesEvent():
        _checkSubscriptionPrerequisites();
    }
  }

  Future<void> _checkSubscriptionPrerequisites() async {
    emit(
      state.copyWith(
        isPrerequisitesLoading: true,
        prerequisitesCompleted: false,
        clearPrerequisitesFailure: true,
      ),
    );

    final result = await _checkSubscriptionPrerequisitesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isPrerequisitesLoading: false,
            prerequisitesCompleted: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isPrerequisitesLoading: false,
            prerequisitesCompleted: false,
            prerequisitesFailure: result.failure,
          ),
        );
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
