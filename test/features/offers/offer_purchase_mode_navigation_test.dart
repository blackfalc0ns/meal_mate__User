import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_event.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_view_model.dart';
import 'package:meal_meat_user/features/offer_details/presentation/screens/offer_details_screen.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_calendar_entry_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_eligible_restaurant_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_evaluation_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_hub_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/validate_discount_result_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/add_offer_to_calendar_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_available_offers_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_customer_offer_details_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_offer_calendar_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_offer_eligible_restaurants_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_offers_hub_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_saved_offers_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/save_offer_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/unsave_offer_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_view_model.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/browse_offers_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/offers_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/promo_code_input_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_quick_preview_sheet.dart';

class TestNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

class FakeOffersRepository implements OffersRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  List<OfferEntity> availableOffers = [];
  OfferEntity? singleOffer;

  @override
  Future<ApiResult<List<OfferEntity>>> getAvailableOffers({
    double? cartAmount,
    int? durationDays,
    String? deliveryGovernorate,
    String? programId,
    String? bundleId,
    String? restaurantId,
    int? page,
    int? pageSize,
    String? search,
    String? category,
    bool? eligibleOnly,
    bool? includeCampaigns,
  }) async {
    return ApiSuccessResult(data: availableOffers);
  }

  @override
  Future<ApiResult<OffersHubEntity>> getOffersHub() async {
    return ApiSuccessResult(
      data: OffersHubEntity(
        availableOffers: availableOffers,
        heroOffers: availableOffers
            .where((o) => o.bannerImageUrl != null)
            .toList(),
        savedOffers: const [],
      ),
    );
  }

  @override
  Future<ApiResult<OfferEntity>> getOfferDetails(String offerId) async {
    return ApiSuccessResult(
      data: singleOffer ?? availableOffers.firstWhere((o) => o.id == offerId),
    );
  }

  @override
  Future<ApiResult<List<OfferEligibleRestaurantEntity>>>
  getOfferEligibleRestaurants(String offerId) async =>
      const ApiSuccessResult(data: []);

  @override
  Future<ApiResult<void>> saveOffer(String offerId) async =>
      const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<void>> unsaveOffer(String offerId) async =>
      const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<List<OfferEntity>>> getSavedOffers() async =>
      const ApiSuccessResult(data: []);

  @override
  Future<ApiResult<List<OfferCalendarEntryEntity>>> getOfferCalendar() async =>
      const ApiSuccessResult(data: []);

  @override
  Future<ApiResult<OfferCalendarEntryEntity>> addOfferToCalendar(
    String offerId,
    String scheduledDate,
  ) async => throw UnimplementedError();

  @override
  Future<ApiResult<void>> removeOfferFromCalendar(
    String offerId,
    String date,
  ) async => throw UnimplementedError();

  @override
  Future<ApiResult<OfferPurchaseOptionsEntity>> getOfferPurchaseOptions(
    String offerId, {
    String? startDate,
    bool? includeFriday,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<OfferEvaluationEntity>> evaluateOffer({
    String? offerId,
    String? promoCode,
    double? cartAmount,
    String? deliveryGovernorate,
    int? durationDays,
    String? programId,
    String? bundleId,
    String? restaurantId,
    List<String>? selectedMealIds,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<ValidateDiscountResultEntity>> validateDiscount({
    required String code,
    dynamic programId,
    dynamic bundleId,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<CampaignSessionEntity>> createCampaignCheckoutSession({
    double? expectedFinalPrice,
    String? quoteId,
    String? idempotencyKey,
    required String campaignId,
    required String bundleId,
    required int durationDays,
    List<String>? requestedServiceDates,
    String? deliveryGovernorate,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<CampaignPaymentEntity>> startCampaignPayment(
    StartCampaignPaymentRequestEntity request,
  ) async => throw UnimplementedError();

  @override
  Future<ApiResult<CampaignPaymentEntity>> getCampaignPaymentStatus(
    String sessionId,
  ) async => throw UnimplementedError();
}

void main() {
  const directOffer = OfferEntity(
    id: 'direct-offer-1',
    nameAr: 'عرض مباشر',
    nameEn: 'Direct Offer',
    descriptionAr: 'وصف مباشر',
    descriptionEn: 'Direct description',
    purchaseMode: OfferPurchaseMode.directPurchase,
  );

  const couponOffer = OfferEntity(
    id: 'coupon-offer-1',
    nameAr: 'عرض كوبون',
    nameEn: 'Coupon Offer',
    descriptionAr: 'وصف كوبون',
    descriptionEn: 'Coupon description',
    promoCode: 'DISCOUNT50',
    purchaseMode: OfferPurchaseMode.couponOnly,
  );

  const campaignProjection = OfferEntity(
    id: 'proj-1',
    campaignId: 'campaign-exclusive-99',
    nameAr: 'حملة ترويجية',
    nameEn: 'Campaign Promo',
    descriptionAr: 'خصم الحملة',
    descriptionEn: 'Campaign discount',
    promoCode: 'CAMP50',
    purchaseMode: OfferPurchaseMode.couponOnly,
  );

  const unknownOffer = OfferEntity(
    id: 'unknown-offer-1',
    nameAr: 'عرض مجهول',
    nameEn: 'Unknown Offer',
    descriptionAr: 'وصف مجهول',
    descriptionEn: 'Unknown description',
    purchaseMode: OfferPurchaseMode.unknown,
  );

  Widget buildWrapper({
    required Widget child,
    required TestNavigatorObserver observer,
  }) {
    return MaterialApp(
      navigatorObservers: [observer],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(body: child),
        );
      },
    );
  }

  group('OfferQuickPreviewSheet navigation and guards', () {
    testWidgets('routes direct purchase to redeemPackage', (tester) async {
      final observer = TestNavigatorObserver();
      await tester.pumpWidget(
        buildWrapper(
          child: const OfferQuickPreviewSheet(offer: directOffer),
          observer: observer,
        ),
      );

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);
      await tester.pumpAndSettle();

      final pushed = observer.pushedRoutes
          .where((r) => r.settings.name == AppRoutes.redeemPackage)
          .toList();
      expect(pushed, hasLength(1));
      expect(pushed.first.settings.arguments, directOffer);
    });

    testWidgets('routes coupon-only offer to promoCodeInput with promoCode', (
      tester,
    ) async {
      final observer = TestNavigatorObserver();
      await tester.pumpWidget(
        buildWrapper(
          child: const OfferQuickPreviewSheet(offer: couponOffer),
          observer: observer,
        ),
      );

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);
      await tester.pumpAndSettle();

      final pushed = observer.pushedRoutes
          .where((r) => r.settings.name == AppRoutes.promoCodeInput)
          .toList();
      expect(pushed, hasLength(1));
      expect(pushed.first.settings.arguments, 'DISCOUNT50');

      final redeemPushed = observer.pushedRoutes
          .where((r) => r.settings.name == AppRoutes.redeemPackage)
          .toList();
      expect(redeemPushed, isEmpty);
    });

    testWidgets(
      'campaign projection never passes campaignId to offerDetails or redeemPackage',
      (tester) async {
        final observer = TestNavigatorObserver();
        await tester.pumpWidget(
          buildWrapper(
            child: const OfferQuickPreviewSheet(offer: campaignProjection),
            observer: observer,
          ),
        );

        final btn = find.byType(ElevatedButton);
        await tester.tap(btn);
        await tester.pumpAndSettle();

        final detailsPushed = observer.pushedRoutes
            .where((r) => r.settings.name == AppRoutes.offerDetails)
            .toList();
        expect(detailsPushed, isEmpty);

        final promoPushed = observer.pushedRoutes
            .where((r) => r.settings.name == AppRoutes.promoCodeInput)
            .toList();
        expect(promoPushed, hasLength(1));
        expect(promoPushed.first.settings.arguments, 'CAMP50');
        expect(
          promoPushed.first.settings.arguments,
          isNot('campaign-exclusive-99'),
        );
      },
    );

    testWidgets('unknown purchase mode CTA is disabled', (tester) async {
      final observer = TestNavigatorObserver();
      await tester.pumpWidget(
        buildWrapper(
          child: const OfferQuickPreviewSheet(offer: unknownOffer),
          observer: observer,
        ),
      );

      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });
  });

  group('OffersScreen hero and card taps routing', () {
    late FakeOffersRepository repository;
    late OffersViewModel viewModel;

    setUp(() {
      repository = FakeOffersRepository();
    });

    tearDown(() {
      unawaited(viewModel.close());
    });

    testWidgets('tapping direct card routes to offerDetails', (tester) async {
      repository.availableOffers = [directOffer];
      viewModel = OffersViewModel(
        GetAvailableOffersUseCase(repository),
        GetOffersHubUseCase(repository),
        GetSavedOffersUseCase(repository),
        SaveOfferUseCase(repository),
        UnsaveOfferUseCase(repository),
        GetOfferCalendarUseCase(repository),
      );
      viewModel.doIntent(const LoadOffersHubEvent());

      final observer = TestNavigatorObserver();
      await tester.pumpWidget(
        buildWrapper(
          child: OffersScreen(viewModel: viewModel),
          observer: observer,
        ),
      );
      await tester.pumpAndSettle();

      final directCard = find.byKey(const ValueKey('direct-offer-1'));
      expect(directCard, findsOneWidget);
      await tester.tap(directCard);
      await tester.pumpAndSettle();

      final pushed = observer.pushedRoutes
          .where((r) => r.settings.name == AppRoutes.offerDetails)
          .toList();
      expect(pushed, hasLength(1));
      expect(pushed.first.settings.arguments, 'direct-offer-1');
    });

    testWidgets('tapping coupon card routes to promoCodeInput', (tester) async {
      repository.availableOffers = [couponOffer];
      viewModel = OffersViewModel(
        GetAvailableOffersUseCase(repository),
        GetOffersHubUseCase(repository),
        GetSavedOffersUseCase(repository),
        SaveOfferUseCase(repository),
        UnsaveOfferUseCase(repository),
        GetOfferCalendarUseCase(repository),
      );
      viewModel.doIntent(const LoadOffersHubEvent());

      final observer = TestNavigatorObserver();
      await tester.pumpWidget(
        buildWrapper(
          child: OffersScreen(viewModel: viewModel),
          observer: observer,
        ),
      );
      await tester.pumpAndSettle();

      final couponCard = find.byKey(const ValueKey('coupon-offer-1'));
      expect(couponCard, findsOneWidget);
      await tester.tap(couponCard);
      await tester.pumpAndSettle();

      final pushed = observer.pushedRoutes
          .where((r) => r.settings.name == AppRoutes.promoCodeInput)
          .toList();
      expect(pushed, hasLength(1));
      expect(pushed.first.settings.arguments, 'DISCOUNT50');
    });
  });

  group('BrowseOffersScreen card tap routing and guards', () {
    late FakeOffersRepository repository;
    late OffersViewModel viewModel;

    setUp(() {
      repository = FakeOffersRepository();
    });

    tearDown(() {
      unawaited(viewModel.close());
    });

    testWidgets(
      'direct offer routes to offerDetails, coupon routes to promoCodeInput, unknown does not route',
      (tester) async {
        repository.availableOffers = [directOffer, couponOffer, unknownOffer];
        viewModel = OffersViewModel(
          GetAvailableOffersUseCase(repository),
          GetOffersHubUseCase(repository),
          GetSavedOffersUseCase(repository),
          SaveOfferUseCase(repository),
          UnsaveOfferUseCase(repository),
          GetOfferCalendarUseCase(repository),
        );
        viewModel.doIntent(const GetOffersEvent());

        final observer = TestNavigatorObserver();
        await tester.pumpWidget(
          buildWrapper(
            child: BrowseOffersScreen(viewModel: viewModel),
            observer: observer,
          ),
        );
        await tester.pumpAndSettle();

        // Tap direct offer
        await tester.tap(find.text('Direct Offer'));
        await tester.pumpAndSettle();
        expect(
          observer.pushedRoutes.where(
            (r) => r.settings.name == AppRoutes.offerDetails,
          ),
          hasLength(1),
        );

        // Tap coupon offer
        await tester.tap(find.text('Coupon Offer'));
        await tester.pumpAndSettle();
        expect(
          observer.pushedRoutes.where(
            (r) => r.settings.name == AppRoutes.promoCodeInput,
          ),
          hasLength(1),
        );

        // Tap unknown offer - should not push any new route
        final routeCountBefore = observer.pushedRoutes.length;
        await tester.tap(find.text('Unknown Offer'));
        await tester.pumpAndSettle();
        expect(observer.pushedRoutes.length, routeCountBefore);
      },
    );
  });

  group('OfferDetailsScreen CTA routing and guards', () {
    late FakeOffersRepository repository;
    late OfferDetailsViewModel detailsVm;

    setUp(() {
      repository = FakeOffersRepository();
    });

    tearDown(() {
      unawaited(detailsVm.close());
    });

    testWidgets('direct offer CTA routes to redeemPackage', (tester) async {
      repository.singleOffer = directOffer;
      detailsVm = OfferDetailsViewModel(
        GetCustomerOfferDetailsUseCase(repository),
        SaveOfferUseCase(repository),
        UnsaveOfferUseCase(repository),
        GetOfferEligibleRestaurantsUseCase(repository),
        AddOfferToCalendarUseCase(repository),
      );
      detailsVm.doIntent(const LoadOfferDetailsEvent('direct-offer-1'));

      final observer = TestNavigatorObserver();
      await tester.pumpWidget(
        buildWrapper(
          child: OfferDetailsScreen(
            offerId: 'direct-offer-1',
            viewModel: detailsVm,
          ),
          observer: observer,
        ),
      );
      await tester.pumpAndSettle();

      final cta = find.byType(ElevatedButton);
      expect(cta, findsOneWidget);
      await tester.ensureVisible(cta);
      await tester.tap(cta);
      await tester.pumpAndSettle();

      final pushed = observer.pushedRoutes
          .where((r) => r.settings.name == AppRoutes.redeemPackage)
          .toList();
      expect(pushed, hasLength(1));
    });

    testWidgets('coupon-only offer CTA routes to promoCodeInput', (
      tester,
    ) async {
      repository.singleOffer = couponOffer;
      detailsVm = OfferDetailsViewModel(
        GetCustomerOfferDetailsUseCase(repository),
        SaveOfferUseCase(repository),
        UnsaveOfferUseCase(repository),
        GetOfferEligibleRestaurantsUseCase(repository),
        AddOfferToCalendarUseCase(repository),
      );
      detailsVm.doIntent(const LoadOfferDetailsEvent('coupon-offer-1'));

      final observer = TestNavigatorObserver();
      await tester.pumpWidget(
        buildWrapper(
          child: OfferDetailsScreen(
            offerId: 'coupon-offer-1',
            viewModel: detailsVm,
          ),
          observer: observer,
        ),
      );
      await tester.pumpAndSettle();

      final cta = find.byType(ElevatedButton);
      expect(cta, findsOneWidget);
      await tester.ensureVisible(cta);
      await tester.tap(cta);
      await tester.pumpAndSettle();

      final pushed = observer.pushedRoutes
          .where((r) => r.settings.name == AppRoutes.promoCodeInput)
          .toList();
      expect(pushed, hasLength(1));
      expect(pushed.first.settings.arguments, 'DISCOUNT50');

      expect(
        observer.pushedRoutes.where(
          (r) => r.settings.name == AppRoutes.redeemPackage,
        ),
        isEmpty,
      );
    });

    testWidgets('unknown offer CTA is disabled', (tester) async {
      repository.singleOffer = unknownOffer;
      detailsVm = OfferDetailsViewModel(
        GetCustomerOfferDetailsUseCase(repository),
        SaveOfferUseCase(repository),
        UnsaveOfferUseCase(repository),
        GetOfferEligibleRestaurantsUseCase(repository),
        AddOfferToCalendarUseCase(repository),
      );
      detailsVm.doIntent(const LoadOfferDetailsEvent('unknown-offer-1'));

      final observer = TestNavigatorObserver();
      await tester.pumpWidget(
        buildWrapper(
          child: OfferDetailsScreen(
            offerId: 'unknown-offer-1',
            viewModel: detailsVm,
          ),
          observer: observer,
        ),
      );
      await tester.pumpAndSettle();

      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });
  });

  group('PromoCodeInputScreen initial code review', () {
    testWidgets('initial code is prefilled in input without auto-validation', (
      tester,
    ) async {
      final observer = TestNavigatorObserver();
      await tester.pumpWidget(
        buildWrapper(
          child: const PromoCodeInputScreen(initialCode: 'SUMMER2026'),
          observer: observer,
        ),
      );

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      final widget = tester.widget<TextField>(textField);
      expect(widget.controller?.text, 'SUMMER2026');
    });
  });
}
