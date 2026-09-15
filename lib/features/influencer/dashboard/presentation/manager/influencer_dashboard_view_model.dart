import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_dashboard_api_entity.dart';
import '../../domain/usecase/get_influencer_home_usecase.dart';
import '../../domain/usecase/get_influencer_links_usecase.dart';
import 'influencer_dashboard_event.dart';
import 'influencer_dashboard_state.dart';

@injectable
class InfluencerDashboardViewModel extends Cubit<InfluencerDashboardState> {
  InfluencerDashboardViewModel(this._getHome, this._getLinks)
    : super(const InfluencerDashboardState());
  final GetInfluencerHomeUseCase _getHome;
  final GetInfluencerLinksUseCase _getLinks;

  Future<void> doIntent(InfluencerDashboardEvent event) => switch (event) {
    LoadInfluencerDashboardEvent() => _loadHome(
      forceRefresh: event.forceRefresh,
    ),
    LoadInfluencerLinksEvent() => _loadLinks(forceRefresh: event.forceRefresh),
  };

  Future<void> _loadHome({required bool forceRefresh}) async {
    if (state.isLoading || (!forceRefresh && state.home != null)) return;
    emit(state.copyWith(isLoading: true, clearFailure: true));
    switch (await _getHome()) {
      case ApiSuccessResult<InfluencerHomeApiEntity>(:final data):
        emit(state.copyWith(isLoading: false, home: data, clearFailure: true));
      case ApiErrorResult<InfluencerHomeApiEntity>(:final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  Future<void> _loadLinks({required bool forceRefresh}) async {
    if (state.isLoading || (!forceRefresh && state.links != null)) return;
    emit(state.copyWith(isLoading: true, clearFailure: true));
    switch (await _getLinks()) {
      case ApiSuccessResult<InfluencerLinksEntity>(:final data):
        emit(state.copyWith(isLoading: false, links: data, clearFailure: true));
      case ApiErrorResult<InfluencerLinksEntity>(:final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }
}
