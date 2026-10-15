import 'package:meal_meat_user/core/errors/failures.dart';
import '../../domain/entities/influencer_social_links_entity.dart';

class InfluencerSocialLinksState {
  const InfluencerSocialLinksState({
    this.isLoading = false,
    this.isSaving = false,
    this.isSuccess = false,
    this.profile,
    this.failure,
  });
  final bool isLoading, isSaving, isSuccess;
  final InfluencerSocialProfileEntity? profile;
  final Failure? failure;
  InfluencerSocialLinksState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isSuccess,
    InfluencerSocialProfileEntity? profile,
    Failure? failure,
    bool clearFailure = false,
  }) => InfluencerSocialLinksState(
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    isSuccess: isSuccess ?? this.isSuccess,
    profile: profile ?? this.profile,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
