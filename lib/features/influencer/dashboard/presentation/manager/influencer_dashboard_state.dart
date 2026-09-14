import '../../../../../core/network/failures.dart';
import '../../domain/entities/influencer_api_entities.dart';

class InfluencerDashboardState {
  const InfluencerDashboardState({
    this.isLoading = false,
    this.home,
    this.profile,
    this.failure,
  });
  final bool isLoading;
  final InfluencerHomeApiEntity? home;
  final InfluencerProfileApiEntity? profile;
  final Failure? failure;
  InfluencerDashboardState copyWith({
    bool? isLoading,
    InfluencerHomeApiEntity? home,
    InfluencerProfileApiEntity? profile,
    Failure? failure,
    bool clearFailure = false,
  }) => InfluencerDashboardState(
    isLoading: isLoading ?? this.isLoading,
    home: home ?? this.home,
    profile: profile ?? this.profile,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
