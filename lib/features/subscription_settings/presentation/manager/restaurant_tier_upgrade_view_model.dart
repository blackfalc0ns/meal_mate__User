import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/restaurant_tier_upgrade_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/create_subscription_upgrade_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_upgrade_options_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_upgrade_status_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_state.dart';

@injectable
class RestaurantTierUpgradeViewModel
    extends Cubit<RestaurantTierUpgradeState> {
  RestaurantTierUpgradeViewModel(
    this._getSubscriptionUpgradeOptionsUseCase,
    this._createSubscriptionUpgradeRequestUseCase,
    this._getSubscriptionUpgradeStatusUseCase,
    this._getCurrentCustomerSubscriptionUseCase,
  ) : super(const RestaurantTierUpgradeState());

  final GetSubscriptionUpgradeOptionsUseCase
  _getSubscriptionUpgradeOptionsUseCase;
  final CreateSubscriptionUpgradeRequestUseCase
  _createSubscriptionUpgradeRequestUseCase;
  final GetSubscriptionUpgradeStatusUseCase
  _getSubscriptionUpgradeStatusUseCase;
  final GetCurrentCustomerSubscriptionUseCase
  _getCurrentCustomerSubscriptionUseCase;

  void doIntent(RestaurantTierUpgradeEvent event) {
    switch (event) {
      case InitUpgradeConfirmationEvent():
        _initConfirmation(event.args);
      case LoadUpgradeOptionsEvent():
        _load(event.subscriptionId);
      case SelectTierOptionEvent():
        _selectOption(event.option);
      case SubmitUpgradeRequestEvent():
        _submit(
          paymentMethodId: event.paymentMethodId,
          reason: event.reason,
        );
      case VerifyUpgradeStatusEvent():
        _verifyStatus(event.upgradeId);
      case MarkUpgradeFailedEvent():
        emit(
          state.copyWith(
            isUpgradeFailed: true,
            isPollingStatus: false,
            isSubmitting: false,
            errorMessage: event.errorMessage,
          ),
        );
      case ResetUpgradeStateEvent():
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

  void _initConfirmation(RestaurantTierUpgradeConfirmationArgs args) {
    emit(
      state.copyWith(
        subscriptionId: args.subscriptionId,
        programName: args.programName,
        bundleName: args.bundleName,
        optionsEntity: args.optionsEntity,
        selectedOption: args.selectedOption,
        uiData: RestaurantTierUpgradeMapper.toUiEntity(
          optionsEntity: args.optionsEntity,
          selectedOption: args.selectedOption,
          programName: args.programName,
          bundleName: args.bundleName,
        ),
      ),
    );
  }

  Future<void> _load(String? subscriptionId) async {
    emit(
      state.copyWith(
        isLoadingOptions: true,
        clearOptionsFailure: true,
        clearSubmitFailure: true,
        clearStatusFailure: true,
        isUpgradeSuccess: false,
        isUpgradeFailed: false,
        clearErrorMessage: true,
      ),
    );

    String subId = subscriptionId ?? state.subscriptionId;
    String? progName = state.programName;
    String? bndlName = state.bundleName;

    if (subId.isEmpty) {
      final currentSubResult = await _getCurrentCustomerSubscriptionUseCase();
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
      emit(
        state.copyWith(
          isLoadingOptions: false,
          errorMessage: 'subscription.not_found',
        ),
      );
      return;
    }

    final result = await _getSubscriptionUpgradeOptionsUseCase(subId);

    switch (result) {
      case ApiSuccessResult():
        final optionsEntity = result.data;
        SubscriptionUpgradeOptionEntity? selected;
        for (final opt in optionsEntity.options) {
          if (opt.selectable) {
            selected = opt;
            break;
          }
        }
        if (selected == null && optionsEntity.options.isNotEmpty) {
          selected = optionsEntity.options.first;
        }

        final uiData = selected != null
            ? RestaurantTierUpgradeMapper.toUiEntity(
                optionsEntity: optionsEntity,
                selectedOption: selected,
                programName: progName,
                bundleName: bndlName,
              )
            : null;

        emit(
          state.copyWith(
            subscriptionId: subId,
            programName: progName,
            bundleName: bndlName,
            isLoadingOptions: false,
            optionsEntity: optionsEntity,
            selectedOption: selected,
            uiData: uiData,
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

    final uiData = RestaurantTierUpgradeMapper.toUiEntity(
      optionsEntity: state.optionsEntity!,
      selectedOption: option,
      programName: state.programName,
      bundleName: state.bundleName,
    );

    emit(
      state.copyWith(
        selectedOption: option,
        uiData: uiData,
      ),
    );
  }

  Future<void> _submit({int? paymentMethodId, String? reason}) async {
    final subId = state.subscriptionId;
    final selected = state.selectedOption;

    if (subId.isEmpty || selected == null) return;

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
      callbackUrl: 'mealmate://payment/success',
      errorUrl: 'mealmate://payment/error',
      paymentMethodId: paymentMethodId ?? 1,
      reason: reason,
    );

    final result = await _createSubscriptionUpgradeRequestUseCase(
      subscriptionId: subId,
      request: request,
    );

    switch (result) {
      case ApiSuccessResult():
        final requestResult = result.data;
        if (requestResult.isPaid ||
            (requestResult.paymentUrl == null ||
                requestResult.paymentUrl!.isEmpty)) {
          // Applied immediately (e.g. 0 amount due)
          await _syncCurrentSubscriptionCache();
          emit(
            state.copyWith(
              isSubmitting: false,
              isUpgradeSuccess: true,
              upgradeRequestResult: requestResult,
              clearSubmitFailure: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isSubmitting: false,
              upgradeRequestResult: requestResult,
              clearSubmitFailure: true,
            ),
          );
        }
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSubmitting: false,
            submitFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _verifyStatus(String upgradeId) async {
    final subId = state.subscriptionId;
    if (subId.isEmpty || upgradeId.isEmpty) return;

    emit(
      state.copyWith(
        isPollingStatus: true,
        isUpgradeSuccess: false,
        isUpgradeFailed: false,
        clearStatusFailure: true,
      ),
    );

    for (final delay in _pollingBackoff()) {
      if (delay != Duration.zero) {
        await Future<void>.delayed(delay);
      }

      final result = await _getSubscriptionUpgradeStatusUseCase(
        subscriptionId: subId,
        upgradeId: upgradeId,
      );

      switch (result) {
        case ApiSuccessResult():
          final status = result.data;
          if (status.isPaid) {
            await _syncCurrentSubscriptionCache();
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

    emit(state.copyWith(isPollingStatus: false));
  }

  Future<void> _syncCurrentSubscriptionCache() async {
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
}
