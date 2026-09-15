import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_social_links_entity.dart';
import '../../domain/usecase/get_influencer_social_profile_usecase.dart';
import '../../domain/usecase/update_influencer_social_links_usecase.dart';
import 'influencer_social_links_event.dart';
import 'influencer_social_links_state.dart';

@injectable
class InfluencerSocialLinksViewModel extends Cubit<InfluencerSocialLinksState> {
  InfluencerSocialLinksViewModel(this._getProfile, this._updateLinks)
    : super(const InfluencerSocialLinksState());
  final GetInfluencerSocialProfileUseCase _getProfile;
  final UpdateInfluencerSocialLinksUseCase _updateLinks;
  Future<void> doIntent(InfluencerSocialLinksEvent event) => switch (event) {
    LoadInfluencerSocialLinksEvent() => _load(forceRefresh: event.forceRefresh),
    SaveInfluencerSocialLinksEvent() => _save(event.links),
  };
  Future<void> _load({required bool forceRefresh}) async {
    if (state.isLoading || (!forceRefresh && state.profile != null)) return;
    emit(state.copyWith(isLoading: true, isSuccess: false, clearFailure: true));
    switch (await _getProfile()) {
      case ApiSuccessResult<InfluencerSocialProfileEntity>(:final data):
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            profile: data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<InfluencerSocialProfileEntity>(:final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  Future<void> _save(InfluencerSocialLinksEntity links) async {
    if (state.isSaving) return;
    emit(state.copyWith(isSaving: true, isSuccess: false, clearFailure: true));
    switch (await _updateLinks(links)) {
      case ApiSuccessResult<InfluencerSocialLinksEntity>(:final data):
        final current = state.profile;
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: true,
            profile: current == null
                ? null
                : InfluencerSocialProfileEntity(
                    id: current.id,
                    displayName: current.displayName,
                    code: current.code,
                    commissionRate: current.commissionRate,
                    status: current.status,
                    isActive: current.isActive,
                    hasCompletedSocialOnboarding:
                        current.hasCompletedSocialOnboarding,
                    links: data,
                    avatarUrl: current.avatarUrl,
                    partnerTermsUrl: current.partnerTermsUrl,
                  ),
            clearFailure: true,
          ),
        );
      case ApiErrorResult<InfluencerSocialLinksEntity>(:final failure):
        emit(state.copyWith(isSaving: false, failure: failure));
    }
  }
}
