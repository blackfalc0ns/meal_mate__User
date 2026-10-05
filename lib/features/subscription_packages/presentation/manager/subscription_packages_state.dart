import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';

class SubscriptionPackagesState {
  const SubscriptionPackagesState({
    this.programId = '',
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isSuccess = false,
    this.bundles = const [],
    this.pagination,
    this.failure,
    this.loadMoreFailure,
    this.hasDeliveryAddress = false,
    this.hasAllergies = false,
    this.hasDietaryPreferences = false,
    this.isProfileComplete = false,
  });

  final String programId;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isSuccess;
  final List<SubscriptionBundleEntity> bundles;
  final PaginationEntity? pagination;
  final Failure? failure;
  final Failure? loadMoreFailure;
  final bool hasDeliveryAddress;
  final bool hasAllergies;
  final bool hasDietaryPreferences;
  final bool isProfileComplete;

  SubscriptionPackagesState copyWith({
    String? programId,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isSuccess,
    List<SubscriptionBundleEntity>? bundles,
    PaginationEntity? pagination,
    bool clearPagination = false,
    Failure? failure,
    bool clearFailure = false,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
    bool? hasDeliveryAddress,
    bool? hasAllergies,
    bool? hasDietaryPreferences,
    bool? isProfileComplete,
  }) {
    return SubscriptionPackagesState(
      programId: programId ?? this.programId,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSuccess: isSuccess ?? this.isSuccess,
      bundles: bundles ?? this.bundles,
      pagination: clearPagination ? null : pagination ?? this.pagination,
      failure: clearFailure ? null : failure ?? this.failure,
      loadMoreFailure:
          clearLoadMoreFailure ? null : loadMoreFailure ?? this.loadMoreFailure,
      hasDeliveryAddress: hasDeliveryAddress ?? this.hasDeliveryAddress,
      hasAllergies: hasAllergies ?? this.hasAllergies,
      hasDietaryPreferences:
          hasDietaryPreferences ?? this.hasDietaryPreferences,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
