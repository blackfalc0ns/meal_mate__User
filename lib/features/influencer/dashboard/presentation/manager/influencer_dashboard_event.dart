sealed class InfluencerDashboardEvent {
  const InfluencerDashboardEvent();
}

final class LoadInfluencerDashboardEvent extends InfluencerDashboardEvent {
  const LoadInfluencerDashboardEvent({this.forceRefresh = false});
  final bool forceRefresh;
}

final class LoadInfluencerLinksEvent extends InfluencerDashboardEvent {
  const LoadInfluencerLinksEvent({this.forceRefresh = false});
  final bool forceRefresh;
}
