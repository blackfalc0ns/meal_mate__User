import 'package:flutter/foundation.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/models/restaurant_tier_option_view_data.dart';

@immutable
class RestaurantTierUpgradeState {
  const RestaurantTierUpgradeState({
    this.subscriptionId = '',
    this.programName,
    this.bundleName,
    this.isLoadingOptions = false,
    this.optionsEntity,
    this.preparedOptions,
    this.selectedOption,
    this.isLoadingSummary = false,
    this.upgradeSummary,
    this.selectedPaymentMethod,
    this.isSubmitting = false,
    this.upgradeRequestResult,
    this.isPollingStatus = false,
    this.upgradeStatus,
    this.isUpgradeSuccess = false,
    this.isUpgradeFailed = false,
    this.optionsFailure,
    this.summaryFailure,
    this.submitFailure,
    this.statusFailure,
    this.errorMessage,
  });

  final String subscriptionId;
  final String? programName;
  final String? bundleName;
  final bool isLoadingOptions;
  final SubscriptionUpgradeOptionsEntity? optionsEntity;
  final List<RestaurantTierOptionViewData>? preparedOptions;
  final SubscriptionUpgradeOptionEntity? selectedOption;
  final bool isLoadingSummary;
  final SubscriptionUpgradeSummaryEntity? upgradeSummary;
  final SubscriptionUpgradePaymentMethodEntity? selectedPaymentMethod;
  final bool isSubmitting;
  final SubscriptionUpgradeRequestResultEntity? upgradeRequestResult;
  final bool isPollingStatus;
  final SubscriptionUpgradeStatusEntity? upgradeStatus;
  final bool isUpgradeSuccess;
  final bool isUpgradeFailed;
  final Failure? optionsFailure;
  final Failure? summaryFailure;
  final Failure? submitFailure;
  final Failure? statusFailure;
  final String? errorMessage;

  RestaurantTierUpgradeState copyWith({
    String? subscriptionId,
    String? programName,
    String? bundleName,
    bool? isLoadingOptions,
    SubscriptionUpgradeOptionsEntity? optionsEntity,
    List<RestaurantTierOptionViewData>? preparedOptions,
    SubscriptionUpgradeOptionEntity? selectedOption,
    bool? isLoadingSummary,
    SubscriptionUpgradeSummaryEntity? upgradeSummary,
    SubscriptionUpgradePaymentMethodEntity? selectedPaymentMethod,
    bool? isSubmitting,
    SubscriptionUpgradeRequestResultEntity? upgradeRequestResult,
    bool? isPollingStatus,
    SubscriptionUpgradeStatusEntity? upgradeStatus,
    bool? isUpgradeSuccess,
    bool? isUpgradeFailed,
    Failure? optionsFailure,
    Failure? summaryFailure,
    Failure? submitFailure,
    Failure? statusFailure,
    String? errorMessage,
    bool clearOptionsFailure = false,
    bool clearSummaryFailure = false,
    bool clearSubmitFailure = false,
    bool clearStatusFailure = false,
    bool clearErrorMessage = false,
    bool clearUpgradeRequestResult = false,
    bool clearSelectedOption = false,
  }) {
    return RestaurantTierUpgradeState(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      programName: programName ?? this.programName,
      bundleName: bundleName ?? this.bundleName,
      isLoadingOptions: isLoadingOptions ?? this.isLoadingOptions,
      optionsEntity: optionsEntity ?? this.optionsEntity,
      preparedOptions: preparedOptions ?? this.preparedOptions,
      selectedOption: clearSelectedOption
          ? null
          : (selectedOption ?? this.selectedOption),
      isLoadingSummary: isLoadingSummary ?? this.isLoadingSummary,
      upgradeSummary: upgradeSummary ?? this.upgradeSummary,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      upgradeRequestResult: clearUpgradeRequestResult
          ? null
          : (upgradeRequestResult ?? this.upgradeRequestResult),
      isPollingStatus: isPollingStatus ?? this.isPollingStatus,
      upgradeStatus: upgradeStatus ?? this.upgradeStatus,
      isUpgradeSuccess: isUpgradeSuccess ?? this.isUpgradeSuccess,
      isUpgradeFailed: isUpgradeFailed ?? this.isUpgradeFailed,
      optionsFailure:
          clearOptionsFailure ? null : (optionsFailure ?? this.optionsFailure),
      summaryFailure:
          clearSummaryFailure ? null : (summaryFailure ?? this.summaryFailure),
      submitFailure:
          clearSubmitFailure ? null : (submitFailure ?? this.submitFailure),
      statusFailure:
          clearStatusFailure ? null : (statusFailure ?? this.statusFailure),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantTierUpgradeState &&
          runtimeType == other.runtimeType &&
          subscriptionId == other.subscriptionId &&
          programName == other.programName &&
          bundleName == other.bundleName &&
          isLoadingOptions == other.isLoadingOptions &&
          optionsEntity == other.optionsEntity &&
          listEquals(preparedOptions, other.preparedOptions) &&
          selectedOption == other.selectedOption &&
          isLoadingSummary == other.isLoadingSummary &&
          upgradeSummary == other.upgradeSummary &&
          selectedPaymentMethod == other.selectedPaymentMethod &&
          isSubmitting == other.isSubmitting &&
          upgradeRequestResult == other.upgradeRequestResult &&
          isPollingStatus == other.isPollingStatus &&
          upgradeStatus == other.upgradeStatus &&
          isUpgradeSuccess == other.isUpgradeSuccess &&
          isUpgradeFailed == other.isUpgradeFailed &&
          optionsFailure == other.optionsFailure &&
          summaryFailure == other.summaryFailure &&
          submitFailure == other.submitFailure &&
          statusFailure == other.statusFailure &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        subscriptionId,
        programName,
        bundleName,
        isLoadingOptions,
        optionsEntity,
        preparedOptions == null ? 0 : Object.hashAll(preparedOptions!),
        selectedOption,
        isLoadingSummary,
        upgradeSummary,
        selectedPaymentMethod,
        isSubmitting,
        upgradeRequestResult,
        isPollingStatus,
        upgradeStatus,
        isUpgradeSuccess,
        isUpgradeFailed,
        optionsFailure,
        summaryFailure,
        submitFailure,
        Object.hash(statusFailure, errorMessage),
      );
}
