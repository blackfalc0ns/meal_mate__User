import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/routing_generator.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
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
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/restaurant_tier_upgrade_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_option_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_payment_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_upgrade_actions.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerFactory<RestaurantTierUpgradeViewModel>(() {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake();
      return RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(_ProfileRepositoryFake()),
      );
    });
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'restaurant tier upgrade starts at tier selection then shows confirmation',
    (tester) async {
      tester.view.physicalSize = const Size(522, 1134);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: RouteGenerator.getRoute,
          home: const RestaurantTierUpgradeScreen(
            args: RestaurantTierUpgradeArgs(subscriptionId: 'sub-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RestaurantTierOptionCard), findsNWidgets(2));
      expect(find.byType(RestaurantTierPaymentSection), findsNothing);

      await tester.ensureVisible(find.byType(RestaurantTierOptionCard).last);
      await tester.tap(find.byType(RestaurantTierOptionCard).last);
      await tester.pumpAndSettle();

      expect(find.byType(RestaurantTierUpgradeActions), findsOneWidget);
      expect(find.byType(RestaurantTierPaymentSection), findsOneWidget);
    },
  );
}

const _plusOption = SubscriptionUpgradeOptionEntity(
  targetTier: 'Plus',
  tierNameAr: 'Plus',
  tierNameEn: 'Plus',
  isCurrent: false,
  selectable: true,
  accessibleRestaurantCount: 24,
  currentRemainingCredit: 40,
  targetRemainingPrice: 52,
  gatewayRecovery: 1.5,
  priceDifference: 12,
  currencyCode: 'KWD',
);

const _upgradeOptions = SubscriptionUpgradeOptionsEntity(
  canUpgrade: true,
  currentTier: 'Basic',
  remainingServiceDays: 12,
  totalServiceDays: 12,
  upgradeEndpoint: '/api/v1/customer/subscriptions/sub-1/upgrade-requests',
  options: [
    SubscriptionUpgradeOptionEntity(
      targetTier: 'Basic',
      tierNameAr: 'Basic',
      tierNameEn: 'Basic',
      isCurrent: true,
      selectable: false,
      accessibleRestaurantCount: 12,
      currentRemainingCredit: 40,
      targetRemainingPrice: 40,
      gatewayRecovery: 0,
      priceDifference: 0,
      currencyCode: 'KWD',
    ),
    _plusOption,
  ],
  paymentMethods: [
    SubscriptionUpgradePaymentMethodEntity(
      id: 1,
      code: 'kn',
      title: 'KNET',
      integrationType: 'MYFATOORAH_HOSTED',
      serviceCharge: 1.153,
      totalAmount: 15.25,
      currencyCode: 'KWD',
      isAvailable: true,
    ),
  ],
);

class _RestaurantTierUpgradeRepositoryFake
    implements RestaurantTierUpgradeRepository {
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
  ) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<SubscriptionUpgradeStatusEntity>> getUpgradeStatus(
    String subscriptionId,
    String upgradeId,
  ) {
    throw UnimplementedError();
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
  getCurrentCustomerSubscription() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingEntity>> getProfileBilling() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> createCustomerSubscriptionRenewalRequest(
    String subscriptionId,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingFreezeResponseEntity>>
  createCustomerSubscriptionFreezeRequest({
    required String subscriptionId,
    required ProfileBillingFreezeRequestEntity request,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingCancellationQuoteEntity>>
  getCustomerSubscriptionCancellationQuote(String subscriptionId) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingCancellationResultEntity>>
  createCustomerSubscriptionCancellationRequest({
    required String subscriptionId,
    required ProfileBillingCancellationRequestEntity request,
  }) {
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
