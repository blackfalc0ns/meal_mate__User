import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/repo/restaurant_tier_upgrade_repository.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/create_subscription_upgrade_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_options_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_status_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';

void main() {
  group('Upgrade Fulfillment and Zero-Payment Security Tests', () {
    test('missing paymentUrl and unpaid status does NOT trigger immediate success', () async {
      final fakeRepo = _UpgradeRepoFake();
      // Server returns empty paymentUrl and isPaid = false
      fakeRepo.createResult = const ApiSuccessResult(
        data: SubscriptionUpgradeRequestResultEntity(
          upgradeId: 'up-1',
          subscriptionId: 'sub-1',
          fromTier: 'Basic',
          toTier: 'Platinum',
          amount: 15.0,
          currencyCode: 'KWD',
          paymentUrl: '',
          isPaid: false,
          status: 'Pending',
          remainingServiceDays: 12,
        ),
      );

      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(fakeRepo),
        GetSubscriptionUpgradeSummaryUseCase(fakeRepo),
        CreateSubscriptionUpgradeRequestUseCase(fakeRepo),
        GetSubscriptionUpgradeStatusUseCase(fakeRepo),
        GetCurrentCustomerSubscriptionUseCase(_BillingRepoFake()),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        const InitUpgradeConfirmationEvent(
          RestaurantTierUpgradeConfirmationArgs(
            subscriptionId: 'sub-1',
            selectedOption: _testOption,
            optionsEntity: _testOptionsEntity,
          ),
        ),
      );
      viewModel.doIntent(
        const SelectUpgradePaymentMethodEvent(_testMethod),
      );

      viewModel.doIntent(const SubmitUpgradeRequestEvent());
      await Future<void>.delayed(Duration.zero);

      // Must NOT be successful when paymentUrl is empty and isPaid is false!
      expect(viewModel.state.isUpgradeSuccess, isFalse);
    });

    test('legitimate zero-payment upgrade with explicit isPaid: true succeeds', () async {
      final fakeRepo = _UpgradeRepoFake();
      fakeRepo.createResult = const ApiSuccessResult(
        data: SubscriptionUpgradeRequestResultEntity(
          upgradeId: 'up-free',
          subscriptionId: 'sub-1',
          fromTier: 'Basic',
          toTier: 'Gold',
          amount: 0.0,
          currencyCode: 'KWD',
          paymentUrl: '',
          isPaid: true,
          status: 'Applied',
          remainingServiceDays: 12,
        ),
      );

      final viewModel = RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(fakeRepo),
        GetSubscriptionUpgradeSummaryUseCase(fakeRepo),
        CreateSubscriptionUpgradeRequestUseCase(fakeRepo),
        GetSubscriptionUpgradeStatusUseCase(fakeRepo),
        GetCurrentCustomerSubscriptionUseCase(_BillingRepoFake()),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        const InitUpgradeConfirmationEvent(
          RestaurantTierUpgradeConfirmationArgs(
            subscriptionId: 'sub-1',
            selectedOption: _testOption,
            optionsEntity: _testOptionsEntity,
          ),
        ),
      );

      viewModel.doIntent(
        const SelectUpgradePaymentMethodEvent(_testMethod),
      );

      viewModel.doIntent(const SubmitUpgradeRequestEvent());
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isUpgradeSuccess, isTrue);
    });
  });
}

const _testOption = SubscriptionUpgradeOptionEntity(
  targetTier: 'Platinum',
  tierNameAr: 'بلاتينيوم',
  tierNameEn: 'Platinum',
  isCurrent: false,
  selectable: true,
  accessibleRestaurantCount: 30,
  currentRemainingCredit: 50,
  targetRemainingPrice: 65,
  gatewayRecovery: 0,
  priceDifference: 15,
  currencyCode: 'KWD',
);

const _testMethod = SubscriptionUpgradePaymentMethodEntity(
  id: 3,
  code: 'PAYZAH',
  title: 'Payzah',
  integrationType: 'PAYZAH_HOSTED',
  serviceCharge: 0.5,
  totalAmount: 15.5,
  currencyCode: 'KWD',
  isAvailable: true,
);

const _testOptionsEntity = SubscriptionUpgradeOptionsEntity(
  canUpgrade: true,
  currentTier: 'Basic',
  remainingServiceDays: 12,
  totalServiceDays: 12,
  upgradeEndpoint: '/api/v1/customer/subscriptions/sub-1/upgrade-requests',
  options: [_testOption],
  paymentMethods: [_testMethod],
);

const _testSummaryEntity = SubscriptionUpgradeSummaryEntity(
  subscriptionId: 'sub-1',
  currentTier: SubscriptionUpgradeTierEntity(
    tier: 'Basic',
    tierNameAr: 'أساسي',
    tierNameEn: 'Basic',
    accessibleRestaurantCount: 10,
  ),
  targetTier: SubscriptionUpgradeTierEntity(
    tier: 'Platinum',
    tierNameAr: 'بلاتينيوم',
    tierNameEn: 'Platinum',
    accessibleRestaurantCount: 20,
  ),
  currentTierRestaurants: [],
  targetTierRestaurants: [],
  newlyAddedRestaurants: [],
  effectiveFromDate: '2026-10-10',
  effectiveNoticeAr: '',
  effectiveNoticeEn: '',
  restaurantRepetition: SubscriptionUpgradeRestaurantRepetitionEntity(
    limit: 1,
    restaurantCount: 10,
    durationDays: 30,
  ),
  currentRemainingCredit: 50,
  targetRemainingPrice: 65,
  priceDifference: 15,
  currencyCode: 'KWD',
  remainingServiceDays: 12,
  totalServiceDays: 12,
  paymentMethods: [_testMethod],
  upgradeEndpoint: '/api/v1/customer/subscriptions/sub-1/upgrade-requests',
);

class _UpgradeRepoFake implements RestaurantTierUpgradeRepository {
  ApiResult<SubscriptionUpgradeRequestResultEntity> createResult =
      const ApiSuccessResult(
    data: SubscriptionUpgradeRequestResultEntity(
      upgradeId: 'up-1',
      subscriptionId: 'sub-1',
      fromTier: 'Basic',
      toTier: 'Platinum',
      amount: 15.0,
      currencyCode: 'KWD',
      paymentUrl: 'https://payzah.net/checkout/up1',
      isPaid: false,
      status: 'Pending',
      remainingServiceDays: 12,
    ),
  );

  @override
  Future<ApiResult<SubscriptionUpgradeRequestResultEntity>>
      createUpgradeRequest(
    String subscriptionId,
    SubscriptionUpgradeRequestEntity request,
  ) async =>
          createResult;

  @override
  Future<ApiResult<SubscriptionUpgradeOptionsEntity>> getUpgradeOptions(
    String subscriptionId,
  ) async =>
      const ApiSuccessResult(data: _testOptionsEntity);

  @override
  Future<ApiResult<SubscriptionUpgradeStatusEntity>> getUpgradeStatus(
    String subscriptionId,
    String upgradeId,
  ) async =>
      const ApiSuccessResult(
        data: SubscriptionUpgradeStatusEntity(
          upgradeId: 'up-1',
          subscriptionId: 'sub-1',
          fromTier: 'Basic',
          toTier: 'Platinum',
          amount: 15.0,
          currencyCode: 'KWD',
          status: 'Pending',
          isPaid: false,
          isFailed: false,
          paymentUrl: '',
        ),
      );

  @override
  Future<ApiResult<SubscriptionUpgradeSummaryEntity>> getUpgradeSummary(
    String subscriptionId,
    String targetTier,
  ) async =>
      const ApiSuccessResult(data: _testSummaryEntity);
}

class _BillingRepoFake implements SubscriptionBillingRepository {
  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>>
      getCurrentCustomerSubscription() async =>
          const ApiSuccessResult(
            data: SubscriptionBillingCurrentEntity(
              subscription: null,
              emptyStateCode: '',
            ),
          );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
