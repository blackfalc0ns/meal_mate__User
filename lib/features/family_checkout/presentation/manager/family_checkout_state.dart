import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

class FamilyPlanState {
  const FamilyPlanState({
    this.isPackagesLoading = false,
    this.packages = const [],
    this.selectedPackage,
    this.isCurrentFlowLoading = false,
    this.currentFlow,
    this.isRelationshipsLoading = false,
    this.relationships = const [],
    this.isAddressesLoading = false,
    this.addresses = const [],
    this.isProgramsLoading = false,
    this.programs = const [],
    this.selectedProgramIndex,
    this.isBundlesLoading = false,
    this.bundles = const [],
    this.selectedBundleIndex,
    this.isDurationsLoading = false,
    this.durations = const [],
    this.selectedDurationIndex,
    this.customDurationDays,
    this.includeFriday = false,
    this.isTiersLoading = false,
    this.tiers = const [],
    this.selectedTierIndex,
    this.isBrowseRestaurantsLoading = false,
    this.browseRestaurants = const [],
    this.browsedTierIndex,
    this.isRestaurantsView = false,
    this.browseRestaurantsFailure,
    this.selectedMemberIndex = 0,
    this.selectedSummaryMemberId,
    this.isSummaryLoading = false,
    this.summary,
    this.isPaymentMethodsLoading = false,
    this.paymentMethods = const [],
    this.selectedPaymentMethod,
    this.isCheckoutLoading = false,
    this.checkoutResult,
    this.failure,
  });

  final bool isPackagesLoading;
  final List<FamilySizePackageEntity> packages;
  final FamilySizePackageEntity? selectedPackage;

  final bool isCurrentFlowLoading;
  final FamilyFlowCurrentEntity? currentFlow;

  final bool isRelationshipsLoading;
  final List<FamilyRelationshipEntity> relationships;

  final bool isAddressesLoading;
  final List<CustomerAddressEntity> addresses;

  final bool isProgramsLoading;
  final List<SubscriptionProgramEntity> programs;
  final int? selectedProgramIndex;

  final bool isBundlesLoading;
  final List<SubscriptionBundleEntity> bundles;
  final int? selectedBundleIndex;

  final bool isDurationsLoading;
  final List<SubscriptionDurationEntity> durations;
  final int? selectedDurationIndex;
  final int? customDurationDays;
  final bool includeFriday;

  final bool isTiersLoading;
  final List<SubscriptionTierEntity> tiers;
  final int? selectedTierIndex;

  final bool isBrowseRestaurantsLoading;
  final List<SubscriptionTierRestaurantBrowseEntity> browseRestaurants;
  final int? browsedTierIndex;
  final bool isRestaurantsView;
  final Failure? browseRestaurantsFailure;

  final int selectedMemberIndex;
  final String? selectedSummaryMemberId;

  final bool isSummaryLoading;
  final FamilySummaryEntity? summary;

  final bool isPaymentMethodsLoading;
  final List<PaymentMethodEntity> paymentMethods;
  final PaymentMethodEntity? selectedPaymentMethod;

  final bool isCheckoutLoading;
  final PaymentCheckoutEntity? checkoutResult;

  final Failure? failure;

  bool get isLoading =>
      isPackagesLoading ||
      isCurrentFlowLoading ||
      isProgramsLoading ||
      isBundlesLoading ||
      isDurationsLoading ||
      isTiersLoading ||
      isSummaryLoading ||
      isCheckoutLoading;

  int get maxMembers =>
      selectedPackage?.maxMembers ?? currentFlow?.maxMembers ?? 6;

  int get minMembers =>
      selectedPackage?.minMembers ?? currentFlow?.minMembers ?? 2;

  double get discountPercent =>
      selectedPackage?.discountPercent ?? currentFlow?.discountPercent ?? 0.0;

  List<FamilyMemberEntity> get members => currentFlow?.members ?? const [];

  FamilyMemberEntity? get selectedMember {
    final list = members;
    if (list.isEmpty ||
        selectedMemberIndex < 0 ||
        selectedMemberIndex >= list.length) {
      return null;
    }
    return list[selectedMemberIndex];
  }

  SubscriptionProgramEntity? get selectedProgram {
    final index = selectedProgramIndex;
    if (index == null || index < 0 || index >= programs.length) return null;
    return programs[index];
  }

  SubscriptionBundleEntity? get selectedBundle {
    final index = selectedBundleIndex;
    if (index == null || index < 0 || index >= bundles.length) return null;
    return bundles[index];
  }

  SubscriptionDurationEntity? get selectedDuration {
    final index = selectedDurationIndex;
    if (index == null || index < 0 || index >= durations.length) return null;
    return durations[index];
  }

  int? get selectedDurationDays {
    final duration = selectedDuration;
    if (duration == null) return customDurationDays;
    return duration.isCustom ? customDurationDays : duration.durationDays;
  }

  SubscriptionTierEntity? get selectedTier {
    final index = selectedTierIndex;
    if (index == null || index < 0 || index >= tiers.length) return null;
    return tiers[index];
  }

  FamilyPlanState copyWith({
    bool? isPackagesLoading,
    List<FamilySizePackageEntity>? packages,
    FamilySizePackageEntity? selectedPackage,
    bool? isCurrentFlowLoading,
    FamilyFlowCurrentEntity? currentFlow,
    bool? isRelationshipsLoading,
    List<FamilyRelationshipEntity>? relationships,
    bool? isAddressesLoading,
    List<CustomerAddressEntity>? addresses,
    bool? isProgramsLoading,
    List<SubscriptionProgramEntity>? programs,
    int? selectedProgramIndex,
    bool clearSelectedProgram = false,
    bool? isBundlesLoading,
    List<SubscriptionBundleEntity>? bundles,
    int? selectedBundleIndex,
    bool clearSelectedBundle = false,
    bool? isDurationsLoading,
    List<SubscriptionDurationEntity>? durations,
    int? selectedDurationIndex,
    bool clearSelectedDuration = false,
    int? customDurationDays,
    bool? includeFriday,
    bool? isTiersLoading,
    List<SubscriptionTierEntity>? tiers,
    int? selectedTierIndex,
    bool clearSelectedTier = false,
    bool? isBrowseRestaurantsLoading,
    List<SubscriptionTierRestaurantBrowseEntity>? browseRestaurants,
    int? browsedTierIndex,
    bool? isRestaurantsView,
    Failure? browseRestaurantsFailure,
    int? selectedMemberIndex,
    String? selectedSummaryMemberId,
    bool? isSummaryLoading,
    FamilySummaryEntity? summary,
    bool? isPaymentMethodsLoading,
    List<PaymentMethodEntity>? paymentMethods,
    PaymentMethodEntity? selectedPaymentMethod,
    bool clearSelectedPaymentMethod = false,
    bool? isCheckoutLoading,
    PaymentCheckoutEntity? checkoutResult,
    Failure? failure,
    bool clearFailure = false,
    bool clearBrowseRestaurants = false,
    bool clearBrowseRestaurantsFailure = false,
    bool clearCheckoutResult = false,
  }) {
    return FamilyPlanState(
      isPackagesLoading: isPackagesLoading ?? this.isPackagesLoading,
      packages: packages ?? this.packages,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      isCurrentFlowLoading: isCurrentFlowLoading ?? this.isCurrentFlowLoading,
      currentFlow: currentFlow ?? this.currentFlow,
      isRelationshipsLoading:
          isRelationshipsLoading ?? this.isRelationshipsLoading,
      relationships: relationships ?? this.relationships,
      isAddressesLoading: isAddressesLoading ?? this.isAddressesLoading,
      addresses: addresses ?? this.addresses,
      isProgramsLoading: isProgramsLoading ?? this.isProgramsLoading,
      programs: programs ?? this.programs,
      selectedProgramIndex: clearSelectedProgram
          ? null
          : (selectedProgramIndex ?? this.selectedProgramIndex),
      isBundlesLoading: isBundlesLoading ?? this.isBundlesLoading,
      bundles: bundles ?? this.bundles,
      selectedBundleIndex: clearSelectedBundle
          ? null
          : (selectedBundleIndex ?? this.selectedBundleIndex),
      isDurationsLoading: isDurationsLoading ?? this.isDurationsLoading,
      durations: durations ?? this.durations,
      selectedDurationIndex: clearSelectedDuration
          ? null
          : (selectedDurationIndex ?? this.selectedDurationIndex),
      customDurationDays: customDurationDays ?? this.customDurationDays,
      includeFriday: includeFriday ?? this.includeFriday,
      isTiersLoading: isTiersLoading ?? this.isTiersLoading,
      tiers: tiers ?? this.tiers,
      selectedTierIndex: clearSelectedTier
          ? null
          : (selectedTierIndex ?? this.selectedTierIndex),
      isBrowseRestaurantsLoading:
          isBrowseRestaurantsLoading ?? this.isBrowseRestaurantsLoading,
      browseRestaurants: clearBrowseRestaurants
          ? const []
          : (browseRestaurants ?? this.browseRestaurants),
      browsedTierIndex: browsedTierIndex ?? this.browsedTierIndex,
      isRestaurantsView: isRestaurantsView ?? this.isRestaurantsView,
      browseRestaurantsFailure: clearBrowseRestaurantsFailure
          ? null
          : (browseRestaurantsFailure ?? this.browseRestaurantsFailure),
      selectedMemberIndex: selectedMemberIndex ?? this.selectedMemberIndex,
      selectedSummaryMemberId:
          selectedSummaryMemberId ?? this.selectedSummaryMemberId,
      isSummaryLoading: isSummaryLoading ?? this.isSummaryLoading,
      summary: summary ?? this.summary,
      isPaymentMethodsLoading:
          isPaymentMethodsLoading ?? this.isPaymentMethodsLoading,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethod: clearSelectedPaymentMethod
          ? null
          : selectedPaymentMethod ?? this.selectedPaymentMethod,
      isCheckoutLoading: isCheckoutLoading ?? this.isCheckoutLoading,
      checkoutResult: clearCheckoutResult
          ? null
          : (checkoutResult ?? this.checkoutResult),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
