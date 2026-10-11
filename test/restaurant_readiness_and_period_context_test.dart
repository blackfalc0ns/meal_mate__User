import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_page_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_readiness_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_restaurant_availability_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_availability_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_summary_mapper.dart';

void main() {
  group('Task 1: Logo Guarding and Readiness Separation Tests', () {
    test(
      'positive coveredRestaurantCount with canSelect=false produces empty logos, count 0, and blocked selection',
      () {
        const availability = SubscriptionAvailabilityEntity(
          status: 'coverage_only',
          coveredRestaurantCount: 12,
          effectiveStartDate: '',
          messageCode: 'subscription_flow.no_prepared_restaurants',
          canSelect: false,
        );

        const bundle = SubscriptionBundleEntity(
          bundleId: 'bundle-1',
          programId: 'program-1',
          code: 'CODE-1',
          nameAr: 'باقة تجريبية',
          nameEn: 'Trial Bundle',
          descriptionAr: 'وصف',
          descriptionEn: 'Desc',
          imageUrl: null,
          mealsPerDay: 2,
          breakfastCount: 1,
          lunchCount: 1,
          dinnerCount: 0,
          snackCount: 0,
          slots: [],
          restaurantCount: 12,
          restaurants: [
            SubscriptionBundleRestaurantEntity(
              restaurantId: 'rest-1',
              logoUrl: 'https://cdn.example.com/logo1.png',
            ),
            SubscriptionBundleRestaurantEntity(
              restaurantId: 'rest-2',
              logoUrl: 'https://cdn.example.com/logo2.png',
            ),
          ],
          selectionCount: 10,
          isMostSelected: false,
          badge: null,
          isAvailable: true,
          availability: availability,
        );

        expect(bundle.canSelect, isFalse);
        expect(bundle.restaurantLogoUrls, isEmpty);
        expect(bundle.effectiveRestaurantCount, 0);
        expect(bundle.restaurants, isEmpty);

        const tier = SubscriptionTierEntity(
          tier: 'standard',
          nameAr: 'الأساسي',
          nameEn: 'Standard',
          logoUrl: null,
          descriptionAr: 'وصف',
          descriptionEn: 'Desc',
          restaurantCount: 12,
          restaurants: [
            SubscriptionTierRestaurantEntity(
              restaurantId: 'rest-1',
              logoUrl: 'https://cdn.example.com/logo1.png',
            ),
          ],
          currencyCode: 'KWD',
          selectionCount: 5,
          isRecommended: false,
          includeFriday: false,
          canSelect: false,
          availability: availability,
        );

        expect(tier.effectiveCanSelect, isFalse);
        expect(tier.restaurants, isEmpty);
        expect(tier.effectiveRestaurantCount, 0);

        final packageTier = tier.toPackageTier('en');
        expect(packageTier.canSelect, isFalse);
        expect(packageTier.restaurantCount, 0);
        expect(packageTier.restaurantLogoUrls, isEmpty);

        final uiModel = tier.toTierUiModel('en');
        expect(uiModel.canSelect, isFalse);
        expect(uiModel.restaurantCount, 0);
        expect(uiModel.restaurantLogoUrls, isEmpty);
      },
    );

    test(
      'missing address, allergies, or dietary preferences clears logos and marks canSelect=false',
      () {
        for (final status in [
          'address_required',
          'allergies_required',
          'dietary_preferences_required',
        ]) {
          final avail = SubscriptionAvailabilityEntity(
            status: status,
            coveredRestaurantCount: 10,
            effectiveStartDate: '',
            messageCode: 'checkout.$status',
          );

          final bundle = SubscriptionBundleEntity(
            bundleId: 'bundle-x',
            programId: 'program-x',
            code: 'X',
            nameAr: 'باقة',
            nameEn: 'Bundle',
            descriptionAr: '',
            descriptionEn: '',
            imageUrl: null,
            mealsPerDay: 1,
            breakfastCount: 1,
            lunchCount: 0,
            dinnerCount: 0,
            snackCount: 0,
            slots: const [],
            restaurantCount: 10,
            restaurants: const [
              SubscriptionBundleRestaurantEntity(
                restaurantId: 'r1',
                logoUrl: 'https://img.com/1.png',
              ),
            ],
            selectionCount: 1,
            isMostSelected: false,
            badge: null,
            availability: avail,
          );

          expect(bundle.canSelect, isFalse);
          expect(bundle.restaurantLogoUrls, isEmpty);
          expect(bundle.effectiveRestaurantCount, 0);
          expect(bundle.restaurants, isEmpty);
        }
      },
    );

    test(
      'checkoutBlockReason with no_prepared_restaurants sets hasRestaurantCoverageBlock and blocks checkout',
      () {
        const readiness = SubscriptionReadinessEntity(
          isComplete: true,
          canOpenSummary: true,
          canCheckout: false,
          nextAction: 'SUMMARY',
          warningAr: 'لا توجد مطاعم جاهزة',
          warningEn: 'No prepared restaurants',
          checkoutBlockReason: 'subscription_flow.no_prepared_restaurants',
          deliveringRestaurantCount: 5,
          items: [],
          restaurants: [],
        );

        expect(readiness.hasRestaurantCoverageBlock, isTrue);

        const summaryState = SubscriptionSummaryState(
          summary: SubscriptionSummaryEntity(
            programId: 'p1',
            programNameAr: 'برنامج',
            programNameEn: 'Program',
            bundleId: 'b1',
            bundleNameAr: 'باقة',
            bundleNameEn: 'Bundle',
            restaurantCount: 5,
            tier: 'standard',
            tierNameAr: 'الأساسي',
            tierNameEn: 'Standard',
            durationDays: 20,
            chosenStartDate: '2026-10-15',
            startDate: '2026-10-15',
            endDate: '2026-11-05',
            serviceDates: [],
            slotRequirements: [],
            basePrice: 50,
            campaignDiscount: 0,
            promoDiscount: 0,
            walletCredit: 0,
            gatewayFee: 0,
            finalPrice: 50,
            currencyCode: 'KWD',
            canCheckout: true,
            restaurants: [],
            termsAcceptanceRequired: false,
            checkoutEndpoint: '',
            includeFriday: false,
            fridayDays: 0,
            totalServiceDays: 20,
            includes: SubscriptionSummaryIncludesEntity(
              titleAr: '',
              titleEn: '',
              items: [],
            ),
            availability: SubscriptionAvailabilityEntity(
              status: 'no_prepared_restaurants',
              coveredRestaurantCount: 5,
              effectiveStartDate: '2026-10-15',
              messageCode: 'subscription_flow.no_prepared_restaurants',
              failureReasons: ['no_prepared_restaurants'],
            ),
          ),
        );

        expect(summaryState.canCheckout, isFalse);
      },
    );

    test(
      'handles failureReasons as a Map like {"tier_mismatch": 2} in availability and summary response',
      () {
        final availabilityJson = {
          'status': 'available',
          'coveredRestaurantCount': 4,
          'eligibleRestaurantCount': 2,
          'checkedAtUtc': '2026-10-11T05:25:22.4896878Z',
          'effectiveStartDate': '2026-10-15',
          'messageCode': null,
          'failureReasons': {'tier_mismatch': 2},
        };

        final dto =
            SubscriptionAvailabilityResponseDto.fromJson(availabilityJson);
        expect(dto.failureReasons, ['tier_mismatch']);
        expect(dto.failureReasonCounts, {'tier_mismatch': 2});

        final entity = dto.toEntity();
        expect(entity.failureReasons, ['tier_mismatch']);
        expect(entity.failureReasonCounts, {'tier_mismatch': 2});
        expect(entity.isAvailable, isTrue);
        expect(entity.isNoPreparedRestaurants, isFalse);
        expect(entity.effectiveCanSelect, isTrue);

        final summaryJson = {
          'programId': 'dd12dfbc-3987-4e38-83af-664b6963c04c',
          'programNameAr': 'خسارة الوزن',
          'programImageUrl': null,
          'bundleId': 'ae827912-199d-49e8-b1fc-3390fc96b2e6',
          'bundleNameAr': 'ريوق + غداء + سناك',
          'imageUrl': null,
          'restaurantCount': 2,
          'tier': 'Basic',
          'tierNameAr': 'أساسي',
          'durationDays': 26,
          'startDate': '2026-10-15',
          'endDate': '2026-11-14',
          'serviceDates': ['2026-10-15', '2026-10-17'],
          'slotRequirements': [
            {
              'slot': 'breakfast',
              'nameAr': 'الإفطار',
              'count': 1,
              'name': 'الإفطار',
            },
            {
              'slot': 'lunch',
              'nameAr': 'الغداء',
              'count': 1,
              'name': 'الغداء',
            },
            {
              'slot': 'snack',
              'nameAr': 'سناك',
              'count': 1,
              'name': 'سناك',
            },
          ],
          'basePrice': 108.1,
          'campaignDiscount': 0,
          'promoDiscount': 0,
          'walletCredit': 0,
          'gatewayFee': 2.926,
          'finalPrice': 111.25,
          'currencyCode': 'KWD',
          'termsAcceptanceRequired': true,
          'checkoutEndpoint': 'POST /api/v1/customer/subscriptions/checkout',
          'includeFriday': false,
          'fridayDays': 0,
          'totalServiceDays': 26,
          'includes': {
            'titleAr': 'يشمل اشتراكك',
            'items': [
              {
                'code': 'RESTAURANTS',
                'textAr': 'مطعمَان في هذا التصنيف',
                'text': 'مطعمَان في هذا التصنيف',
              },
              {
                'code': 'SERVICE_DAYS',
                'textAr': '26 يوم خدمة',
                'text': '26 يوم خدمة',
              },
              {
                'code': 'MEAL_VARIETY',
                'textAr': '8 وجبات معتمدة للاختيار',
                'text': '8 وجبات معتمدة للاختيار',
              },
            ],
            'title': 'يشمل اشتراكك',
          },
          'address': {
            'id': '0ee3a86e-6a77-4fc8-b80f-65d324353278',
            'label': 'المنزل',
            'addressLine': 'حولي, السالمية, قطعة 3, شارع 2, جادة 2, ٣',
            'governorate': 'حولي',
            'area': 'السالمية',
            'block': 'قطعة 3',
            'regionId': '20344d90-d50d-4607-8101-f25ac40e229c',
            'governorateNameAr': 'حولي',
            'areaNameAr': 'السالمية',
            'blockNameAr': 'قطعة 3',
            'governorateName': 'حولي',
            'areaName': 'السالمية',
            'blockName': 'قطعة 3',
          },
          'restaurants': [
            {
              'restaurantId': 'f8575d1f-943e-455b-bd45-12b5af4eb097',
              'nameAr': '[تجربة] مطبخ دايت كير',
              'logoUrl':
                  'https://ik.imagekit.io/f7h9cj23x/catalog/restaurants/logo-diet-care.png',
              'tier': 'Basic',
              'name': '[تجربة] مطبخ دايت كير',
            },
            {
              'restaurantId': '7ccfc18b-8f31-43c2-8bbf-ca61ee7c95ec',
              'nameAr': '[تجربة] جرين بول',
              'logoUrl':
                  'https://ik.imagekit.io/f7h9cj23x/catalog/restaurants/logo-green-bowl.png',
              'tier': 'Basic',
              'name': '[تجربة] جرين بول',
            },
          ],
          'canCheckout': true,
          'checkoutBlockReason': null,
          'chosenStartDate': '2026-10-11',
          'restaurantRepetition': {
            'limit': 8,
            'restaurantCount': 2,
            'durationDays': 26,
          },
          'restaurantsPagination': null,
          'coupon': null,
          'availability': availabilityJson,
          'programName': 'خسارة الوزن',
          'bundleName': 'ريوق + غداء + سناك',
          'tierName': 'أساسي',
        };

        final summaryDto = SubscriptionSummaryResponseDto.fromJson(summaryJson);
        final summaryEntity = summaryDto.toEntity();

        expect(summaryEntity.canCheckout, isTrue);
        expect(summaryEntity.programNameAr, 'خسارة الوزن');
        expect(summaryEntity.bundleNameAr, 'ريوق + غداء + سناك');
        expect(summaryEntity.tierNameAr, 'أساسي');
        expect(summaryEntity.restaurants.length, 2);
        expect(summaryEntity.availability?.failureReasons, ['tier_mismatch']);
        expect(
          summaryEntity.availability?.failureReasonCounts,
          {'tier_mismatch': 2},
        );

        final state = SubscriptionSummaryState(summary: summaryEntity);
        expect(state.canCheckout, isTrue);
      },
    );
  });

  group('Task 2 & 4: Period Context and Restaurant Browsing Flow Tests', () {
    const sampleTiers = [
      SubscriptionTierEntity(
        tier: 'standard',
        nameAr: 'الأساسي',
        nameEn: 'Standard',
        logoUrl: null,
        descriptionAr: '',
        descriptionEn: '',
        restaurantCount: 2,
        restaurants: [
          SubscriptionTierRestaurantEntity(
            restaurantId: 'r1',
            logoUrl: 'https://img.com/1.png',
          ),
        ],
        currencyCode: 'KWD',
        selectionCount: 1,
        isRecommended: false,
        includeFriday: false,
        totalPrice: 40.0,
        canSelect: true,
        isAvailable: true,
      ),
    ];

    test(
      'passes durationDays, startDate, includeFriday to tier restaurants page use case',
      () async {
        int? capturedDurationDays;
        String? capturedStartDate;
        bool? capturedIncludeFriday;

        final mockPageUseCase = _MockPageUseCase((
          page,
          tier,
          durationDays,
          startDate,
          includeFriday,
        ) async {
          capturedDurationDays = durationDays;
          capturedStartDate = startDate;
          capturedIncludeFriday = includeFriday;
          return const ApiSuccessResult(
            data: PagedEntity(
              items: [
                SubscriptionTierRestaurantBrowseEntity(
                  restaurantId: 'rest-1',
                  nameRaw: 'Rest 1',
                  nameAr: 'مطعم 1',
                  nameEn: 'Rest 1',
                  logoUrl: null,
                  rating: 4.8,
                  mealCount: 10,
                  bundleMealCount: 2,
                  tier: 'standard',
                  tierNameRaw: 'Standard',
                  tierNameAr: 'الأساسي',
                  tierNameEn: 'Standard',
                  tierLogoUrl: null,
                  classifications: [],
                ),
              ],
              pagination: PaginationEntity(
                totalCount: 1,
                page: 1,
                pageSize: 10,
                totalPages: 1,
                hasNextPage: false,
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
          initialState: SubscriptionPlanState(
            tiers: sampleTiers,
            durations: [_createDuration(24)],
            selectedDurationIndex: 0,
            selectedStartDate: '2026-10-20',
            includeFriday: true,
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

        expect(capturedDurationDays, 24);
        expect(capturedStartDate, '2026-10-20');
        expect(capturedIncludeFriday, isTrue);
        expect(viewModel.state.browseRestaurants.length, 1);
        expect(viewModel.state.browseRestaurantsFailure, isNull);
      },
    );

    test(
      'when availability reports no_prepared_restaurants, does NOT convert to successful empty list but emits browseRestaurantsFailure',
      () async {
        final mockAvailabilityUseCase = _MockRestaurantAvailabilityUseCase((
          request,
        ) async {
          return const ApiSuccessResult(
            data: SubscriptionRestaurantAvailabilityEntity(
              availability: SubscriptionAvailabilityEntity(
                status: 'no_prepared_restaurants',
                coveredRestaurantCount: 4,
                effectiveStartDate: '2026-10-20',
                messageCode: 'subscription_flow.no_prepared_restaurants',
                failureReasons: ['no_prepared_restaurants'],
              ),
              restaurants: [
                SubscriptionSummaryRestaurantEntity(
                  restaurantId: 'rest-1',
                  nameAr: 'مطعم',
                  nameEn: 'Rest',
                  tier: 'standard',
                ),
              ],
              totalCount: 4,
              pagination: PaginationEntity(
                totalCount: 4,
                page: 1,
                pageSize: 10,
                totalPages: 1,
                hasNextPage: false,
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
          getSubscriptionRestaurantAvailabilityUseCase: mockAvailabilityUseCase,
          initialState: const SubscriptionPlanState(
            tiers: sampleTiers,
            selectedStartDate: '2026-10-20',
            selectedDurationIndex: null,
          ),
        );

        viewModel.doIntent(
          const BrowseSubscriptionTierRestaurantsEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            tierIndex: 0,
            startDate: '2026-10-20',
          ),
        );

        await pumpEventQueue();

        expect(viewModel.state.browseRestaurants, isEmpty);
        expect(viewModel.state.browseRestaurantsFailure, isNotNull);
        expect(
          viewModel.state.browseRestaurantsFailure!.code,
          SubscriptionErrorCodes.noPreparedRestaurants,
        );
        expect(viewModel.state.browseTotalCount, 0);
      },
    );

    test(
      'changing startDate, duration, or friday while browsing reloads restaurants with updated context',
      () async {
        final requestedContexts = <String>[];

        final mockPageUseCase = _MockPageUseCase((
          page,
          tier,
          durationDays,
          startDate,
          includeFriday,
        ) async {
          requestedContexts.add('$durationDays-$startDate-$includeFriday');
          return const ApiSuccessResult(
            data: PagedEntity(
              items: [
                SubscriptionTierRestaurantBrowseEntity(
                  restaurantId: 'rest-1',
                  nameRaw: 'Rest 1',
                  nameAr: 'مطعم 1',
                  nameEn: 'Rest 1',
                  logoUrl: null,
                  rating: 4.8,
                  mealCount: 10,
                  bundleMealCount: 2,
                  tier: 'standard',
                  tierNameRaw: 'Standard',
                  tierNameAr: 'الأساسي',
                  tierNameEn: 'Standard',
                  tierLogoUrl: null,
                  classifications: [],
                ),
              ],
              pagination: PaginationEntity(
                totalCount: 1,
                page: 1,
                pageSize: 10,
                totalPages: 1,
                hasNextPage: false,
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
          initialState: SubscriptionPlanState(
            tiers: sampleTiers,
            durations: [_createDuration(20), _createDuration(30)],
            selectedDurationIndex: 0,
            selectedStartDate: '2026-10-15',
            includeFriday: false,
          ),
        );

        // 1. Initial browse
        viewModel.doIntent(
          const BrowseSubscriptionTierRestaurantsEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            tierIndex: 0,
          ),
        );
        await pumpEventQueue();

        expect(requestedContexts.last, '20-2026-10-15-false');

        // 2. Change start date
        viewModel.doIntent(
          const SelectSubscriptionPlanStartDateEvent('2026-10-25'),
        );
        await pumpEventQueue();

        expect(requestedContexts.last, '20-2026-10-25-false');

        // 3. Change duration
        viewModel.doIntent(
          const SelectSubscriptionDurationEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            durationIndex: 1,
          ),
        );
        await pumpEventQueue();

        expect(requestedContexts.last, '30-2026-10-25-false');

        // 4. Toggle friday
        viewModel.doIntent(
          const ToggleSubscriptionFridayEvent(
            programId: 'prog-1',
            bundleId: 'bundle-1',
            includeFriday: true,
          ),
        );
        await pumpEventQueue();

        expect(requestedContexts.last, '30-2026-10-25-true');
      },
    );
  });

  group('Task 3: Error Message Presentation Tests', () {
    testWidgets(
      'maps no_prepared_restaurants to localized message distinct from no_restaurants_for_address',
      (tester) async {
        late BuildContext context;
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (ctx) {
                context = ctx;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final enNoPrepared = mapFailureMessage(
          context,
          SubscriptionErrorCodes.noPreparedRestaurants,
        );
        final enNoAddress = mapFailureMessage(
          context,
          SubscriptionErrorCodes.noRestaurantsForAddress,
        );
        final enPricing = mapFailureMessage(
          context,
          SubscriptionErrorCodes.pricingUnavailable,
        );

        expect(enNoPrepared, isNotEmpty);
        expect(enNoPrepared, isNot(equals(enNoAddress)));
        expect(enNoPrepared, isNot(equals(enPricing)));

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (ctx) {
                context = ctx;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final arNoPrepared = mapFailureMessage(
          context,
          SubscriptionErrorCodes.noPreparedRestaurants,
        );
        final arNoAddress = mapFailureMessage(
          context,
          SubscriptionErrorCodes.noRestaurantsForAddress,
        );

        expect(arNoPrepared, isNotEmpty);
        expect(arNoPrepared, isNot(equals(arNoAddress)));
      },
    );
  });
}

class _MockPageUseCase extends Fake
    implements GetSubscriptionTierRestaurantsPageUseCase {
  _MockPageUseCase(this._handler);

  final Future<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>>
  Function(
    int page,
    String tier,
    int? durationDays,
    String? startDate,
    bool? includeFriday,
  )
  _handler;

  @override
  Future<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>> call({
    required String programId,
    required String bundleId,
    required String tier,
    int? durationDays,
    String? startDate,
    bool? includeFriday,
    required int page,
    required int pageSize,
    String? addressId,
  }) {
    return _handler(page, tier, durationDays, startDate, includeFriday);
  }
}

class _MockRestaurantAvailabilityUseCase extends Fake
    implements GetSubscriptionRestaurantAvailabilityUseCase {
  _MockRestaurantAvailabilityUseCase(this._handler);

  final Future<ApiResult<SubscriptionRestaurantAvailabilityEntity>> Function(
    SubscriptionSummaryRequestEntity request,
  )
  _handler;

  @override
  Future<ApiResult<SubscriptionRestaurantAvailabilityEntity>> call(
    SubscriptionSummaryRequestEntity request,
  ) {
    return _handler(request);
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
    String? startDate,
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

SubscriptionDurationEntity _createDuration(int days) {
  return SubscriptionDurationEntity(
    durationDays: days,
    nameAr: '$days يوم',
    nameEn: '$days Days',
    selectionCount: 0,
    isPopular: false,
    isCustom: false,
    minDays: null,
    maxDays: null,
    badge: null,
    supportsFriday: true,
    includeFriday: false,
    fridayDays: 0,
    totalServiceDays: days,
    fridayOption: const SubscriptionFridayOptionEntity(
      code: 'standard',
      nameAr: 'الجمعة',
      nameEn: 'Friday',
      defaultSelected: false,
      isEnabled: true,
    ),
    fridayAvailability: const SubscriptionFridayAvailabilityEntity(
      isAvailable: true,
      restaurantCount: 5,
      code: 'available',
      messageAr: 'متاح',
      messageEn: 'Available',
      displayType: 'banner',
    ),
  );
}
