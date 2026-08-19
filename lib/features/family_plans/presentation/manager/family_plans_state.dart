import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_response_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_metadata_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_payment_method_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class FamilyPlansState {
  const FamilyPlansState({
    this.isLoading = false,
    this.isMetadataLoading = false,
    this.isGroupLoading = false,
    this.isMemberActionLoading = false,
    this.isSummaryLoading = false,
    this.isPaymentMethodsLoading = false,
    this.isCheckoutLoading = false,
    this.isProgramsLoading = false,
    this.isBundlesLoading = false,
    this.isDurationsLoading = false,
    this.isTiersLoading = false,
    this.isRestaurantsLoading = false,
    this.isSuccess = false,
    this.metadata,
    this.currentGroup,
    this.summary,
    this.paymentMethods,
    this.checkoutResult,
    this.programs,
    this.bundles,
    this.durations,
    this.tiers,
    this.restaurants,
    this.failure,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isMetadataLoading;
  final bool isGroupLoading;
  final bool isMemberActionLoading;
  final bool isSummaryLoading;
  final bool isPaymentMethodsLoading;
  final bool isCheckoutLoading;
  final bool isProgramsLoading;
  final bool isBundlesLoading;
  final bool isDurationsLoading;
  final bool isTiersLoading;
  final bool isRestaurantsLoading;
  final bool isSuccess;
  final FamilyMetadataEntity? metadata;
  final FamilyGroupEntity? currentGroup;
  final FamilySummaryEntity? summary;
  final List<FamilyPaymentMethodEntity>? paymentMethods;
  final FamilyCheckoutResponseEntity? checkoutResult;
  final List<SubscriptionProgramEntity>? programs;
  final List<SubscriptionBundleEntity>? bundles;
  final List<SubscriptionDurationEntity>? durations;
  final List<SubscriptionTierEntity>? tiers;
  final List<SubscriptionTierRestaurantBrowseEntity>? restaurants;
  final Failure? failure;
  final String? errorMessage;

  FamilyPlansState copyWith({
    bool? isLoading,
    bool? isMetadataLoading,
    bool? isGroupLoading,
    bool? isMemberActionLoading,
    bool? isSummaryLoading,
    bool? isPaymentMethodsLoading,
    bool? isCheckoutLoading,
    bool? isProgramsLoading,
    bool? isBundlesLoading,
    bool? isDurationsLoading,
    bool? isTiersLoading,
    bool? isRestaurantsLoading,
    bool? isSuccess,
    FamilyMetadataEntity? metadata,
    FamilyGroupEntity? currentGroup,
    FamilySummaryEntity? summary,
    List<FamilyPaymentMethodEntity>? paymentMethods,
    FamilyCheckoutResponseEntity? checkoutResult,
    List<SubscriptionProgramEntity>? programs,
    List<SubscriptionBundleEntity>? bundles,
    List<SubscriptionDurationEntity>? durations,
    List<SubscriptionTierEntity>? tiers,
    List<SubscriptionTierRestaurantBrowseEntity>? restaurants,
    Failure? failure,
    String? errorMessage,
    bool clearFailure = false,
    bool clearErrorMessage = false,
    bool clearCheckoutResult = false,
  }) {
    return FamilyPlansState(
      isLoading: isLoading ?? this.isLoading,
      isMetadataLoading: isMetadataLoading ?? this.isMetadataLoading,
      isGroupLoading: isGroupLoading ?? this.isGroupLoading,
      isMemberActionLoading:
          isMemberActionLoading ?? this.isMemberActionLoading,
      isSummaryLoading: isSummaryLoading ?? this.isSummaryLoading,
      isPaymentMethodsLoading:
          isPaymentMethodsLoading ?? this.isPaymentMethodsLoading,
      isCheckoutLoading: isCheckoutLoading ?? this.isCheckoutLoading,
      isProgramsLoading: isProgramsLoading ?? this.isProgramsLoading,
      isBundlesLoading: isBundlesLoading ?? this.isBundlesLoading,
      isDurationsLoading: isDurationsLoading ?? this.isDurationsLoading,
      isTiersLoading: isTiersLoading ?? this.isTiersLoading,
      isRestaurantsLoading: isRestaurantsLoading ?? this.isRestaurantsLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      metadata: metadata ?? this.metadata,
      currentGroup: currentGroup ?? this.currentGroup,
      summary: summary ?? this.summary,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      checkoutResult:
          clearCheckoutResult ? null : (checkoutResult ?? this.checkoutResult),
      programs: programs ?? this.programs,
      bundles: bundles ?? this.bundles,
      durations: durations ?? this.durations,
      tiers: tiers ?? this.tiers,
      restaurants: restaurants ?? this.restaurants,
      failure: clearFailure ? null : (failure ?? this.failure),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
