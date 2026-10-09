import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/repo/subscription_tier_repository.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/repo/subscription_plan_repository.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_readiness_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_restaurant_availability_usecase.dart';

class MockSubscriptionSummaryRepository
    implements SubscriptionSummaryRepository {
  final List<SubscriptionSummaryRequestEntity> recordedRequests = [];
  Completer<ApiResult<SubscriptionRestaurantAvailabilityEntity>>?
  nextResultCompleter;
  ApiResult<SubscriptionRestaurantAvailabilityEntity>? defaultResult;

  @override
  Future<ApiResult<SubscriptionRestaurantAvailabilityEntity>>
  getRestaurantAvailability(SubscriptionSummaryRequestEntity request) async {
    recordedRequests.add(request);
    if (nextResultCompleter != null) {
      return nextResultCompleter!.future;
    }
    return defaultResult ??
        const ApiSuccessResult(
          data: SubscriptionRestaurantAvailabilityEntity(
            availability: SubscriptionAvailabilityEntity(
              status: 'available',
              coveredRestaurantCount: 3,
              eligibleRestaurantCount: 3,
              effectiveStartDate: '2026-10-11',
              messageCode: 'subscription_flow.available',
            ),
            totalCount: 3,
            restaurants: [
              SubscriptionSummaryRestaurantEntity(
                restaurantId: 'rest-1',
                nameAr: 'مطعم 1',
                nameEn: 'Restaurant 1',
                tier: 'Standard',
              ),
            ],
          ),
        );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeDurationsUseCase extends GetSubscriptionDurationsUseCase {
  FakeDurationsUseCase() : super(_NoopPlanRepository());
  @override
  Future<ApiResult<List<SubscriptionDurationEntity>>> call({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) async => const ApiSuccessResult(data: []);
}

class FakeTiersUseCase extends GetSubscriptionTiersUseCase {
  FakeTiersUseCase() : super(_NoopTierRepository());
  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> call({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
    String? familyMemberId,
  }) async => const ApiSuccessResult(data: []);
}

class FakeTierRestaurantsUseCase extends GetSubscriptionTierRestaurantsUseCase {
  FakeTierRestaurantsUseCase() : super(_NoopTierRepository());
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeReadinessUseCase extends GetSubscriptionReadinessUseCase {
  FakeReadinessUseCase() : super(_NoopSummaryRepository());
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopPlanRepository implements SubscriptionPlanRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopTierRepository implements SubscriptionTierRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopSummaryRepository implements SubscriptionSummaryRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _testTier = SubscriptionTierEntity(
  tier: 'Standard',
  nameAr: 'عادي',
  nameEn: 'Standard',
  logoUrl: '',
  descriptionAr: '',
  descriptionEn: '',
  restaurantCount: 1,
  restaurants: [],
  currencyCode: 'KWD',
  selectionCount: 1,
  isRecommended: false,
  includeFriday: false,
);

const _testDuration = SubscriptionDurationEntity(
  durationDays: 26,
  nameAr: '26 يوم',
  nameEn: '26 Days',
  selectionCount: 100,
  isPopular: false,
  isCustom: false,
  minDays: null,
  maxDays: null,
  badge: null,
  supportsFriday: true,
  includeFriday: false,
  fridayDays: 4,
  totalServiceDays: 26,
  fridayOption: SubscriptionFridayOptionEntity(
    code: 'standard',
    nameAr: 'الجمعة',
    nameEn: 'Friday',
    defaultSelected: false,
    isEnabled: true,
  ),
  fridayAvailability: SubscriptionFridayAvailabilityEntity(
    isAvailable: true,
    restaurantCount: 5,
    code: 'available',
    messageAr: 'متاح',
    messageEn: 'Available',
    displayType: 'banner',
  ),
);

void main() {
  group('Contextual Availability & Restaurant Browsing Tests (Task 3)', () {
    late MockSubscriptionSummaryRepository mockRepo;
    late GetSubscriptionRestaurantAvailabilityUseCase availabilityUseCase;
    late SubscriptionPlanViewModel viewModel;

    setUp(() {
      mockRepo = MockSubscriptionSummaryRepository();
      availabilityUseCase = GetSubscriptionRestaurantAvailabilityUseCase(
        mockRepo,
      );

      final initialTiers = [_testTier];
      final initialDurations = [_testDuration];

      viewModel = SubscriptionPlanViewModel.withState(
        FakeDurationsUseCase(),
        FakeTiersUseCase(),
        FakeTierRestaurantsUseCase(),
        FakeReadinessUseCase(),
        getSubscriptionRestaurantAvailabilityUseCase: availabilityUseCase,
        initialState: SubscriptionPlanState(
          durations: initialDurations,
          selectedDurationIndex: 0,
          tiers: initialTiers,
          selectedTierIndex: 0,
          selectedStartDate: '2026-10-08',
        ),
      );
    });

    tearDown(() {
      viewModel.close();
    });

    test(
      'Missing anchor date emits selection_required without calling backend',
      () async {
        final noDateViewModel = SubscriptionPlanViewModel.withState(
          FakeDurationsUseCase(),
          FakeTiersUseCase(),
          FakeTierRestaurantsUseCase(),
          FakeReadinessUseCase(),
          getSubscriptionRestaurantAvailabilityUseCase: availabilityUseCase,
          initialState: const SubscriptionPlanState(tiers: [_testTier]),
        );

        noDateViewModel.doIntent(
          const BrowseSubscriptionTierRestaurantsEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            tierIndex: 0,
          ),
        );

        await pumpEventQueue();

        expect(mockRepo.recordedRequests.isEmpty, isTrue);
        expect(
          noDateViewModel.state.browseAvailability?.status,
          equals('selection_required'),
        );
        expect(noDateViewModel.state.browseRestaurants.isEmpty, isTrue);

        noDateViewModel.close();
      },
    );

    test(
      'Geographic coverage with zero period eligibility shows no available restaurants',
      () async {
        mockRepo.defaultResult = const ApiSuccessResult(
          data: SubscriptionRestaurantAvailabilityEntity(
            availability: SubscriptionAvailabilityEntity(
              status: 'no_restaurants_for_selection',
              coveredRestaurantCount: 4,
              eligibleRestaurantCount: 0,
              effectiveStartDate: '2026-10-11',
              messageCode: 'subscription_flow.no_restaurants_for_selection',
            ),
            totalCount: 0,
            restaurants: [
              SubscriptionSummaryRestaurantEntity(
                restaurantId: 'covered-but-ineligible',
                nameAr: 'مطعم',
                nameEn: 'Restaurant',
                tier: 'Standard',
              ),
            ],
          ),
        );

        viewModel.doIntent(
          const BrowseSubscriptionTierRestaurantsEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            tierIndex: 0,
          ),
        );

        await pumpEventQueue();

        expect(
          viewModel.state.browseAvailability?.status,
          equals('no_restaurants_for_selection'),
        );
        expect(
          viewModel.state.browseAvailability?.coveredRestaurantCount,
          equals(4),
        );
        expect(
          viewModel.state.browseAvailability?.eligibleRestaurantCount,
          equals(0),
        );
        // Ineligible cards must not be exposed as available
        expect(viewModel.state.browseRestaurants.isEmpty, isTrue);
      },
    );

    test(
      'Stale request A completing after newer request B is discarded',
      () async {
        final completerA =
            Completer<ApiResult<SubscriptionRestaurantAvailabilityEntity>>();
        final completerB =
            Completer<ApiResult<SubscriptionRestaurantAvailabilityEntity>>();

        mockRepo.nextResultCompleter = completerA;

        viewModel.doIntent(
          const BrowseSubscriptionTierRestaurantsEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            tierIndex: 0,
            startDate: '2026-10-08',
          ),
        );

        // Now start request B with different date
        mockRepo.nextResultCompleter = completerB;
        viewModel.doIntent(
          const BrowseSubscriptionTierRestaurantsEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            tierIndex: 0,
            startDate: '2026-10-15',
          ),
        );

        // Complete B first
        completerB.complete(
          ApiSuccessResult(
            data: const SubscriptionRestaurantAvailabilityEntity(
              availability: SubscriptionAvailabilityEntity(
                status: 'available',
                coveredRestaurantCount: 1,
                eligibleRestaurantCount: 1,
                effectiveStartDate: '2026-10-18',
                messageCode: 'subscription_flow.available',
              ),
              totalCount: 1,
              restaurants: [
                SubscriptionSummaryRestaurantEntity(
                  restaurantId: 'rest-B',
                  nameAr: 'مطعم B',
                  nameEn: 'Restaurant B',
                  tier: 'Standard',
                ),
              ],
            ),
          ),
        );

        await pumpEventQueue();

        expect(
          viewModel.state.browseRestaurants.map((r) => r.restaurantId),
          contains('rest-B'),
        );

        // Now stale request A completes
        completerA.complete(
          const ApiSuccessResult(
            data: SubscriptionRestaurantAvailabilityEntity(
              availability: SubscriptionAvailabilityEntity(
                status: 'available',
                coveredRestaurantCount: 2,
                eligibleRestaurantCount: 2,
                effectiveStartDate: '2026-10-11',
                messageCode: 'subscription_flow.available',
              ),
              totalCount: 2,
              restaurants: [
                SubscriptionSummaryRestaurantEntity(
                  restaurantId: 'rest-A',
                  nameAr: 'مطعم A',
                  nameEn: 'Restaurant A',
                  tier: 'Standard',
                ),
              ],
            ),
          ),
        );

        await pumpEventQueue();

        // State must retain B's data, NOT overridden by stale A
        expect(
          viewModel.state.browseRestaurants.map((r) => r.restaurantId),
          contains('rest-B'),
        );
        expect(
          viewModel.state.browseRestaurants.map((r) => r.restaurantId),
          isNot(contains('rest-A')),
        );
      },
    );

    test(
      'Pagination appends and deduplicates restaurants for the same context',
      () async {
        // First page
        mockRepo.defaultResult = ApiSuccessResult(
          data: const SubscriptionRestaurantAvailabilityEntity(
            availability: SubscriptionAvailabilityEntity(
              status: 'available',
              coveredRestaurantCount: 2,
              eligibleRestaurantCount: 2,
              effectiveStartDate: '2026-10-11',
              messageCode: 'subscription_flow.available',
            ),
            totalCount: 2,
            pagination: PaginationEntity(
              page: 1,
              pageSize: 1,
              totalCount: 2,
              totalPages: 2,
              hasNextPage: true,
              hasPreviousPage: false,
            ),
            restaurants: [
              SubscriptionSummaryRestaurantEntity(
                restaurantId: 'rest-1',
                nameAr: 'مطعم 1',
                nameEn: 'Restaurant 1',
                tier: 'Standard',
              ),
            ],
          ),
        );

        viewModel.doIntent(
          const BrowseSubscriptionTierRestaurantsEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            tierIndex: 0,
          ),
        );

        await pumpEventQueue();
        expect(viewModel.state.browseRestaurants.length, equals(1));

        // Page 2
        mockRepo.defaultResult = ApiSuccessResult(
          data: const SubscriptionRestaurantAvailabilityEntity(
            availability: SubscriptionAvailabilityEntity(
              status: 'available',
              coveredRestaurantCount: 2,
              eligibleRestaurantCount: 2,
              effectiveStartDate: '2026-10-11',
              messageCode: 'subscription_flow.available',
            ),
            totalCount: 2,
            pagination: PaginationEntity(
              page: 2,
              pageSize: 1,
              totalCount: 2,
              totalPages: 2,
              hasNextPage: false,
              hasPreviousPage: true,
            ),
            restaurants: [
              SubscriptionSummaryRestaurantEntity(
                restaurantId: 'rest-1', // duplicate ID
                nameAr: 'مطعم 1',
                nameEn: 'Restaurant 1',
                tier: 'Standard',
              ),
              SubscriptionSummaryRestaurantEntity(
                restaurantId: 'rest-2',
                nameAr: 'مطعم 2',
                nameEn: 'Restaurant 2',
                tier: 'Standard',
              ),
            ],
          ),
        );

        viewModel.doIntent(const LoadMoreSubscriptionTierRestaurantsEvent());
        await pumpEventQueue();

        expect(viewModel.state.browseRestaurants.length, equals(2));
        expect(
          viewModel.state.browseRestaurants[0].restaurantId,
          equals('rest-1'),
        );
        expect(
          viewModel.state.browseRestaurants[1].restaurantId,
          equals('rest-2'),
        );
      },
    );

    test(
      'Pagination load-more failure preserves existing list and does not mark no_restaurants',
      () async {
        mockRepo.defaultResult = ApiSuccessResult(
          data: const SubscriptionRestaurantAvailabilityEntity(
            availability: SubscriptionAvailabilityEntity(
              status: 'available',
              coveredRestaurantCount: 2,
              eligibleRestaurantCount: 2,
              effectiveStartDate: '2026-10-11',
              messageCode: 'subscription_flow.available',
            ),
            totalCount: 2,
            pagination: PaginationEntity(
              page: 1,
              pageSize: 1,
              totalCount: 2,
              totalPages: 2,
              hasNextPage: true,
              hasPreviousPage: false,
            ),
            restaurants: [
              SubscriptionSummaryRestaurantEntity(
                restaurantId: 'rest-1',
                nameAr: 'مطعم 1',
                nameEn: 'Restaurant 1',
                tier: 'Standard',
              ),
            ],
          ),
        );

        viewModel.doIntent(
          const BrowseSubscriptionTierRestaurantsEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            tierIndex: 0,
          ),
        );
        await pumpEventQueue();

        // Next page fails
        mockRepo.defaultResult = ApiErrorResult(
          failure: Failure(errorMessage: 'Timeout', code: 'network_error'),
        );

        viewModel.doIntent(const LoadMoreSubscriptionTierRestaurantsEvent());
        await pumpEventQueue();

        expect(viewModel.state.browseRestaurants.length, equals(1));
        expect(viewModel.state.browseAvailability?.status, equals('available'));
        expect(viewModel.state.browseRestaurantsLoadMoreFailure, isNotNull);
      },
    );
  });
}
