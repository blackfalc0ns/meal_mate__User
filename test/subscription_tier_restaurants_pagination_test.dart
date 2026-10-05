import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_page_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_readiness_usecase.dart';

void main() {
  const List<SubscriptionTierEntity> sampleTiers = [
    SubscriptionTierEntity(
      tier: 'standard',
      nameAr: 'الأساسي',
      nameEn: 'Standard',
      logoUrl: null,
      descriptionAr: '',
      descriptionEn: '',
      restaurantCount: 0,
      restaurants: [],
      currencyCode: 'KWD',
      selectionCount: 0,
      isRecommended: false,
      includeFriday: false,
    ),
    SubscriptionTierEntity(
      tier: 'premium',
      nameAr: 'المميز',
      nameEn: 'Premium',
      logoUrl: null,
      descriptionAr: '',
      descriptionEn: '',
      restaurantCount: 0,
      restaurants: [],
      currencyCode: 'KWD',
      selectionCount: 0,
      isRecommended: true,
      includeFriday: false,
    ),
  ];

  SubscriptionTierRestaurantBrowseEntity createRestaurant(String id, String name) {
    return SubscriptionTierRestaurantBrowseEntity(
      restaurantId: id,
      nameRaw: name,
      nameAr: name,
      nameEn: name,
      logoUrl: null,
      rating: 4.5,
      mealCount: 5,
      bundleMealCount: 1,
      tier: 'standard',
      tierNameRaw: 'Standard',
      tierNameAr: 'الأساسي',
      tierNameEn: 'Standard',
      tierLogoUrl: null,
      classifications: const [],
    );
  }



  group('SubscriptionPlanViewModel Tier Restaurants Pagination Tests', () {
    test('initial browse tier restaurants fetches page 1 and keeps selectedTierIndex separate', () async {
      final mockPageUseCase = _MockTierRestaurantsPageUseCase((page, tier) async {
        return ApiSuccessResult(
          data: PagedEntity(
            items: [
              createRestaurant('rest-1', 'Restaurant 1'),
              createRestaurant('rest-2', 'Restaurant 2'),
            ],
            pagination: const PaginationEntity(
              totalCount: 4,
              page: 1,
              pageSize: 2,
              totalPages: 2,
              hasNextPage: true,
              hasPreviousPage: false,
            ),
          ),
        );
      });

      final viewModel = SubscriptionPlanViewModel.withState(
        _UnusedDurationsUseCase(),
        _FakeTiersUseCase(sampleTiers),
        _UnusedTierRestaurantsUseCase(),
        _UnusedReadinessUseCase(),
        getSubscriptionTierRestaurantsPageUseCase: mockPageUseCase,
        initialState: const SubscriptionPlanState(tiers: sampleTiers),
      );


      addTearDown(viewModel.close);

      // Initially set selectedTierIndex to 0
      viewModel.doIntent(const SelectSubscriptionTierEvent(0));
      expect(viewModel.state.selectedTierIndex, equals(0));

      // Browse tier 1 (premium, index 1)
      viewModel.doIntent(
        const BrowseSubscriptionTierRestaurantsEvent(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tierIndex: 1,
        ),
      );

      await expectLater(
        viewModel.stream,
        emitsThrough(
          isA<dynamic>()
              .having((s) => s.browsedTierIndex, 'browsedTierIndex', 1)
              .having((s) => s.selectedTierIndex, 'selectedTierIndex', 0) // Unchanged!
              .having((s) => s.browseRestaurants.length, 'count', 2)
              .having(
                (s) => s.browseRestaurantsPagination?.hasNextPage,
                'hasNext',
                true,
              ),
        ),
      );

      expect(mockPageUseCase.lastRequestedPage, equals(1));
      expect(mockPageUseCase.lastRequestedTier, equals('premium'));
    });

    test('load more appends page 2 without duplicates', () async {
      var callCount = 0;
      final mockPageUseCase = _MockTierRestaurantsPageUseCase((page, tier) async {
        callCount++;
        if (page == 1) {
          return ApiSuccessResult(
            data: PagedEntity(
              items: [
                createRestaurant('rest-1', 'Restaurant 1'),
                createRestaurant('rest-2', 'Restaurant 2'),
              ],
              pagination: const PaginationEntity(
                totalCount: 3,
                page: 1,
                pageSize: 2,
                totalPages: 2,
                hasNextPage: true,
                hasPreviousPage: false,
              ),
            ),
          );
        } else {
          return ApiSuccessResult(
            data: PagedEntity(
              items: [
                createRestaurant('rest-2', 'Restaurant 2 Duplicate'), // Should be deduped
                createRestaurant('rest-3', 'Restaurant 3'),
              ],
              pagination: const PaginationEntity(
                totalCount: 3,
                page: 2,
                pageSize: 2,
                totalPages: 2,
                hasNextPage: false,
                hasPreviousPage: true,
              ),
            ),
          );
        }
      });

      final viewModel = SubscriptionPlanViewModel.withState(
        _UnusedDurationsUseCase(),
        _FakeTiersUseCase(sampleTiers),
        _UnusedTierRestaurantsUseCase(),
        _UnusedReadinessUseCase(),
        getSubscriptionTierRestaurantsPageUseCase: mockPageUseCase,
        initialState: const SubscriptionPlanState(tiers: sampleTiers),
      );


      addTearDown(viewModel.close);

      viewModel.doIntent(
        const BrowseSubscriptionTierRestaurantsEvent(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tierIndex: 0,
        ),
      );

      await expectLater(
        viewModel.stream,
        emitsThrough(
          isA<dynamic>().having((s) => s.browseRestaurants.length, 'count', 2),
        ),
      );

      viewModel.doIntent(const LoadMoreSubscriptionTierRestaurantsEvent());

      await expectLater(
        viewModel.stream,
        emitsThrough(
          isA<dynamic>()
              .having((s) => s.browseRestaurants.length, 'count', 3)
              .having(
                (s) => s.browseRestaurants.map((r) => r.restaurantId).toList(),
                'ids',
                ['rest-1', 'rest-2', 'rest-3'],
              )
              .having(
                (s) => s.browseRestaurantsPagination?.hasNextPage,
                'hasNext',
                false,
              ),
        ),
      );

      expect(callCount, equals(2));
    });

    test('close restaurants cancels pending request and clears state', () async {
      final completer = Completer<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>>();
      final mockPageUseCase = _MockTierRestaurantsPageUseCase((page, tier) => completer.future);

      final viewModel = SubscriptionPlanViewModel.withState(
        _UnusedDurationsUseCase(),
        _FakeTiersUseCase(sampleTiers),
        _UnusedTierRestaurantsUseCase(),
        _UnusedReadinessUseCase(),
        getSubscriptionTierRestaurantsPageUseCase: mockPageUseCase,
        initialState: const SubscriptionPlanState(tiers: sampleTiers),
      );


      addTearDown(viewModel.close);

      viewModel.doIntent(
        const BrowseSubscriptionTierRestaurantsEvent(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tierIndex: 0,
        ),
      );

      expect(viewModel.state.isBrowseRestaurantsLoading, isTrue);

      // Close before completer completes
      viewModel.doIntent(const CloseSubscriptionTierRestaurantsEvent());

      expect(viewModel.state.isBrowseRestaurantsLoading, isFalse);
      expect(viewModel.state.browsedTierIndex, isNull);
      expect(viewModel.state.browseRestaurants, isEmpty);

      // When response completes later, it must be ignored
      completer.complete(
        ApiSuccessResult(
          data: PagedEntity(
            items: [createRestaurant('rest-99', 'Ghost')],
            pagination: const PaginationEntity(
              totalCount: 1,
              page: 1,
              pageSize: 10,
              totalPages: 1,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
          ),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(viewModel.state.browseRestaurants, isEmpty);
      expect(viewModel.state.browsedTierIndex, isNull);
    });

    test('load more failure preserves existing items and records failure', () async {
      final mockPageUseCase = _MockTierRestaurantsPageUseCase((page, tier) async {
        if (page == 1) {
          return ApiSuccessResult(
            data: PagedEntity(
              items: [createRestaurant('rest-1', 'Restaurant 1')],
              pagination: const PaginationEntity(
                totalCount: 2,
                page: 1,
                pageSize: 1,
                totalPages: 2,
                hasNextPage: true,
                hasPreviousPage: false,
              ),
            ),
          );
        } else {
          return ApiErrorResult(
            failure: ServerFailure(
              code: 'load_more_failed',
              errorMessage: 'Load more failed',
              exception: const ApiException(
                errorType: ApiErrorType.unknown,
                message: 'Load more failed',
              ),
            ),
          );



        }
      });

      final viewModel = SubscriptionPlanViewModel.withState(
        _UnusedDurationsUseCase(),
        _FakeTiersUseCase(sampleTiers),
        _UnusedTierRestaurantsUseCase(),
        _UnusedReadinessUseCase(),
        getSubscriptionTierRestaurantsPageUseCase: mockPageUseCase,
        initialState: const SubscriptionPlanState(tiers: sampleTiers),
      );


      addTearDown(viewModel.close);

      viewModel.doIntent(
        const BrowseSubscriptionTierRestaurantsEvent(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tierIndex: 0,
        ),
      );

      await expectLater(
        viewModel.stream,
        emitsThrough(
          isA<dynamic>().having((s) => s.browseRestaurants.length, 'count', 1),
        ),
      );

      viewModel.doIntent(const LoadMoreSubscriptionTierRestaurantsEvent());

      await expectLater(
        viewModel.stream,
        emitsThrough(
          isA<dynamic>()
              .having((s) => s.browseRestaurants.length, 'count', 1)
              .having(
                (s) => s.browseRestaurantsLoadMoreFailure?.code,
                'failure code',
                'load_more_failed',
              ),
        ),
      );
    });
  });
}

class _MockTierRestaurantsPageUseCase extends Fake
    implements GetSubscriptionTierRestaurantsPageUseCase {
  _MockTierRestaurantsPageUseCase(this._handler);

  final Future<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>>
      Function(int page, String tier) _handler;

  int? lastRequestedPage;
  String? lastRequestedTier;

  @override
  Future<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>> call({
    required String programId,
    required String bundleId,
    required String tier,
    required int page,
    required int pageSize,
    String? addressId,
  }) {
    lastRequestedPage = page;
    lastRequestedTier = tier;
    return _handler(page, tier);
  }
}

class _FakeTiersUseCase extends Fake implements GetSubscriptionTiersUseCase {
  _FakeTiersUseCase(this.tiers);

  final List<SubscriptionTierEntity> tiers;

  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> call({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
    String? addressId,
    String? familyMemberId,
  }) async {
    return ApiSuccessResult(data: tiers);
  }
}

class _UnusedDurationsUseCase extends Fake
    implements GetSubscriptionDurationsUseCase {}

class _UnusedTierRestaurantsUseCase extends Fake
    implements GetSubscriptionTierRestaurantsUseCase {}

class _UnusedReadinessUseCase extends Fake
    implements GetSubscriptionReadinessUseCase {}
