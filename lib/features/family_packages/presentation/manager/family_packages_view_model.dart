import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_packages/domain/usecase/get_family_size_packages_usecase.dart';
import 'package:meal_meat_user/features/family_packages/presentation/manager/family_packages_event.dart';
import 'package:meal_meat_user/features/family_packages/presentation/manager/family_packages_state.dart';

@injectable
class FamilyPackagesViewModel extends Cubit<FamilyPackagesState> {
  FamilyPackagesViewModel(this._getFamilySizePackagesUseCase)
    : super(const FamilyPackagesState());

  final GetFamilySizePackagesUseCase _getFamilySizePackagesUseCase;

  void doIntent(FamilyPackagesEvent event) {
    switch (event) {
      case GetFamilySizePackagesEvent():
        unawaited(_getFamilySizePackages());
      case SelectFamilySizePackageEvent():
        emit(state.copyWith(selectedPackage: event.package));
    }
  }

  Future<void> _getFamilySizePackages() async {
    emit(state.copyWith(isPackagesLoading: true, clearFailure: true));
    final result = await _getFamilySizePackagesUseCase();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isPackagesLoading: false,
            packages: result.data,
            selectedPackage:
                state.selectedPackage ??
                (result.data.isNotEmpty ? result.data.first : null),
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isPackagesLoading: false, failure: result.failure));
    }
  }
}
