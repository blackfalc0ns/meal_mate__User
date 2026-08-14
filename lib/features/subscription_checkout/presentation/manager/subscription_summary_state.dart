import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

class SubscriptionSummaryState {
  const SubscriptionSummaryState({
    this.isLoading = false,
    this.summary,
    this.failure,
  });

  final bool isLoading;
  final SubscriptionSummaryEntity? summary;
  final Failure? failure;

  SubscriptionSummaryState copyWith({
    bool? isLoading,
    SubscriptionSummaryEntity? summary,
    Failure? failure,
    bool clearSummary = false,
    bool clearFailure = false,
  }) {
    return SubscriptionSummaryState(
      isLoading: isLoading ?? this.isLoading,
      summary: clearSummary ? null : summary ?? this.summary,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
