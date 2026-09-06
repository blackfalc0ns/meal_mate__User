import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';

class RestaurantTierUpgradeState {
  const RestaurantTierUpgradeState({
    this.subscriptionId = '',
    this.programName,
    this.bundleName,
    this.isLoadingOptions = false,
    this.optionsFailure,
    this.optionsEntity,
    this.selectedOption,
    this.selectedPaymentMethod,
    this.isLoadingSummary = false,
    this.summaryFailure,
    this.upgradeSummary,
    this.uiData,
    this.isSubmitting = false,
    this.submitFailure,
    this.upgradeRequestResult,
    this.isPollingStatus = false,
    this.statusFailure,
    this.upgradeStatus,
    this.isUpgradeSuccess = false,
    this.isUpgradeFailed = false,
    this.errorMessage,
  });

  final String subscriptionId;
  final String? programName;
  final String? bundleName;
  final bool isLoadingOptions;
  final Failure? optionsFailure;
  final SubscriptionUpgradeOptionsEntity? optionsEntity;
  final SubscriptionUpgradeOptionEntity? selectedOption;
  final SubscriptionUpgradePaymentMethodEntity? selectedPaymentMethod;
  final bool isLoadingSummary;
  final Failure? summaryFailure;
  final SubscriptionUpgradeSummaryEntity? upgradeSummary;
  final RestaurantTierUpgradeEntity? uiData;
  final bool isSubmitting;
  final Failure? submitFailure;
  final SubscriptionUpgradeRequestResultEntity? upgradeRequestResult;
  final bool isPollingStatus;
  final Failure? statusFailure;
  final SubscriptionUpgradeStatusEntity? upgradeStatus;
  final bool isUpgradeSuccess;
  final bool isUpgradeFailed;
  final String? errorMessage;

  RestaurantTierUpgradeState copyWith({
    String? subscriptionId,
    String? programName,
    String? bundleName,
    bool? isLoadingOptions,
    Failure? optionsFailure,
    bool clearOptionsFailure = false,
    SubscriptionUpgradeOptionsEntity? optionsEntity,
    SubscriptionUpgradeOptionEntity? selectedOption,
    SubscriptionUpgradePaymentMethodEntity? selectedPaymentMethod,
    bool? isLoadingSummary,
    Failure? summaryFailure,
    bool clearSummaryFailure = false,
    SubscriptionUpgradeSummaryEntity? upgradeSummary,
    RestaurantTierUpgradeEntity? uiData,
    bool? isSubmitting,
    Failure? submitFailure,
    bool clearSubmitFailure = false,
    SubscriptionUpgradeRequestResultEntity? upgradeRequestResult,
    bool clearUpgradeRequestResult = false,
    bool? isPollingStatus,
    Failure? statusFailure,
    bool clearStatusFailure = false,
    SubscriptionUpgradeStatusEntity? upgradeStatus,
    bool? isUpgradeSuccess,
    bool? isUpgradeFailed,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RestaurantTierUpgradeState(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      programName: programName ?? this.programName,
      bundleName: bundleName ?? this.bundleName,
      isLoadingOptions: isLoadingOptions ?? this.isLoadingOptions,
      optionsFailure: clearOptionsFailure
          ? null
          : (optionsFailure ?? this.optionsFailure),
      optionsEntity: optionsEntity ?? this.optionsEntity,
      selectedOption: selectedOption ?? this.selectedOption,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      isLoadingSummary: isLoadingSummary ?? this.isLoadingSummary,
      summaryFailure: clearSummaryFailure
          ? null
          : (summaryFailure ?? this.summaryFailure),
      upgradeSummary: upgradeSummary ?? this.upgradeSummary,
      uiData: uiData ?? this.uiData,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitFailure: clearSubmitFailure
          ? null
          : (submitFailure ?? this.submitFailure),
      upgradeRequestResult: clearUpgradeRequestResult
          ? null
          : (upgradeRequestResult ?? this.upgradeRequestResult),
      isPollingStatus: isPollingStatus ?? this.isPollingStatus,
      statusFailure: clearStatusFailure
          ? null
          : (statusFailure ?? this.statusFailure),
      upgradeStatus: upgradeStatus ?? this.upgradeStatus,
      isUpgradeSuccess: isUpgradeSuccess ?? this.isUpgradeSuccess,
      isUpgradeFailed: isUpgradeFailed ?? this.isUpgradeFailed,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
