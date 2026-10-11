import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class SubscriptionProgramsState {
  const SubscriptionProgramsState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isSuccess = false,
    this.programs = const [],
    this.bundles = const [],
    this.pagination,
    this.failure,
    this.loadMoreFailure,
    this.hasDeliveryAddress = false,
    this.hasAllergies = false,
    this.hasDietaryPreferences = false,
    this.isProfileComplete = false,
    this.addressCoverage,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isSuccess;
  final List<SubscriptionProgramEntity> programs;
  final List<SubscriptionBundleEntity> bundles;
  final PaginationEntity? pagination;
  final Failure? failure;
  final Failure? loadMoreFailure;
  final bool hasDeliveryAddress;
  final bool hasAllergies;
  final bool hasDietaryPreferences;
  final bool isProfileComplete;
  final String? addressCoverage;

  bool get isAddressRequired => !hasDeliveryAddress;
  bool get isNoDelivery =>
      hasDeliveryAddress &&
      (addressCoverage == 'no_delivery' || addressCoverage == 'uncovered');

  SubscriptionProgramsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isSuccess,
    List<SubscriptionProgramEntity>? programs,
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
    String? addressCoverage,
  }) {
    return SubscriptionProgramsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSuccess: isSuccess ?? this.isSuccess,
      programs: programs ?? this.programs,
      bundles: bundles ?? this.bundles,
      pagination: clearPagination ? null : pagination ?? this.pagination,
      failure: clearFailure ? null : failure ?? this.failure,
      loadMoreFailure: clearLoadMoreFailure
          ? null
          : loadMoreFailure ?? this.loadMoreFailure,
      hasDeliveryAddress: hasDeliveryAddress ?? this.hasDeliveryAddress,
      hasAllergies: hasAllergies ?? this.hasAllergies,
      hasDietaryPreferences:
          hasDietaryPreferences ?? this.hasDietaryPreferences,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      addressCoverage: addressCoverage ?? this.addressCoverage,
    );
  }
}
