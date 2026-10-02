import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

class SubscriptionSummaryState {
  const SubscriptionSummaryState({
    this.isLoading = false,
    this.summary,
    this.failure,
    this.selectedStartDate = '',
    this.earliestStartDate = '',
  });

  final bool isLoading;
  final SubscriptionSummaryEntity? summary;
  final Failure? failure;
  final String selectedStartDate;
  final String earliestStartDate;

  SubscriptionSummaryState copyWith({
    bool? isLoading,
    SubscriptionSummaryEntity? summary,
    Failure? failure,
    String? selectedStartDate,
    String? earliestStartDate,
    bool clearSummary = false,
    bool clearFailure = false,
  }) {
    return SubscriptionSummaryState(
      isLoading: isLoading ?? this.isLoading,
      summary: clearSummary ? null : summary ?? this.summary,
      failure: clearFailure ? null : failure ?? this.failure,
      selectedStartDate: selectedStartDate ?? this.selectedStartDate,
      earliestStartDate: earliestStartDate ?? this.earliestStartDate,
    );
  }
}
