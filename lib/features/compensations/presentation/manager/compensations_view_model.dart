import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import '../../domain/entities/compensation_entity.dart';
import '../../domain/entities/choose_compensation_request_entity.dart';
import '../../domain/usecase/get_compensations_usecase.dart';
import '../../domain/usecase/get_compensation_alternative_dates_usecase.dart';
import '../../domain/usecase/choose_compensation_usecase.dart';
import 'compensations_event.dart';
import 'compensations_state.dart';

@injectable
class CompensationsViewModel extends Cubit<CompensationsState> {
  CompensationsViewModel(this._get, this._getDates, this._choose)
    : super(const CompensationsState());
  final GetCompensationsUseCase _get;
  final GetCompensationAlternativeDatesUseCase _getDates;
  final ChooseCompensationUseCase _choose;
  final Stopwatch _clock = Stopwatch()..start();
  final Map<String, ({Duration receivedAt, Duration remaining})> _timing = {};
  final Set<String> _expiredRefreshes = {};
  Future<void>? _loading;
  int _listRevision = 0;

  void doIntent(CompensationsEvent event) {
    switch (event) {
      case LoadCompensationsEvent():
        unawaited(_load());
      case LoadCompensationDatesEvent(:final id):
        unawaited(_loadDates(id));
      case SelectCompensationDateEvent(:final id, :final date):
        if (state.dates[id]?.any((d) => d.date == date && d.isAvailable) !=
                true ||
            state.submitting.contains(id)) {
          return;
        }
        emit(state.copyWith(selectedDates: {...state.selectedDates, id: date}));
      case SubmitCompensationChoiceEvent(:final id, :final choice):
        unawaited(_submit(id, choice));
      case CompensationDeadlineReachedEvent(:final id):
        if (!_expiredRefreshes.add(id)) return;
        emit(state.copyWith(blockedChoices: {...state.blockedChoices, id}));
        unawaited(_load());
    }
  }

  int remainingSeconds(String id) {
    final timing = _timing[id];
    if (timing == null || state.blockedChoices.contains(id)) return 0;
    return math.max(
      0,
      (timing.remaining - (_clock.elapsed - timing.receivedAt)).inSeconds,
    );
  }

  CompensationEntity? _item(String id) {
    for (final item in state.items) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<void> _load() =>
      _loading ??= _performLoad().whenComplete(() => _loading = null);

  Future<void> _performLoad() async {
    final revision = _listRevision;
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _get();
    if (isClosed) return;
    if (revision != _listRevision) {
      emit(state.copyWith(isLoading: false));
      return;
    }
    switch (result) {
      case ApiSuccessResult(:final data):
        _timing.clear();
        for (final item in data) {
          final deadline = item.choiceDeadlineUtc;
          final server = item.serverTimeUtc;
          if (deadline != null && server != null) {
            _timing[item.id] = (
              receivedAt: _clock.elapsed,
              remaining: deadline.difference(server),
            );
          }
        }
        emit(
          state.copyWith(
            items: data,
            isLoading: false,
            hasLoaded: true,
            clearFailure: true,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(isLoading: false, hasLoaded: true, failure: failure),
        );
    }
  }

  Future<void> _loadDates(String id) async {
    final item = _item(id);
    if (state.loadingDates.contains(id) ||
        state.submitting.contains(id) ||
        item == null ||
        !item.canChoose ||
        remainingSeconds(id) <= 0 ||
        !item.eligibleForAlternativeDay ||
        state.alternativeIneligible.contains(id)) {
      return;
    }
    final failures = {...state.actionFailures}..remove(id);
    final selected = {...state.selectedDates}..remove(id);
    final dates = {...state.dates}..remove(id);
    emit(
      state.copyWith(
        loadingDates: {...state.loadingDates, id},
        actionFailures: failures,
        selectedDates: selected,
        dates: dates,
      ),
    );
    final result = await _getDates(id);
    if (isClosed) return;
    final loading = {...state.loadingDates}..remove(id);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            loadingDates: loading,
            dates: {...state.dates, id: data},
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(
            loadingDates: loading,
            actionFailures: {...state.actionFailures, id: failure},
            alternativeIneligible:
                failure.code == 'ALTERNATIVE_DAY_NOT_ELIGIBLE'
                ? {...state.alternativeIneligible, id}
                : state.alternativeIneligible,
            blockedChoices: failure.code == 'COMPENSATION_CHOICE_WINDOW_EXPIRED'
                ? {...state.blockedChoices, id}
                : state.blockedChoices,
          ),
        );
        if (failure.code == 'COMPENSATION_CHOICE_WINDOW_EXPIRED') {
          await _loading;
          if (!isClosed) await _load();
        }
    }
  }

  Future<void> _submit(String id, CompensationChoice choice) async {
    final item = _item(id);
    if (item == null ||
        !item.canChoose ||
        remainingSeconds(id) <= 0 ||
        state.submitting.contains(id)) {
      return;
    }
    final date = state.selectedDates[id];
    if (choice == CompensationChoice.alternativeDay &&
        (!item.eligibleForAlternativeDay ||
            state.alternativeIneligible.contains(id) ||
            date == null ||
            state.dates[id]?.any((d) => d.date == date && d.isAvailable) !=
                true)) {
      return;
    }
    final failures = {...state.actionFailures}..remove(id);
    _listRevision++;
    emit(
      state.copyWith(
        submitting: {...state.submitting, id},
        actionFailures: failures,
      ),
    );
    final result = await _choose(
      ChooseCompensationRequestEntity(
        compensationId: id,
        choice: choice,
        targetDate: date,
      ),
    );
    if (isClosed) return;
    _listRevision++;
    final submitting = {...state.submitting}..remove(id);
    switch (result) {
      case ApiSuccessResult(:final data):
        // Block repeat submissions even if the follow-up refresh fails.
        emit(
          state.copyWith(
            submitting: submitting,
            items: data.id == id && data.status.isNotEmpty
                ? List.unmodifiable(
                    state.items.map(
                      (item) => item.id == id
                          ? item.withChoice(
                              status: data.status,
                              selectedAlternativeDate:
                                  data.selectedAlternativeDate,
                            )
                          : item,
                    ),
                  )
                : state.items,
            blockedChoices: {...state.blockedChoices, id},
          ),
        );
        await _loading;
        if (!isClosed) await _load();
      case ApiErrorResult(:final failure):
        final expired = failure.code == 'COMPENSATION_CHOICE_WINDOW_EXPIRED';
        final ineligible = failure.code == 'ALTERNATIVE_DAY_NOT_ELIGIBLE';
        final capacity = failure.code == 'CAPACITY_DEPLETED_FOR_DATE';
        final selected = {...state.selectedDates};
        if (capacity) selected.remove(id);
        emit(
          state.copyWith(
            submitting: submitting,
            selectedDates: selected,
            blockedChoices: expired
                ? {...state.blockedChoices, id}
                : state.blockedChoices,
            alternativeIneligible: ineligible
                ? {...state.alternativeIneligible, id}
                : state.alternativeIneligible,
            actionFailures: {...state.actionFailures, id: failure},
          ),
        );
        if (capacity) {
          await _loadDates(id);
          if (!isClosed) {
            emit(
              state.copyWith(
                actionFailures: {...state.actionFailures, id: failure},
              ),
            );
          }
        }
        if (expired) {
          await _loading;
          if (!isClosed) await _load();
        }
    }
  }

  @override
  Future<void> close() {
    _clock.stop();
    return super.close();
  }
}
