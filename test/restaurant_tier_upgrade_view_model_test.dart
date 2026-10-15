import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/repo/restaurant_tier_upgrade_repository.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/create_subscription_upgrade_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_options_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_status_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';

void main() {
  test('submits the selected upgrade payment method id', () async {
    final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
    final viewModel = RestaurantTierUpgradeViewModel(
      GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
      GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
      CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
      GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
      GetCurrentCustomerSubscriptionUseCase(
        _SubscriptionBillingRepositoryFake(),
      ),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(
      InitUpgradeConfirmationEvent(
        RestaurantTierUpgradeConfirmationArgs(
          subscriptionId: 'sub-1',
          selectedOption: _platinumOption,
          optionsEntity: _upgradeOptions,
        ),
      ),
    );
    viewModel.doIntent(
      const SelectUpgradePaymentMethodEvent(_payzahPaymentMethod),
    );

    viewModel.doIntent(const SubmitUpgradeRequestEvent());
    await Future<void>.delayed(Duration.zero);

    expect(upgradeRepository.submittedRequest?.paymentMethodId, 3);
  });

  test(
    'verifies upgrade status with the subscription id from web view args',
    () async {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(
          _SubscriptionBillingRepositoryFake(),
        ),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        const VerifyUpgradeStatusEvent(
          subscriptionId: 'sub-from-web-view',
          upgradeId: 'upgrade-from-web-view',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(upgradeRepository.statusSubscriptionId, 'sub-from-web-view');
      expect(upgradeRepository.statusUpgradeId, 'upgrade-from-web-view');
    },
  );

  test('loads upgrade summary for the selected target tier', () async {
    final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
    final viewModel = RestaurantTierUpgradeViewModel(
      GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
      GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
      CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
      GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
      GetCurrentCustomerSubscriptionUseCase(
        _SubscriptionBillingRepositoryFake(),
      ),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(
      InitUpgradeConfirmationEvent(
        RestaurantTierUpgradeConfirmationArgs(
          subscriptionId: 'sub-1',
          selectedOption: _platinumOption,
          optionsEntity: _upgradeOptions,
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(upgradeRepository.summarySubscriptionId, 'sub-1');
    expect(upgradeRepository.summaryTargetTier, 'Platinum');
    expect(viewModel.state.upgradeSummary?.priceDifference, 16.0);
  });

  test(
    'duplicate submit dispatches only one create request while in-flight',
    () async {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
      final completer =
          Completer<ApiResult<SubscriptionUpgradeRequestResultEntity>>();
      upgradeRepository.customCreateRequest = () => completer.future;

      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(
          _SubscriptionBillingRepositoryFake(),
        ),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        InitUpgradeConfirmationEvent(
          RestaurantTierUpgradeConfirmationArgs(
            subscriptionId: 'sub-1',
            selectedOption: _platinumOption,
            optionsEntity: _upgradeOptions,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.doIntent(const SubmitUpgradeRequestEvent());
      viewModel.doIntent(const SubmitUpgradeRequestEvent());
      await Future<void>.delayed(Duration.zero);

      expect(upgradeRepository.createRequestCallCount, 1);

      completer.complete(
        ApiSuccessResult(
          data: const SubscriptionUpgradeRequestResultEntity(
            upgradeId: 'upgrade-1',
            subscriptionId: 'sub-1',
            fromTier: 'Basic',
            toTier: 'Platinum',
            amount: 15.25,
            currencyCode: 'KWD',
            isPaid: true,
            status: 'Paid',
            remainingServiceDays: 12,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.isUpgradeSuccess, isTrue);
    },
  );

  test(
    'close during request prevents emits after close and cleans up safely',
    () async {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
      final completer =
          Completer<ApiResult<SubscriptionUpgradeOptionsEntity>>();
      upgradeRepository.customGetOptions = () => completer.future;

      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(
          _SubscriptionBillingRepositoryFake(),
        ),
      );

      viewModel.doIntent(
        const LoadUpgradeOptionsEvent(subscriptionId: 'sub-1'),
      );
      await Future<void>.delayed(Duration.zero);

      await viewModel.close();

      completer.complete(ApiSuccessResult(data: _upgradeOptions));
      await Future<void>.delayed(Duration.zero);
    },
  );

  test(
    'duplicate verify status while in-flight starts only one polling sequence',
    () async {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
      final completer = Completer<ApiResult<SubscriptionUpgradeStatusEntity>>();
      upgradeRepository.customGetStatus = () => completer.future;

      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(
          _SubscriptionBillingRepositoryFake(),
        ),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        const VerifyUpgradeStatusEvent(
          subscriptionId: 'sub-1',
          upgradeId: 'upgrade-1',
        ),
      );
      viewModel.doIntent(
        const VerifyUpgradeStatusEvent(
          subscriptionId: 'sub-1',
          upgradeId: 'upgrade-1',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(upgradeRepository.statusCallCount, 1);

      completer.complete(
        ApiSuccessResult(
          data: const SubscriptionUpgradeStatusEntity(
            upgradeId: 'upgrade-1',
            subscriptionId: 'sub-1',
            fromTier: 'Basic',
            toTier: 'Platinum',
            amount: 15.25,
            currencyCode: 'KWD',
            status: 'Paid',
            isPaid: true,
            isFailed: false,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.isUpgradeSuccess, isTrue);
    },
  );

  test(
    'terminal failure during poll prevents late success result from overriding failure',
    () async {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
      final completer = Completer<ApiResult<SubscriptionUpgradeStatusEntity>>();
      upgradeRepository.customGetStatus = () => completer.future;

      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(
          _SubscriptionBillingRepositoryFake(),
        ),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        const VerifyUpgradeStatusEvent(
          subscriptionId: 'sub-1',
          upgradeId: 'upgrade-1',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.doIntent(const MarkUpgradeFailedEvent('Payment cancelled'));
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isUpgradeFailed, isTrue);

      completer.complete(
        ApiSuccessResult(
          data: const SubscriptionUpgradeStatusEntity(
            upgradeId: 'upgrade-1',
            subscriptionId: 'sub-1',
            fromTier: 'Basic',
            toTier: 'Platinum',
            amount: 15.25,
            currencyCode: 'KWD',
            status: 'Paid',
            isPaid: true,
            isFailed: false,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isUpgradeFailed, isTrue);
      expect(viewModel.state.isUpgradeSuccess, isFalse);
    },
  );

  test(
    'retry after API error succeeds and in-flight guard is properly released',
    () async {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
      int attempts = 0;
      upgradeRepository.customGetStatus = () async {
        attempts++;
        if (attempts == 1) {
          return ApiErrorResult(failure: MockFailure('network error'));
        }
        return ApiSuccessResult(
          data: const SubscriptionUpgradeStatusEntity(
            upgradeId: 'upgrade-1',
            subscriptionId: 'sub-1',
            fromTier: 'Basic',
            toTier: 'Platinum',
            amount: 15.25,
            currencyCode: 'KWD',
            status: 'Paid',
            isPaid: true,
            isFailed: false,
          ),
        );
      };

      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(
          _SubscriptionBillingRepositoryFake(),
        ),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        const VerifyUpgradeStatusEvent(
          subscriptionId: 'sub-1',
          upgradeId: 'upgrade-1',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.statusFailure, isNotNull);
      expect(viewModel.state.isPollingStatus, isFalse);

      viewModel.doIntent(
        const VerifyUpgradeStatusEvent(
          subscriptionId: 'sub-1',
          upgradeId: 'upgrade-1',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isUpgradeSuccess, isTrue);
      expect(viewModel.state.statusFailure, isNull);
    },
  );

  test(
    'selecting the same tier or payment method is a no-op without extra emissions',
    () async {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(
          _SubscriptionBillingRepositoryFake(),
        ),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        const LoadUpgradeOptionsEvent(subscriptionId: 'sub-1'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedOption, isNull);

      viewModel.doIntent(const SelectTierOptionEvent(_platinumOption));
      await Future<void>.delayed(Duration.zero);
      expect(
        viewModel.state.selectedOption?.targetTier,
        _platinumOption.targetTier,
      );

      int emissions = 0;
      final subscription = viewModel.stream.listen((_) => emissions++);

      viewModel.doIntent(const SelectTierOptionEvent(_platinumOption));
      await Future<void>.delayed(Duration.zero);

      expect(emissions, 0);

      viewModel.doIntent(
        InitUpgradeConfirmationEvent(
          RestaurantTierUpgradeConfirmationArgs(
            subscriptionId: 'sub-1',
            selectedOption: _platinumOption,
            optionsEntity: _upgradeOptions,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final selectedMethod = viewModel.state.selectedPaymentMethod;
      expect(selectedMethod, isNotNull);

      emissions = 0;
      viewModel.doIntent(SelectUpgradePaymentMethodEvent(selectedMethod!));
      await Future<void>.delayed(Duration.zero);

      expect(emissions, 0);
      await subscription.cancel();
    },
  );

  test(
    'stale options request completion does not overwrite newer request state',
    () async {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
      final completerA =
          Completer<ApiResult<SubscriptionUpgradeOptionsEntity>>();
      final completerB =
          Completer<ApiResult<SubscriptionUpgradeOptionsEntity>>();
      int callCount = 0;
      upgradeRepository.customGetOptions = () {
        callCount++;
        return callCount == 1 ? completerA.future : completerB.future;
      };

      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(
          _SubscriptionBillingRepositoryFake(),
        ),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        const LoadUpgradeOptionsEvent(subscriptionId: 'sub-old'),
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.doIntent(
        const LoadUpgradeOptionsEvent(subscriptionId: 'sub-new'),
      );
      await Future<void>.delayed(Duration.zero);

      const optionsNew = SubscriptionUpgradeOptionsEntity(
        canUpgrade: true,
        currentTier: 'Basic',
        remainingServiceDays: 20,
        totalServiceDays: 20,
        upgradeEndpoint: '/sub-new',
        options: [_platinumOption],
      );

      completerB.complete(const ApiSuccessResult(data: optionsNew));
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.subscriptionId, 'sub-new');
      expect(viewModel.state.optionsEntity?.upgradeEndpoint, '/sub-new');

      const optionsOld = SubscriptionUpgradeOptionsEntity(
        canUpgrade: true,
        currentTier: 'Basic',
        remainingServiceDays: 5,
        totalServiceDays: 5,
        upgradeEndpoint: '/sub-old',
        options: [_platinumOption],
      );

      completerA.complete(const ApiSuccessResult(data: optionsOld));
      await Future<void>.delayed(Duration.zero);

      // Still sub-new!
      expect(viewModel.state.subscriptionId, 'sub-new');
      expect(viewModel.state.optionsEntity?.upgradeEndpoint, '/sub-new');
    },
  );
}

class MockFailure extends Failure {
  MockFailure(String message) : super(errorMessage: message);
}

const _platinumOption = SubscriptionUpgradeOptionEntity(
  targetTier: 'Platinum',
  tierNameAr: 'بلاتينيوم',
  tierNameEn: 'Platinum',
  isCurrent: false,
  selectable: true,
  accessibleRestaurantCount: 39,
  currentRemainingCredit: 67.75,
  targetRemainingPrice: 83,
  gatewayRecovery: 2.225,
  priceDifference: 15.25,
  currencyCode: 'KWD',
);

const _payzahPaymentMethod = SubscriptionUpgradePaymentMethodEntity(
  id: 3,
  code: 'PAYZAH',
  title: 'Payzah',
  integrationType: 'HOSTED',
  serviceCharge: 1.153,
  totalAmount: 15.25,
  currencyCode: 'KWD',
  isAvailable: true,
);

const _upgradeOptions = SubscriptionUpgradeOptionsEntity(
  canUpgrade: true,
  currentTier: 'Basic',
  remainingServiceDays: 12,
  totalServiceDays: 12,
  upgradeEndpoint: '/api/v1/customer/subscriptions/sub-1/upgrade-requests',
  options: [_platinumOption],
  paymentMethods: [_payzahPaymentMethod],
);

class _RestaurantTierUpgradeRepositoryFake
    implements RestaurantTierUpgradeRepository {
  SubscriptionUpgradeRequestEntity? submittedRequest;
  String? statusSubscriptionId;
  String? statusUpgradeId;
  String? summarySubscriptionId;
  String? summaryTargetTier;

  int createRequestCallCount = 0;
  int statusCallCount = 0;
  int optionsCallCount = 0;

  Future<ApiResult<SubscriptionUpgradeRequestResultEntity>> Function()?
  customCreateRequest;
  Future<ApiResult<SubscriptionUpgradeStatusEntity>> Function()?
  customGetStatus;
  Future<ApiResult<SubscriptionUpgradeOptionsEntity>> Function()?
  customGetOptions;

  @override
  Future<ApiResult<SubscriptionUpgradeSummaryEntity>> getUpgradeSummary(
    String subscriptionId,
    String targetTier,
  ) async {
    summarySubscriptionId = subscriptionId;
    summaryTargetTier = targetTier;
    return const ApiSuccessResult(data: _upgradeSummary);
  }

  @override
  Future<ApiResult<SubscriptionUpgradeOptionsEntity>> getUpgradeOptions(
    String subscriptionId,
  ) async {
    optionsCallCount++;
    if (customGetOptions != null) {
      return customGetOptions!();
    }
    return const ApiSuccessResult(data: _upgradeOptions);
  }

  @override
  Future<ApiResult<SubscriptionUpgradeRequestResultEntity>>
  createUpgradeRequest(
    String subscriptionId,
    SubscriptionUpgradeRequestEntity request,
  ) async {
    createRequestCallCount++;
    submittedRequest = request;
    if (customCreateRequest != null) {
      return customCreateRequest!();
    }
    return const ApiSuccessResult(
      data: SubscriptionUpgradeRequestResultEntity(
        upgradeId: 'upgrade-1',
        subscriptionId: 'sub-1',
        fromTier: 'Basic',
        toTier: 'Platinum',
        amount: 15.25,
        currencyCode: 'KWD',
        paymentUrl: 'https://example.com/pay',
        isPaid: false,
        status: 'Submitted',
        remainingServiceDays: 12,
      ),
    );
  }

  @override
  Future<ApiResult<SubscriptionUpgradeStatusEntity>> getUpgradeStatus(
    String subscriptionId,
    String upgradeId,
  ) async {
    statusCallCount++;
    statusSubscriptionId = subscriptionId;
    statusUpgradeId = upgradeId;
    if (customGetStatus != null) {
      return customGetStatus!();
    }
    return const ApiSuccessResult(
      data: SubscriptionUpgradeStatusEntity(
        upgradeId: 'upgrade-1',
        subscriptionId: 'sub-1',
        fromTier: 'Basic',
        toTier: 'Platinum',
        amount: 15.25,
        currencyCode: 'KWD',
        status: 'Paid',
        isPaid: true,
        isFailed: false,
      ),
    );
  }
}

const _upgradeSummary = SubscriptionUpgradeSummaryEntity(
  subscriptionId: 'sub-1',
  currentTier: SubscriptionUpgradeTierEntity(
    tier: 'Basic',
    tierNameAr: 'أساسي',
    tierNameEn: 'Basic',
    accessibleRestaurantCount: 21,
  ),
  targetTier: SubscriptionUpgradeTierEntity(
    tier: 'Platinum',
    tierNameAr: 'بلاتينيوم',
    tierNameEn: 'Platinum',
    accessibleRestaurantCount: 39,
  ),
  currentTierRestaurants: [],
  targetTierRestaurants: [],
  newlyAddedRestaurants: [],
  effectiveFromDate: '2026-09-10',
  effectiveNoticeAr: 'يبدأ التفعيل بعد 72 ساعة.',
  effectiveNoticeEn: 'Activation starts after 72 hours.',
  restaurantRepetition: SubscriptionUpgradeRestaurantRepetitionEntity(
    limit: 3,
    restaurantCount: 39,
    durationDays: 12,
  ),
  currentRemainingCredit: 70.5,
  targetRemainingPrice: 86.5,
  priceDifference: 16.0,
  currencyCode: 'KWD',
  remainingServiceDays: 12,
  totalServiceDays: 26,
  paymentMethods: [_payzahPaymentMethod],
  upgradeEndpoint: '/api/v1/customer/subscriptions/sub-1/upgrade-requests',
);

class _SubscriptionBillingRepositoryFake
    implements SubscriptionBillingRepository {
  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>>
  getCurrentCustomerSubscription() async {
    return const ApiSuccessResult(
      data: SubscriptionBillingCurrentEntity(emptyStateCode: ''),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
