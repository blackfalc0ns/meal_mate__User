import 'package:meal_meat_user/core/errors/failures.dart';
import '../../domain/entities/influencer_analytics_entity.dart';

class InfluencerAnalyticsState {
  const InfluencerAnalyticsState({
    this.isLoading = false,
    this.period = '30d',
    this.analytics,
    this.failure,
  });
  final bool isLoading;
  final String period;
  final InfluencerAnalyticsEntity? analytics;
  final Failure? failure;
  InfluencerAnalyticsState copyWith({
    bool? isLoading,
    String? period,
    InfluencerAnalyticsEntity? analytics,
    Failure? failure,
    bool clearFailure = false,
  }) => InfluencerAnalyticsState(
    isLoading: isLoading ?? this.isLoading,
    period: period ?? this.period,
    analytics: analytics ?? this.analytics,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
