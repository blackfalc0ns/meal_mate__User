import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';

class SubscriptionPackagesState {
  const SubscriptionPackagesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.bundles = const [],
    this.failure,
    this.hasDeliveryAddress = false,
    this.hasAllergies = false,
    this.hasDietaryPreferences = false,
    this.isProfileComplete = false,
  });

  final bool isLoading;
  final bool isSuccess;
  final List<SubscriptionBundleEntity> bundles;
  final Failure? failure;
  final bool hasDeliveryAddress;
  final bool hasAllergies;
  final bool hasDietaryPreferences;
  final bool isProfileComplete;

  SubscriptionPackagesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<SubscriptionBundleEntity>? bundles,
    Failure? failure,
    bool clearFailure = false,
    bool? hasDeliveryAddress,
    bool? hasAllergies,
    bool? hasDietaryPreferences,
    bool? isProfileComplete,
  }) {
    return SubscriptionPackagesState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      bundles: bundles ?? this.bundles,
      failure: clearFailure ? null : failure ?? this.failure,
      hasDeliveryAddress: hasDeliveryAddress ?? this.hasDeliveryAddress,
      hasAllergies: hasAllergies ?? this.hasAllergies,
      hasDietaryPreferences:
          hasDietaryPreferences ?? this.hasDietaryPreferences,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
