sealed class InfluencerAnalyticsEvent {
  const InfluencerAnalyticsEvent();
}

final class LoadInfluencerAnalyticsEvent extends InfluencerAnalyticsEvent {
  const LoadInfluencerAnalyticsEvent({
    this.period = '30d',
    this.forceRefresh = false,
  });
  final String period;
  final bool forceRefresh;
}
