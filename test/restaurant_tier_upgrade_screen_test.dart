import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/errors/error_widgets/base_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/routing_generator.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/repo/restaurant_tier_upgrade_repository.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/create_subscription_upgrade_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_options_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/usecase/get_subscription_upgrade_status_usecase.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/screens/restaurant_tier_upgrade_screen.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_continue_button.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_option_card.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_payment_section.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_actions.dart';

void main() {
  var unavailable = false;
  setUp(() async {
    await getIt.reset();
    unavailable = false;
    getIt.registerFactory<RestaurantTierUpgradeViewModel>(() {
      final upgradeRepository = _RestaurantTierUpgradeRepositoryFake(
        unavailable: unavailable,
      );
      return RestaurantTierUpgradeViewModel(
        GetSubscriptionUpgradeOptionsUseCase(upgradeRepository),
        GetSubscriptionUpgradeSummaryUseCase(upgradeRepository),
        CreateSubscriptionUpgradeRequestUseCase(upgradeRepository),
        GetSubscriptionUpgradeStatusUseCase(upgradeRepository),
        GetCurrentCustomerSubscriptionUseCase(
          _SubscriptionBillingRepositoryFake(),
        ),
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

      await tester.tap(find.byType(RestaurantTierContinueButton));
      await tester.pumpAndSettle();

      expect(find.byType(RestaurantTierUpgradeActions), findsOneWidget);
      expect(find.byType(RestaurantTierPaymentSection), findsOneWidget);
    },
  );
  for (final language in ['ar', 'en']) {
    testWidgets(
      'unavailable upgrade uses error artwork and reason in $language',
      (tester) async {
        unavailable = true;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: Locale(language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const RestaurantTierUpgradeScreen(
              args: RestaurantTierUpgradeArgs(subscriptionId: 'sub-1'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final context = tester.element(
          find.byType(RestaurantTierUpgradeScreen),
        );
        final locale = AppLocalizations.of(context)!;
        expect(
          find.text(locale.restaurant_tier_unavailable_no_days),
          findsOneWidget,
        );
        expect(find.text(locale.error_unknown), findsNothing);
        expect(find.byIcon(Icons.info_outline_rounded), findsNothing);
        final state = tester.widget<BaseErrorWidget>(
          find.byType(BaseErrorWidget),
        );
        expect(state.title, locale.subscription_upgrade_not_available);
        expect(state.imageAsset, Assets.errorIllustration);
        expect(tester.takeException(), isNull);
      },
    );
  }
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
      id: 3,
      code: 'PAYZAH',
      title: 'Payzah',
      integrationType: 'HOSTED',
      serviceCharge: 1.153,
      totalAmount: 15.25,
      currencyCode: 'KWD',
      isAvailable: true,
    ),
  ],
);

class _RestaurantTierUpgradeRepositoryFake
    implements RestaurantTierUpgradeRepository {
  _RestaurantTierUpgradeRepositoryFake({this.unavailable = false});
  final bool unavailable;
  @override
  Future<ApiResult<SubscriptionUpgradeOptionsEntity>> getUpgradeOptions(
    String subscriptionId,
  ) async {
    if (unavailable) {
      return const ApiSuccessResult(
        data: SubscriptionUpgradeOptionsEntity(
          canUpgrade: false,
          unavailableReason: 'no_remaining_service_days',
          currentTier: 'Basic',
          remainingServiceDays: 0,
          totalServiceDays: 6,
          upgradeEndpoint: '',
          options: [],
        ),
      );
    }
    return const ApiSuccessResult(data: _upgradeOptions);
  }

  @override
  Future<ApiResult<SubscriptionUpgradeSummaryEntity>> getUpgradeSummary(
    String subscriptionId,
    String targetTier,
  ) async {
    return const ApiSuccessResult(
      data: SubscriptionUpgradeSummaryEntity(
        subscriptionId: 'sub-1',
        currentTier: SubscriptionUpgradeTierEntity(
          tier: 'Basic',
          tierNameAr: 'Basic',
          tierNameEn: 'Basic',
          accessibleRestaurantCount: 12,
        ),
        targetTier: SubscriptionUpgradeTierEntity(
          tier: 'Plus',
          tierNameAr: 'Plus',
          tierNameEn: 'Plus',
          accessibleRestaurantCount: 24,
        ),
        currentTierRestaurants: [],
        targetTierRestaurants: [],
        newlyAddedRestaurants: [],
        effectiveFromDate: '2026-09-10',
        effectiveNoticeAr: 'يبدأ التفعيل بعد 72 ساعة.',
        effectiveNoticeEn: 'Activation starts after 72 hours.',
        restaurantRepetition: SubscriptionUpgradeRestaurantRepetitionEntity(
          limit: 3,
          restaurantCount: 24,
          durationDays: 12,
        ),
        currentRemainingCredit: 40,
        targetRemainingPrice: 52,
        priceDifference: 12,
        currencyCode: 'KWD',
        remainingServiceDays: 12,
        totalServiceDays: 12,
        paymentMethods: [
          SubscriptionUpgradePaymentMethodEntity(
            id: 3,
            code: 'PAYZAH',
            title: 'Payzah',
            integrationType: 'HOSTED',
            serviceCharge: 0,
            totalAmount: 12,
            currencyCode: 'KWD',
            isAvailable: true,
          ),
        ],
        upgradeEndpoint:
            '/api/v1/customer/subscriptions/sub-1/upgrade-requests',
      ),
    );
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

class _SubscriptionBillingRepositoryFake
    implements SubscriptionBillingRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
