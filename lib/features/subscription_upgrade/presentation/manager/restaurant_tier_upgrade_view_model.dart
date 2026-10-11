import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/create_subscription_upgrade_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_options_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_status_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/models/restaurant_tier_option_view_data.dart';

@injectable
class RestaurantTierUpgradeViewModel extends Cubit<RestaurantTierUpgradeState> {
  RestaurantTierUpgradeViewModel(
    this._getSubscriptionUpgradeOptionsUseCase,
    this._getSubscriptionUpgradeSummaryUseCase,
    this._createSubscriptionUpgradeRequestUseCase,
    this._getSubscriptionUpgradeStatusUseCase,
    this._getCurrentCustomerSubscriptionUseCase,
  ) : super(const RestaurantTierUpgradeState());

  final GetSubscriptionUpgradeOptionsUseCase
  _getSubscriptionUpgradeOptionsUseCase;
  final GetSubscriptionUpgradeSummaryUseCase
  _getSubscriptionUpgradeSummaryUseCase;
  final CreateSubscriptionUpgradeRequestUseCase
  _createSubscriptionUpgradeRequestUseCase;
  final GetSubscriptionUpgradeStatusUseCase
  _getSubscriptionUpgradeStatusUseCase;
  final GetCurrentCustomerSubscriptionUseCase
  _getCurrentCustomerSubscriptionUseCase;

  int _loadGeneration = 0;
  int _summaryGeneration = 0;
  int _pollingGeneration = 0;

  @override
  Future<void> close() {
    _loadGeneration++;
    _summaryGeneration++;
    _pollingGeneration++;
    return super.close();
  }

  Future<void> doIntent(RestaurantTierUpgradeEvent event) async {
    switch (event) {
      case InitUpgradeConfirmationEvent():
        await _initConfirmation(event.args);
      case LoadUpgradeOptionsEvent():
        _load(event.subscriptionId);
      case SelectTierOptionEvent():
        _selectOption(event.option);
      case SelectUpgradePaymentMethodEvent():
        _selectPaymentMethod(event.paymentMethod);
      case SubmitUpgradeRequestEvent():
        _submit(paymentMethodId: event.paymentMethodId, reason: event.reason);
      case VerifyUpgradeStatusEvent():
        _verifyStatus(
          subscriptionId: event.subscriptionId,
          upgradeId: event.upgradeId,
        );
      case HandleUpgradePaymentReturnEvent():
        _handlePaymentReturn(event.paymentReturn);
      case MarkUpgradeFailedEvent():
        _pollingGeneration++;
        if (!isClosed) {
          emit(
            state.copyWith(
              isUpgradeFailed: true,
              isPollingStatus: false,
              isSubmitting: false,
              errorMessage: event.errorMessage,
            ),
          );
        }
      case ResetUpgradeStateEvent():
        if (!isClosed) {
          emit(
            state.copyWith(
              isUpgradeSuccess: false,
              isUpgradeFailed: false,
              clearSubmitFailure: true,
              clearStatusFailure: true,
              clearErrorMessage: true,
            ),
          );
        }
    }
  }

  Future<void> _initConfirmation(
    RestaurantTierUpgradeConfirmationArgs args,
  ) async {
    final currentGen = ++_summaryGeneration;

    emit(
      state.copyWith(
        subscriptionId: args.subscriptionId,
        programName: args.programName,
        bundleName: args.bundleName,
        optionsEntity: args.optionsEntity,
        selectedOption: args.selectedOption,
        isLoadingSummary: true,
        clearSummaryFailure: true,
      ),
    );

    final result = await _getSubscriptionUpgradeSummaryUseCase(
      subscriptionId: args.subscriptionId,
      targetTier: args.selectedOption.targetTier,
    );

    if (isClosed || currentGen != _summaryGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final summary = result.data;
        final selectedPaymentMethod = _defaultSummaryPaymentMethod(summary);
        final effectiveOption = _optionFromSummary(
          summary,
          args.selectedOption,
        );

        emit(
          state.copyWith(
            isLoadingSummary: false,
            upgradeSummary: summary,
            selectedPaymentMethod: selectedPaymentMethod,
            selectedOption: effectiveOption,
            clearSummaryFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingSummary: false,
            summaryFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _load(String? subscriptionId) async {
    final currentGen = ++_loadGeneration;

    emit(
      state.copyWith(
        isLoadingOptions: true,
        clearOptionsFailure: true,
        clearSummaryFailure: true,
        clearSubmitFailure: true,
        clearStatusFailure: true,
        isUpgradeSuccess: false,
        isUpgradeFailed: false,
        clearErrorMessage: true,
        clearSelectedOption: true,
      ),
    );

    String subId = subscriptionId ?? state.subscriptionId;
    String? progName = state.programName;
    String? bndlName = state.bundleName;

    if (subId.isEmpty) {
      final currentSubResult = await _getCurrentCustomerSubscriptionUseCase();
      if (isClosed || currentGen != _loadGeneration) return;

      switch (currentSubResult) {
        case ApiSuccessResult(:final data):
          final currentSub = data.subscription;
          if (currentSub != null) {
            subId = currentSub.subscriptionId;
            progName = currentSub.programNameAr.isNotEmpty
                ? currentSub.programNameAr
                : currentSub.programNameEn;
            bndlName = currentSub.bundleNameAr.isNotEmpty
                ? currentSub.bundleNameAr
                : currentSub.bundleNameEn;
          }
        case ApiErrorResult():
          break;
      }
    }

    if (subId.isEmpty) {
      if (!isClosed && currentGen == _loadGeneration) {
        emit(
          state.copyWith(
            isLoadingOptions: false,
            errorMessage: 'subscription.not_found',
          ),
        );
      }
      return;
    }

    final result = await _getSubscriptionUpgradeOptionsUseCase(subId);
    if (isClosed || currentGen != _loadGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final optionsEntity = result.data;
        final preparedOptions = optionsEntity.options
            .asMap()
            .entries
            .map((entry) {
              return RestaurantTierOptionViewData.fromEntity(
                option: entry.value,
                index: entry.key,
              );
            })
            .toList(growable: false);

        emit(
          state.copyWith(
            subscriptionId: subId,
            programName: progName,
            bundleName: bndlName,
            isLoadingOptions: false,
            optionsEntity: optionsEntity,
            clearSelectedOption: true,
            preparedOptions: preparedOptions,
            clearOptionsFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            subscriptionId: subId,
            programName: progName,
            bundleName: bndlName,
            isLoadingOptions: false,
            optionsFailure: result.failure,
          ),
        );
    }
  }

  void _selectOption(SubscriptionUpgradeOptionEntity option) {
    if (state.optionsEntity == null) return;
    if (!option.selectable) return;
    if (state.selectedOption?.targetTier == option.targetTier) return;
    emit(state.copyWith(selectedOption: option));
  }

  void _selectPaymentMethod(
    SubscriptionUpgradePaymentMethodEntity paymentMethod,
  ) {
    if (!paymentMethod.isAvailable) return;
    if (state.selectedPaymentMethod?.id == paymentMethod.id) return;
    emit(state.copyWith(selectedPaymentMethod: paymentMethod));
  }

  Future<void> _submit({int? paymentMethodId, String? reason}) async {
    if (isClosed || state.isSubmitting || state.isReviewRequired) return;

    final subId = state.subscriptionId;
    final selected = state.selectedOption;

    if (subId.isEmpty || selected == null) return;

    final selectedMethodId = paymentMethodId ?? state.selectedPaymentMethod?.id;
    if (selectedMethodId == null && (selected.priceDifference) > 0) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'يرجى اختيار طريقة الدفع أولاً',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearSubmitFailure: true,
        clearStatusFailure: true,
        clearUpgradeRequestResult: true,
        isUpgradeSuccess: false,
        isUpgradeFailed: false,
        clearErrorMessage: true,
      ),
    );

    final request = SubscriptionUpgradeRequestEntity(
      targetTier: selected.targetTier,
      callbackUrl: 'mealmate://checkout/success',
      errorUrl: 'mealmate://checkout/error',
      paymentMethodId: selectedMethodId,
      reason: reason,
    );

    final result = await _createSubscriptionUpgradeRequestUseCase(
      subscriptionId: subId,
      request: request,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final requestResult = result.data;
        final isExplicitlyApplied =
            requestResult.isPaid ||
            (requestResult.status.toLowerCase() == 'applied' &&
                requestResult.amount == 0.0);

        if (isExplicitlyApplied) {
          await _syncCurrentSubscriptionCache();
          if (isClosed) return;
          emit(
            state.copyWith(
              isSubmitting: false,
              isUpgradeSuccess: true,
              upgradeRequestResult: requestResult,
              clearSubmitFailure: true,
            ),
          );
        } else if (requestResult.paymentUrl != null &&
            requestResult.paymentUrl!.isNotEmpty) {
          emit(
            state.copyWith(
              isSubmitting: false,
              upgradeRequestResult: requestResult,
              clearSubmitFailure: true,
            ),
          );
        } else {
          // Empty paymentUrl and not paid -> Unresolved error, not success!
          emit(
            state.copyWith(
              isSubmitting: false,
              isUpgradeFailed: true,
              errorMessage: 'حدث خطأ في معالجة طلب الترقية',
              upgradeRequestResult: requestResult,
            ),
          );
        }
      case ApiErrorResult():
        emit(
          state.copyWith(isSubmitting: false, submitFailure: result.failure),
        );
    }
  }

  void _handlePaymentReturn(PaymentReturn paymentReturn) {
    if (isClosed) return;

    switch (paymentReturn.destination) {
      case PaymentReturnDestination.review:
        emit(
          state.copyWith(
            isReviewRequired: true,
            attemptHandle: paymentReturn.paymentId,
          ),
        );
        final upId = state.upgradeRequestResult?.upgradeId;
        if (state.subscriptionId.isNotEmpty &&
            upId != null &&
            upId.isNotEmpty) {
          unawaited(
            _verifyStatus(
              subscriptionId: state.subscriptionId,
              upgradeId: upId,
            ),
          );
        }
      case PaymentReturnDestination.error:
        if (state.isUpgradeSuccess || state.isReviewRequired) return;
        _pollingGeneration++;
        emit(
          state.copyWith(
            isUpgradeFailed: true,
            isPollingStatus: false,
            errorMessage: 'تم إلغاء عملية الدفع',
          ),
        );
      case PaymentReturnDestination.success:
      case PaymentReturnDestination.pending:
        emit(state.copyWith(attemptHandle: paymentReturn.paymentId));
        final upId = state.upgradeRequestResult?.upgradeId;
        if (state.subscriptionId.isNotEmpty &&
            upId != null &&
            upId.isNotEmpty) {
          unawaited(
            _verifyStatus(
              subscriptionId: state.subscriptionId,
              upgradeId: upId,
            ),
          );
        }
    }
  }

  Future<void> _verifyStatus({
    required String subscriptionId,
    required String upgradeId,
  }) async {
    if (isClosed || state.isPollingStatus) return;
    if (subscriptionId.isEmpty || upgradeId.isEmpty) return;

    final currentGen = ++_pollingGeneration;

    emit(
      state.copyWith(
        isPollingStatus: true,
        isUpgradeSuccess: false,
        isUpgradeFailed: false,
        clearStatusFailure: true,
      ),
    );

    for (final delay in _pollingBackoff()) {
      if (isClosed ||
          currentGen != _pollingGeneration ||
          state.isUpgradeFailed) {
        if (!isClosed && state.isPollingStatus) {
          emit(state.copyWith(isPollingStatus: false));
        }
        return;
      }

      if (delay != Duration.zero) {
        await Future<void>.delayed(delay);
      }

      if (isClosed ||
          currentGen != _pollingGeneration ||
          state.isUpgradeFailed) {
        if (!isClosed && state.isPollingStatus) {
          emit(state.copyWith(isPollingStatus: false));
        }
        return;
      }

      final result = await _getSubscriptionUpgradeStatusUseCase(
        subscriptionId: subscriptionId,
        upgradeId: upgradeId,
      );

      if (isClosed ||
          currentGen != _pollingGeneration ||
          state.isUpgradeFailed) {
        if (!isClosed && state.isPollingStatus) {
          emit(state.copyWith(isPollingStatus: false));
        }
        return;
      }

      switch (result) {
        case ApiSuccessResult():
          final status = result.data;
          if (status.isPaid) {
            await _syncCurrentSubscriptionCache();
            if (isClosed || currentGen != _pollingGeneration) return;
            emit(
              state.copyWith(
                isPollingStatus: false,
                isUpgradeSuccess: true,
                isUpgradeFailed: false,
                upgradeStatus: status,
                clearStatusFailure: true,
              ),
            );
            return;
          }

          if (status.isFailed) {
            emit(
              state.copyWith(
                isPollingStatus: false,
                isUpgradeSuccess: false,
                isUpgradeFailed: true,
                upgradeStatus: status,
                clearStatusFailure: true,
              ),
            );
            return;
          }

          continue;
        case ApiErrorResult():
          emit(
            state.copyWith(
              isPollingStatus: false,
              statusFailure: result.failure,
            ),
          );
          return;
      }
    }

    if (!isClosed && currentGen == _pollingGeneration) {
      emit(state.copyWith(isPollingStatus: false));
    }
  }

  Future<void> _syncCurrentSubscriptionCache() async {
    if (isClosed) return;
    await _getCurrentCustomerSubscriptionUseCase();
  }

  Iterable<Duration> _pollingBackoff() sync* {
    yield Duration.zero;
    yield const Duration(seconds: 2);
    yield const Duration(seconds: 3);
    yield const Duration(seconds: 5);
    var elapsed = 10;
    while (elapsed < 60) {
      yield const Duration(seconds: 5);
      elapsed += 5;
    }
  }

  SubscriptionUpgradePaymentMethodEntity? _defaultSummaryPaymentMethod(
    SubscriptionUpgradeSummaryEntity summary,
  ) {
    for (final method in summary.paymentMethods) {
      if (method.isAvailable) return method;
    }
    return summary.paymentMethods.isEmpty ? null : summary.paymentMethods.first;
  }

  SubscriptionUpgradeOptionEntity _optionFromSummary(
    SubscriptionUpgradeSummaryEntity summary,
    SubscriptionUpgradeOptionEntity fallback,
  ) {
    return SubscriptionUpgradeOptionEntity(
      targetTier: summary.targetTier.tier,
      tierNameAr: summary.targetTier.tierNameAr,
      tierNameEn: summary.targetTier.tierNameEn,
      logoUrl: summary.targetTier.logoUrl,
      isCurrent: false,
      selectable: true,
      accessibleRestaurantCount: summary.targetTier.accessibleRestaurantCount,
      currentRemainingCredit: summary.currentRemainingCredit,
      targetRemainingPrice: summary.targetRemainingPrice,
      gatewayRecovery: 0,
      priceDifference: summary.priceDifference,
      currencyCode: summary.currencyCode.isEmpty
          ? fallback.currencyCode
          : summary.currencyCode,
    );
  }
}
