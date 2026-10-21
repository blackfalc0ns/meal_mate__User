import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
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
import 'package:meal_meat_user/features/offers/domain/usecase/get_available_offers_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_offer_calendar_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_offers_hub_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_saved_offers_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/save_offer_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/unsave_offer_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_state.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_view_model.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/offers_screen.dart';

class FakeOffersRepository implements OffersRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  List<OfferEntity> availableOffers = [];
  bool saveCalled = false;

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
  Future<ApiResult<void>> saveOffer(String offerId) async {
    saveCalled = true;
    return const ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<void>> unsaveOffer(String offerId) async {
    return const ApiSuccessResult(data: null);
  }

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
  Future<ApiResult<OfferEntity>> getOfferDetails(String offerId) async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<OfferPurchaseOptionsEntity>> getOfferPurchaseOptions(
    String offerId, {
    String? startDate,
    bool? includeFriday,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<List<OfferEligibleRestaurantEntity>>>
  getOfferEligibleRestaurants(String offerId) async =>
      throw UnimplementedError();

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
    id: 'direct-1',
    nameAr: 'عرض شراء مباشر',
    nameEn: 'Direct Offer',
    descriptionAr: 'تفاصيل العرض',
    descriptionEn: 'Details',
    purchaseMode: OfferPurchaseMode.directPurchase,
    minSubscriptionDays: 20,
  );

  const couponOffer = OfferEntity(
    id: 'coupon-1',
    nameAr: 'عرض كوبون فقط',
    nameEn: 'Coupon Offer',
    descriptionAr: 'تفاصيل الكوبون',
    descriptionEn: 'Coupon Details',
    purchaseMode: OfferPurchaseMode.couponOnly,
    promoCode: 'SAVE20',
  );

  const unknownOffer = OfferEntity(
    id: 'unknown-1',
    nameAr: 'عرض غير معروف',
    nameEn: 'Unknown Offer',
    descriptionAr: 'تفاصيل عامة',
    descriptionEn: 'General Details',
    purchaseMode: OfferPurchaseMode.unknown,
  );

  group('OffersState purchaseMode section getters', () {
    test('partitions filteredOffers into ready, coupon, and unclassified', () {
      const state = OffersState(
        filteredOffers: [directOffer, couponOffer, unknownOffer],
      );

      expect(state.readyOffers, [directOffer]);
      expect(state.couponOffers, [couponOffer]);
      expect(state.unclassifiedOffers, [unknownOffer]);
    });
  });

  group('OffersViewModel sections with filtering and refresh', () {
    late FakeOffersRepository repository;
    late OffersViewModel viewModel;

    setUp(() {
      repository = FakeOffersRepository();
      repository.availableOffers = [directOffer, couponOffer, unknownOffer];

      viewModel = OffersViewModel(
        GetAvailableOffersUseCase(repository),
        GetOffersHubUseCase(repository),
        GetSavedOffersUseCase(repository),
        SaveOfferUseCase(repository),
        UnsaveOfferUseCase(repository),
        GetOfferCalendarUseCase(repository),
      );
    });

    tearDown(() {
      unawaited(viewModel.close());
    });

    test(
      'campaign sources never enter list, hero or filtered results',
      () async {
        repository.availableOffers = [
          directOffer,
          couponOffer,
          directOffer.copyWith(
            id: 'campaign-direct',
            sourceType: 'Campaign',
            bannerImageUrl: 'https://example.com/image.jpg',
          ),
          couponOffer.copyWith(id: 'campaign-coupon', sourceType: 'Campaign'),
        ];
        viewModel.doIntent(const GetOffersEvent());
        await Future<void>.delayed(Duration.zero);
        expect(viewModel.state.allOffers.map((offer) => offer.id), [
          'direct-1',
          'coupon-1',
        ]);
        expect(
          viewModel.state.heroOffers.any(
            (offer) => offer.sourceType == 'Campaign',
          ),
          false,
        );
        viewModel.doIntent(const SelectOfferCategoryEvent(2));
        expect(viewModel.state.filteredOffers.map((offer) => offer.id), [
          'coupon-1',
        ]);
        viewModel.doIntent(const LoadOffersHubEvent());
        await Future<void>.delayed(Duration.zero);
        expect(
          viewModel.state.allOffers.any(
            (offer) => offer.sourceType == 'Campaign',
          ),
          false,
        );
        expect(
          viewModel.state.heroOffers.any(
            (offer) => offer.sourceType == 'Campaign',
          ),
          false,
        );
      },
    );

    test('derives readyOffers and couponOffers from one source list', () async {
      viewModel.doIntent(const LoadOffersHubEvent());
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.readyOffers.map((o) => o.id), ['direct-1']);
      expect(viewModel.state.couponOffers.map((o) => o.id), ['coupon-1']);
      expect(viewModel.state.unclassifiedOffers.map((o) => o.id), [
        'unknown-1',
      ]);

      // Category filter: category 2 filters for promoCode != null
      viewModel.doIntent(const SelectOfferCategoryEvent(2));
      expect(viewModel.state.readyOffers, isEmpty);
      expect(viewModel.state.couponOffers.map((o) => o.id), ['coupon-1']);
      expect(viewModel.state.unclassifiedOffers, isEmpty);

      // Reset category to All (0)
      viewModel.doIntent(const SelectOfferCategoryEvent(0));
      expect(viewModel.state.readyOffers.length, 1);
      expect(viewModel.state.couponOffers.length, 1);

      // Refresh offers
      viewModel.doIntent(const RefreshOffersEvent());
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.readyOffers.length, 1);
      expect(viewModel.state.couponOffers.length, 1);

      // Toggle save updates single source and reflects in section
      viewModel.doIntent(const ToggleSaveOfferEvent('direct-1'));
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.readyOffers.first.isSaved, isTrue);
      expect(
        viewModel.state.allOffers.firstWhere((o) => o.id == 'direct-1').isSaved,
        isTrue,
      );
    });
  });

  group('OffersScreen purchase mode sections UI', () {
    late FakeOffersRepository repository;
    late OffersViewModel viewModel;

    setUp(() {
      repository = FakeOffersRepository();
    });

    tearDown(() {
      unawaited(viewModel.close());
    });

    Widget buildTestApp(Widget child) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(body: child),
      );
    }

    testWidgets(
      'displays ready offers and coupons in separate named sections',
      (tester) async {
        repository.availableOffers = [directOffer, couponOffer];
        viewModel = OffersViewModel(
          GetAvailableOffersUseCase(repository),
          GetOffersHubUseCase(repository),
          GetSavedOffersUseCase(repository),
          SaveOfferUseCase(repository),
          UnsaveOfferUseCase(repository),
          GetOfferCalendarUseCase(repository),
        );
        viewModel.doIntent(const LoadOffersHubEvent());

        await tester.pumpWidget(
          buildTestApp(OffersScreen(viewModel: viewModel)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Featured offers'), findsOneWidget);
        expect(find.text('Discount coupons'), findsOneWidget);

        expect(find.byKey(const ValueKey('direct-1')), findsOneWidget);
        expect(find.byKey(const ValueKey('coupon-1')), findsOneWidget);
      },
    );

    testWidgets(
      'empty ready section shows empty state without hiding coupons',
      (tester) async {
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

        await tester.pumpWidget(
          buildTestApp(OffersScreen(viewModel: viewModel)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Featured offers'), findsOneWidget);
        expect(find.text('Discount coupons'), findsOneWidget);

        expect(
          find.text('No ready to buy offers currently available'),
          findsOneWidget,
        );
        expect(find.byKey(const ValueKey('coupon-1')), findsOneWidget);
        expect(find.byKey(const ValueKey('direct-1')), findsNothing);
      },
    );

    testWidgets('renders Arabic labels and RTL layout correctly', (
      tester,
    ) async {
      repository.availableOffers = [directOffer, couponOffer];
      viewModel = OffersViewModel(
        GetAvailableOffersUseCase(repository),
        GetOffersHubUseCase(repository),
        GetSavedOffersUseCase(repository),
        SaveOfferUseCase(repository),
        UnsaveOfferUseCase(repository),
        GetOfferCalendarUseCase(repository),
      );
      viewModel.doIntent(const LoadOffersHubEvent());

      await tester.pumpWidget(buildTestApp(OffersScreen(viewModel: viewModel)));
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(body: OffersScreen(viewModel: viewModel)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('عروض مميزة'), findsOneWidget);
      expect(find.text('كوبونات الخصم'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(OffersScreen))),
        TextDirection.rtl,
      );
    });
  });
}
