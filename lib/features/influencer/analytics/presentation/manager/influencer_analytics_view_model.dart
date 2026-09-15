import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_analytics_entity.dart';
import '../../domain/usecase/get_influencer_analytics_usecase.dart';
import 'influencer_analytics_event.dart';
import 'influencer_analytics_state.dart';

@injectable
class InfluencerAnalyticsViewModel extends Cubit<InfluencerAnalyticsState> {
  InfluencerAnalyticsViewModel(this._getAnalytics)
    : super(const InfluencerAnalyticsState());
  final GetInfluencerAnalyticsUseCase _getAnalytics;
  Future<void> doIntent(InfluencerAnalyticsEvent event) => switch (event) {
    LoadInfluencerAnalyticsEvent() => _load(event),
  };
  Future<void> _load(LoadInfluencerAnalyticsEvent event) async {
    if (state.isLoading ||
        (!event.forceRefresh &&
            state.analytics != null &&
            state.period == event.period)) {
      return;
    }
    emit(
      state.copyWith(isLoading: true, period: event.period, clearFailure: true),
    );
    switch (await _getAnalytics(event.period)) {
      case ApiSuccessResult<InfluencerAnalyticsEntity>(:final data):
        if (state.period == event.period) {
          emit(
            state.copyWith(
              isLoading: false,
              analytics: data,
              clearFailure: true,
            ),
          );
        }
      case ApiErrorResult<InfluencerAnalyticsEntity>(:final failure):
        if (state.period == event.period) {
          emit(state.copyWith(isLoading: false, failure: failure));
        }
    }
  }
}
