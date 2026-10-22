import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import '../../domain/entities/eligible_start_dates_entity.dart';
import '../../domain/usecase/get_eligible_start_dates_usecase.dart';
import 'start_dates_state.dart';
import 'start_dates_event.dart';

@injectable
class StartDatesViewModel extends Cubit<StartDatesState> {
  StartDatesViewModel(this._getDates) : super(const StartDatesState());
  final GetEligibleStartDatesUseCase _getDates;
  int _generation = 0;

  void setInitialDates({
    required List<String> dates,
    required bool includeFriday,
  }) {
    emit(
      StartDatesState(
        data: EligibleStartDatesEntity(
          dates: dates,
          includeFriday: includeFriday,
        ),
      ),
    );
  }

  void doIntent(StartDatesEvent event) {
    switch (event) {
      case LoadStartDatesEvent(:final includeFriday):
        unawaited(_load(includeFriday));
    }
  }

  Future<void> _load(bool includeFriday) async {
    final generation = ++_generation;
    emit(const StartDatesState(isLoading: true));
    final result = await _getDates(includeFriday: includeFriday);
    if (isClosed || generation != _generation) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(StartDatesState(data: data));
      case ApiErrorResult(:final failure):
        emit(StartDatesState(failure: failure));
    }
  }
}
