import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class SubscriptionSummaryState {
  const SubscriptionSummaryState({
    this.isLoading = false,
    this.isSummaryRefreshing = false,
    this.summary,
    this.failure,
    this.selectedStartDate = '',
    this.earliestStartDate = '',
    this.activeRequest,
    this.couponDraft = '',
    this.isApplyingCoupon = false,
    this.isLoadingMoreRestaurants = false,
    this.restaurantsAppendFailure,
  });

  final bool isLoading;
  final bool isSummaryRefreshing;
  final SubscriptionSummaryEntity? summary;
  final Failure? failure;
  final String selectedStartDate;
  final String earliestStartDate;
  final SubscriptionSummaryRequestEntity? activeRequest;
  final String couponDraft;
  final bool isApplyingCoupon;
  final bool isLoadingMoreRestaurants;
  final Failure? restaurantsAppendFailure;

  bool get canCheckout {
    if (failure != null) return false;
    if (isSummaryRefreshing || isLoading || isApplyingCoupon) return false;
    final s = summary;
    if (s == null) return false;
    return s.canCheckout;
  }

  SubscriptionSummaryState copyWith({
    bool? isLoading,
    bool? isSummaryRefreshing,
    SubscriptionSummaryEntity? summary,
    Failure? failure,
    String? selectedStartDate,
    String? earliestStartDate,
    SubscriptionSummaryRequestEntity? activeRequest,
    String? couponDraft,
    bool? isApplyingCoupon,
    bool? isLoadingMoreRestaurants,
    Failure? restaurantsAppendFailure,
    bool clearSummary = false,
    bool clearFailure = false,
    bool clearAppendFailure = false,
    bool clearCouponDraft = false,
    bool clearActiveRequest = false,
  }) {
    return SubscriptionSummaryState(
      isLoading: isLoading ?? this.isLoading,
      isSummaryRefreshing: isSummaryRefreshing ?? this.isSummaryRefreshing,
      summary: clearSummary ? null : (summary ?? this.summary),
      failure: clearFailure ? null : (failure ?? this.failure),
      selectedStartDate: selectedStartDate ?? this.selectedStartDate,
      earliestStartDate: earliestStartDate ?? this.earliestStartDate,
      activeRequest: clearActiveRequest ? null : (activeRequest ?? this.activeRequest),
      couponDraft: clearCouponDraft ? '' : (couponDraft ?? this.couponDraft),
      isApplyingCoupon: isApplyingCoupon ?? this.isApplyingCoupon,
      isLoadingMoreRestaurants:
          isLoadingMoreRestaurants ?? this.isLoadingMoreRestaurants,
      restaurantsAppendFailure: clearAppendFailure
          ? null
          : (restaurantsAppendFailure ?? this.restaurantsAppendFailure),
    );
  }
}
