import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/repo/subscription_tier_repository.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/repo/subscription_plan_repository.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_readiness_usecase.dart';

class FakeSubscriptionPlanRepository implements SubscriptionPlanRepository {
  List<SubscriptionDurationEntity> durationsToReturn = [];
  bool? lastRequestedIncludeFriday;

  @override
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) async {
    lastRequestedIncludeFriday = includeFriday;
    return ApiSuccessResult(data: durationsToReturn);
  }

  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<SubscriptionTierRestaurantBrowseEntity>>>
  getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>>
  getTierRestaurantsPage({
    required String programId,
    required String bundleId,
    required String tier,
    required int page,
    required int pageSize,
    String? addressId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<SubscriptionRestaurantDetailsEntity>> getRestaurantDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
  }) async {
    throw UnimplementedError();
  }

}

class FakeSubscriptionTierRepository implements SubscriptionTierRepository {
  List<SubscriptionTierEntity> tiersToReturn = [];
  int? lastRequestedDurationDays;
  bool? lastRequestedIncludeFriday;

  @override
  Future<ApiResult<void>> checkPrerequisites() async {
    return ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
    String? familyMemberId,
  }) async {
    lastRequestedDurationDays = durationDays;
    lastRequestedIncludeFriday = includeFriday;
    return ApiSuccessResult(data: tiersToReturn);
  }

  @override
  Future<ApiResult<List<SubscriptionTierRestaurantBrowseEntity>>>
  getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
    String? familyMemberId,
  }) async {
    return ApiSuccessResult(data: []);
  }
}

class FakeSubscriptionSummaryRepository
    implements SubscriptionSummaryRepository {
  @override
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<SubscriptionReadinessEntity>> getReadiness(
    SubscriptionSummaryRequestEntity request,
  ) async {
    throw UnimplementedError();
  }
}

void main() {
  const sampleDurations = [
    SubscriptionDurationEntity(
      durationDays: 7,
      nameAr: 'أسبوع',
      nameEn: '1 Week',
      selectionCount: 10,
      isPopular: false,
      isCustom: false,
      minDays: null,
      maxDays: null,
      badge: null,
      supportsFriday: true,
      includeFriday: false,
      fridayDays: 1,
      totalServiceDays: 6,
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
    ),
    SubscriptionDurationEntity(
      durationDays: 30,
      nameAr: 'شهر',
      nameEn: '1 Month',
      selectionCount: 50,
      isPopular: true,
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
    ),
  ];

  const sampleTiers = [
    SubscriptionTierEntity(
      tier: 'standard',
      nameAr: 'الفئة الفضية',
      nameEn: 'Silver Tier',
      logoUrl: null,
      descriptionAr: 'وصف الفضي',
      descriptionEn: 'Silver description',
      restaurantCount: 5,
      restaurants: [],
      currencyCode: 'SAR',
      selectionCount: 10,
      isRecommended: false,
      includeFriday: false,
      totalPrice: 100.0,
      dailyPrice: 10.0,
    ),
    SubscriptionTierEntity(
      tier: 'vip',
      nameAr: 'الفئة الذهبية',
      nameEn: 'Gold Tier',
      logoUrl: null,
      descriptionAr: 'وصف الذهبي',
      descriptionEn: 'Gold description',
      restaurantCount: 12,
      restaurants: [],
      currencyCode: 'SAR',
      selectionCount: 20,
      isRecommended: true,
      includeFriday: false,
      totalPrice: 200.0,
      dailyPrice: 20.0,
    ),
  ];

  late FakeSubscriptionPlanRepository planRepo;
  late FakeSubscriptionTierRepository tierRepo;
  late SubscriptionPlanViewModel viewModel;

  setUp(() {
    planRepo = FakeSubscriptionPlanRepository();
    planRepo.durationsToReturn = sampleDurations;

    tierRepo = FakeSubscriptionTierRepository();
    tierRepo.tiersToReturn = sampleTiers;

    final readinessRepo = FakeSubscriptionSummaryRepository();

    viewModel = SubscriptionPlanViewModel(
      GetSubscriptionDurationsUseCase(planRepo),
      GetSubscriptionTiersUseCase(tierRepo),
      GetSubscriptionTierRestaurantsUseCase(tierRepo),
      GetSubscriptionReadinessUseCase(readinessRepo),
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  test('ToggleSubscriptionFridayEvent preserves selected duration and tier', () async {
    // 1. Initial load
    viewModel.doIntent(
      const GetSubscriptionDurationsEvent(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        includeFriday: false,
      ),
    );
    await pumpEventQueue();

    expect(viewModel.state.durations.length, 2);
    expect(viewModel.state.tiers.length, 2);

    // 2. User selects duration (30 days, index 1)
    viewModel.doIntent(
      const SelectSubscriptionDurationEvent(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        durationIndex: 1,
      ),
    );
    await pumpEventQueue();

    // 3. User selects tier ('vip', index 1)
    viewModel.doIntent(const SelectSubscriptionTierEvent(1));
    await pumpEventQueue();

    expect(viewModel.state.selectedDurationIndex, 1);
    expect(viewModel.state.selectedDuration?.durationDays, 30);
    expect(viewModel.state.selectedTierIndex, 1);
    expect(viewModel.state.selectedTier?.tier, 'vip');

    // 4. User toggles Friday to true
    viewModel.doIntent(
      const ToggleSubscriptionFridayEvent(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        includeFriday: true,
      ),
    );
    await pumpEventQueue();

    // 5. Verify selections are NOT cleared!
    expect(viewModel.state.includeFriday, isTrue);
    expect(tierRepo.lastRequestedDurationDays, 30);
    expect(tierRepo.lastRequestedIncludeFriday, isTrue);
    expect(viewModel.state.selectedDurationIndex, 1);
    expect(viewModel.state.selectedDuration?.durationDays, 30);
    expect(viewModel.state.selectedTierIndex, 1);
    expect(viewModel.state.selectedTier?.tier, 'vip');
  });

  test('BrowseSubscriptionTierRestaurantsEvent and CloseSubscriptionTierRestaurantsEvent toggle isBrowsingRestaurants', () async {
    viewModel.doIntent(
      const GetSubscriptionDurationsEvent(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        includeFriday: false,
      ),
    );
    await pumpEventQueue();

    expect(viewModel.state.isBrowsingRestaurants, isFalse);

    viewModel.doIntent(
      const BrowseSubscriptionTierRestaurantsEvent(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        tierIndex: 0,
      ),
    );
    await pumpEventQueue();

    expect(viewModel.state.isBrowsingRestaurants, isTrue);
    expect(viewModel.state.browsedTierIndex, 0);

    viewModel.doIntent(const CloseSubscriptionTierRestaurantsEvent());
    await pumpEventQueue();

    expect(viewModel.state.isBrowsingRestaurants, isFalse);
    expect(viewModel.state.browsedTierIndex, isNull);
  });
}
