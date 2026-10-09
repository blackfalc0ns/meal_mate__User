import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';

class FakeSubscriptionSummaryRepository implements SubscriptionSummaryRepository {
  SubscriptionSummaryRequestEntity? lastRequest;
  Completer<ApiResult<SubscriptionSummaryEntity>>? nextResultCompleter;
  ApiResult<SubscriptionSummaryEntity>? immediateResult;

  @override
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  ) async {
    lastRequest = request;
    if (nextResultCompleter != null) {
      return nextResultCompleter!.future;
    }
    if (immediateResult != null) {
      return immediateResult!;
    }
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<SubscriptionRestaurantAvailabilityEntity>>
  getRestaurantAvailability(SubscriptionSummaryRequestEntity request) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<SubscriptionReadinessEntity>> getReadiness(
    SubscriptionSummaryRequestEntity request,
  ) {
    throw UnimplementedError();
  }
}

SubscriptionSummaryEntity buildPagedSummary({
  required List<SubscriptionSummaryRestaurantEntity> restaurants,
  required PaginationEntity pagination,
  double finalPrice = 100.0,
  int restaurantCount = 10,
}) {
  return SubscriptionSummaryEntity(
    programId: 'prog-1',
    programNameAr: 'برنامج',
    programNameEn: 'Program',
    bundleId: 'bundle-1',
    bundleNameAr: 'باقة',
    bundleNameEn: 'Bundle',
    restaurantCount: restaurantCount,
    tier: 'Basic',
    tierNameAr: 'بيسك',
    tierNameEn: 'Basic',
    durationDays: 26,
    chosenStartDate: '2026-10-10',
    startDate: '2026-10-10',
    endDate: '2026-11-05',
    serviceDates: const ['2026-10-10'],
    slotRequirements: const [],
    basePrice: 100.0,
    campaignDiscount: 0,
    promoDiscount: 0,
    walletCredit: 0,
    gatewayFee: 0,
    finalPrice: finalPrice,
    currencyCode: 'KWD',
    canCheckout: true,
    restaurants: restaurants,
    termsAcceptanceRequired: false,
    checkoutEndpoint: '/checkout',
    includeFriday: false,
    fridayDays: 0,
    totalServiceDays: 26,
    includes: const SubscriptionSummaryIncludesEntity(
      titleAr: '',
      titleEn: '',
      items: [],
    ),
    restaurantsPagination: pagination,
  );
}

void main() {
  late FakeSubscriptionSummaryRepository fakeRepo;
  late GetSubscriptionSummaryUseCase useCase;

  const baseRequest = SubscriptionSummaryRequestEntity(
    includeFriday: false,
    durationDays: 26,
    tier: 'Basic',
    bundleId: 'bundle-1',
    programId: 'prog-1',
    startDate: '2026-10-10',
  );

  setUp(() {
    fakeRepo = FakeSubscriptionSummaryRepository();
    useCase = GetSubscriptionSummaryUseCase(fakeRepo);
  });

  group('Subscription Summary Restaurants Pagination Tests', () {
    test('LoadMoreSubscriptionSummaryRestaurantsEvent requests next page and appends restaurants without duplicates', () async {
      const page1Restaurants = [
        SubscriptionSummaryRestaurantEntity(
          restaurantId: 'r-1',
          nameAr: 'مطعم 1',
          nameEn: 'Restaurant 1',
          tier: 'Basic',
        ),
        SubscriptionSummaryRestaurantEntity(
          restaurantId: 'r-2',
          nameAr: 'مطعم 2',
          nameEn: 'Restaurant 2',
          tier: 'Basic',
        ),
      ];

      const page1Meta = PaginationEntity(
        page: 1,
        pageSize: 2,
        totalCount: 4,
        totalPages: 2,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      final initialSummary = buildPagedSummary(
        restaurants: page1Restaurants,
        pagination: page1Meta,
        restaurantCount: 4,
      );

      final viewModel = SubscriptionSummaryViewModel.withState(
        useCase,
        initialState: SubscriptionSummaryState(
          summary: initialSummary,
          activeRequest: baseRequest,
        ),
      );

      const page2Restaurants = [
        SubscriptionSummaryRestaurantEntity(
          restaurantId: 'r-2', // duplicate id
          nameAr: 'مطعم 2',
          nameEn: 'Restaurant 2',
          tier: 'Basic',
        ),
        SubscriptionSummaryRestaurantEntity(
          restaurantId: 'r-3',
          nameAr: 'مطعم 3',
          nameEn: 'Restaurant 3',
          tier: 'Basic',
        ),
      ];

      const page2Meta = PaginationEntity(
        page: 2,
        pageSize: 2,
        totalCount: 4,
        totalPages: 2,
        hasNextPage: false,
        hasPreviousPage: true,
      );

      final page2Summary = buildPagedSummary(
        restaurants: page2Restaurants,
        pagination: page2Meta,
        restaurantCount: 4,
      );

      fakeRepo.immediateResult = ApiSuccessResult(data: page2Summary);

      viewModel.doIntent(const LoadMoreSubscriptionSummaryRestaurantsEvent());
      await pumpEventQueue();

      expect(fakeRepo.lastRequest?.restaurantsPage, equals(2));
      expect(fakeRepo.lastRequest?.restaurantsPageSize, equals(2));

      // Deduped: r-1, r-2, r-3
      final currentRestaurants = viewModel.state.summary?.restaurants ?? [];
      expect(currentRestaurants.length, equals(3));
      expect(currentRestaurants.map((r) => r.restaurantId).toList(), equals(['r-1', 'r-2', 'r-3']));
      expect(viewModel.state.summary?.restaurantCount, equals(4)); // total count unchanged
      expect(viewModel.state.summary?.restaurantsPagination?.hasNextPage, isFalse);
      expect(viewModel.state.isLoadingMoreRestaurants, isFalse);
    });

    test('if pricing changes during restaurant append, new quote is refreshed rather than merged into stale price', () async {
      const page1Restaurants = [
        SubscriptionSummaryRestaurantEntity(
          restaurantId: 'r-1',
          nameAr: 'مطعم 1',
          nameEn: 'Restaurant 1',
          tier: 'Basic',
        ),
      ];
      const page1Meta = PaginationEntity(
        page: 1,
        pageSize: 1,
        totalCount: 2,
        totalPages: 2,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      final initialSummary = buildPagedSummary(
        restaurants: page1Restaurants,
        pagination: page1Meta,
        finalPrice: 100.0,
      );

      final viewModel = SubscriptionSummaryViewModel.withState(
        useCase,
        initialState: SubscriptionSummaryState(
          summary: initialSummary,
          activeRequest: baseRequest,
        ),
      );

      // Page 2 response has different price (server quote changed!)
      final changedQuoteSummary = buildPagedSummary(
        restaurants: const [
          SubscriptionSummaryRestaurantEntity(
            restaurantId: 'r-2',
            nameAr: 'مطعم 2',
            nameEn: 'Restaurant 2',
            tier: 'Basic',
          ),
        ],
        pagination: const PaginationEntity(
          page: 1,
          pageSize: 1,
          totalCount: 2,
          totalPages: 2,
          hasNextPage: true,
          hasPreviousPage: false,
        ),
        finalPrice: 120.0,
      );

      fakeRepo.immediateResult = ApiSuccessResult(data: changedQuoteSummary);

      viewModel.doIntent(const LoadMoreSubscriptionSummaryRestaurantsEvent());
      await pumpEventQueue();

      // Pricing changed -> emits new quote directly, not merged with old 100.0
      expect(viewModel.state.summary?.finalPrice, equals(120.0));
      expect(viewModel.state.summary?.restaurants.length, equals(1));
    });

    test('stale append response is discarded when parent summary generation changes', () async {
      const page1Meta = PaginationEntity(
        page: 1,
        pageSize: 1,
        totalCount: 2,
        totalPages: 2,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      final initialSummary = buildPagedSummary(
        restaurants: const [
          SubscriptionSummaryRestaurantEntity(
            restaurantId: 'r-1',
            nameAr: 'مطعم 1',
            nameEn: 'Restaurant 1',
            tier: 'Basic',
          ),
        ],
        pagination: page1Meta,
      );

      final viewModel = SubscriptionSummaryViewModel.withState(
        useCase,
        initialState: SubscriptionSummaryState(
          summary: initialSummary,
          activeRequest: baseRequest,
        ),
      );

      final appendCompleter = Completer<ApiResult<SubscriptionSummaryEntity>>();
      fakeRepo.nextResultCompleter = appendCompleter;

      viewModel.doIntent(const LoadMoreSubscriptionSummaryRestaurantsEvent());

      // While append is in flight, user refreshes summary
      final refreshedSummary = buildPagedSummary(
        restaurants: const [
          SubscriptionSummaryRestaurantEntity(
            restaurantId: 'r-new',
            nameAr: 'مطعم جديد',
            nameEn: 'New Restaurant',
            tier: 'Basic',
          ),
        ],
        pagination: page1Meta,
        finalPrice: 150.0,
      );
      fakeRepo.nextResultCompleter = null;
      fakeRepo.immediateResult = ApiSuccessResult(data: refreshedSummary);

      viewModel.doIntent(const GetSubscriptionSummaryEvent(baseRequest));
      await pumpEventQueue();

      expect(viewModel.state.summary?.finalPrice, equals(150.0));
      expect(viewModel.state.summary?.restaurants.first.restaurantId, equals('r-new'));

      // Now append from previous generation completes
      final oldAppendSummary = buildPagedSummary(
        restaurants: const [
          SubscriptionSummaryRestaurantEntity(
            restaurantId: 'r-old-page-2',
            nameAr: 'قديم',
            nameEn: 'Old',
            tier: 'Basic',
          ),
        ],
        pagination: const PaginationEntity(
          page: 2,
          pageSize: 1,
          totalCount: 2,
          totalPages: 2,
          hasNextPage: false,
          hasPreviousPage: true,
        ),
      );
      appendCompleter.complete(ApiSuccessResult(data: oldAppendSummary));
      await pumpEventQueue();

      // State was NOT overwritten with old append
      expect(viewModel.state.summary?.finalPrice, equals(150.0));
      expect(viewModel.state.summary?.restaurants.length, equals(1));
      expect(viewModel.state.summary?.restaurants.first.restaurantId, equals('r-new'));
    });
  });
}
