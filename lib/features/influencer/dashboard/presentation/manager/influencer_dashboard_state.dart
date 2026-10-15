import 'package:meal_meat_user/core/errors/failures.dart';
import '../../domain/entities/influencer_dashboard_api_entity.dart';

class InfluencerDashboardState {
  const InfluencerDashboardState({
    this.isLoading = false,
    this.home,
    this.links,
    this.failure,
  });
  final bool isLoading;
  final InfluencerHomeApiEntity? home;
  final InfluencerLinksEntity? links;
  final Failure? failure;
  InfluencerDashboardState copyWith({
    bool? isLoading,
    InfluencerHomeApiEntity? home,
    InfluencerLinksEntity? links,
    Failure? failure,
    bool clearFailure = false,
  }) => InfluencerDashboardState(
    isLoading: isLoading ?? this.isLoading,
    home: home ?? this.home,
    links: links ?? this.links,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
