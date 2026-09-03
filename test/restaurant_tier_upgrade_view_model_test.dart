import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/restaurant_tier_upgrade_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/create_subscription_upgrade_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_upgrade_options_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_upgrade_status_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_view_model.dart';

void main() {
  test('submits the selected upgrade payment method id', () async {
    final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
    final viewModel = RestaurantTierUpgradeViewModel(
      GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
      CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
      GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
      GetCurrentCustomerSubscriptionUseCase(_ProfileRepositoryFake()),
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
      const SelectUpgradePaymentMethodEvent(_madaPaymentMethod),
    );

    viewModel.doIntent(const SubmitUpgradeRequestEvent());
    await Future<void>.delayed(Duration.zero);

    expect(upgradeRepository.submittedRequest?.paymentMethodId, 6);
  });
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

const _madaPaymentMethod = SubscriptionUpgradePaymentMethodEntity(
  id: 6,
  code: 'md',
  title: 'مدى',
  integrationType: 'MYFATOORAH_HOSTED',
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
  paymentMethods: [
    SubscriptionUpgradePaymentMethodEntity(
      id: 1,
      code: 'kn',
      title: 'كي نت',
      integrationType: 'MYFATOORAH_HOSTED',
      serviceCharge: 1.153,
      totalAmount: 15.25,
      currencyCode: 'KWD',
      isAvailable: true,
    ),
    _madaPaymentMethod,
  ],
);

class _RestaurantTierUpgradeRepositoryFake
    implements RestaurantTierUpgradeRepository {
  SubscriptionUpgradeRequestEntity? submittedRequest;

  @override
  Future<ApiResult<SubscriptionUpgradeOptionsEntity>> getUpgradeOptions(
    String subscriptionId,
  ) async {
    return ApiSuccessResult(data: _upgradeOptions);
  }

  @override
  Future<ApiResult<SubscriptionUpgradeRequestResultEntity>>
  createUpgradeRequest(
    String subscriptionId,
    SubscriptionUpgradeRequestEntity request,
  ) async {
    submittedRequest = request;
    return ApiSuccessResult(
      data: const SubscriptionUpgradeRequestResultEntity(
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
  }
}

class _ProfileRepositoryFake implements ProfileRepository {
  @override
  Future<ApiResult<void>> deleteCustomerProfileImage() async {
    return ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<CustomerProfileEntity>> getCustomerProfile() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingCurrentEntity>>
  getCurrentCustomerSubscription() async {
    return ApiSuccessResult(
      data: const ProfileBillingCurrentEntity(emptyStateCode: ''),
    );
  }

  @override
  Future<ApiResult<ProfileBillingEntity>> getProfileBilling() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> updateCustomerProfile(
    UpdateCustomerProfileRequestEntity request,
  ) async {
    return ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<void>> updateCustomerProfileImage(
    ProfileImageRequestEntity request,
  ) async {
    return ApiSuccessResult(data: null);
  }
}
