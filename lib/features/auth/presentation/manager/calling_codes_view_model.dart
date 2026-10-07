import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/get_calling_codes_usecase.dart';
import 'calling_codes_event.dart';
import 'calling_codes_state.dart';

@injectable
class CallingCodesViewModel extends Cubit<CallingCodesState> {
  CallingCodesViewModel(this._getCallingCodesUseCase)
      : super(const CallingCodesState());

  final GetCallingCodesUseCase _getCallingCodesUseCase;
  bool _inFlight = false;

  void doIntent(CallingCodesEvent event) {
    switch (event) {
      case LoadCallingCodesEvent():
        unawaited(_loadCallingCodes());
      case SelectCallingCodeEvent(:final selected):
        _selectCallingCode(selected);
    }
  }

  Future<void> _loadCallingCodes() async {
    if (_inFlight) return;
    _inFlight = true;
    emit(state.copyWith(isLoading: true, failure: () => null));

    final result = await _getCallingCodesUseCase();
    _inFlight = false;

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        CallingCodeEntity? nextSelected;
        if (state.selected != null) {
          final existing = data.where(
            (c) => c.countryCode == state.selected!.countryCode,
          );
          if (existing.isNotEmpty) {
            nextSelected = existing.first;
          }
        }
        if (nextSelected == null && data.isNotEmpty) {
          final kuwait = data.where((c) => c.countryCode == 'KW');
          nextSelected = kuwait.isNotEmpty ? kuwait.first : data.first;
        }

        emit(
          state.copyWith(
            items: data,
            selected: () => nextSelected,
            isLoading: false,
            failure: () => null,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(
            isLoading: false,
            failure: () => failure,
          ),
        );
    }
  }

  void _selectCallingCode(CallingCodeEntity selected) {
    if (state.selected?.countryCode == selected.countryCode &&
        state.selected?.dialCode == selected.dialCode) {
      return;
    }
    emit(state.copyWith(selected: () => selected));
  }
}
