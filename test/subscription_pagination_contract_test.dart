import 'dart:convert';
import 'package:meal_meat_user/features/subscription_programs/data/data_source/subscription_programs_remote_data_source_impl.dart';
import 'package:meal_meat_user/features/monthly_plans/data/data_source/subscription_plan_remote_data_source_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/network/mapper/pagination_mapper.dart';
import 'package:meal_meat_user/core/network/models/response/pagination_response_dto.dart';

void main() {
  late _CapturingAdapter adapter;
  late ApiServices apiServices;

  setUp(() {
    adapter = _CapturingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
      ..httpClientAdapter = adapter;
    apiServices = ApiServices(dio);
  });

  test(
    'programs data source parses paged response and preserves server pagination',
    () async {
      adapter.mockResponse = {
        'items': [
          {
            'programId': 'p1',
            'nameAr': 'Program',
            'imageUrl': null,
            'supportedSlots': [],
          },
        ],
        'totalCount': 6,
        'page': 1,
        'pageSize': 20,
        'totalPages': 1,
        'hasNextPage': false,
        'hasPreviousPage': false,
      };
      final source = SubscriptionProgramsRemoteDataSourceImpl(apiServices);
      final response = await source.getSubscriptionProgramsPage(
        page: 1,
        pageSize: 20,
      );
      expect(response.items?.single.programId, 'p1');
      expect(response.totalCount, 6);
      expect(response.totalPages, 1);
      expect(response.hasNextPage, isFalse);
    },
  );

  test(
    'subscription plan data source parses paged tier restaurants response correctly',
    () async {
      adapter.mockResponse = {
        'items': [
          {
            'restaurantId': '7ccfc18b-8f31-43c2-8bbf-ca61ee7c95ec',
            'nameAr': '[تجربة] جرين بول',
            'logoUrl': 'https://ik.imagekit.io/f7h9cj23x/catalog/restaurants/logo-green-bowl.png',
            'rating': null,
            'mealCount': 4,
            'bundleMealCount': 0,
            'tier': 'Basic',
            'tierNameAr': 'أساسي',
            'tierLogoUrl': null,
            'classifications': [{'logoUrl': null, 'tier': 'Basic'}],
            'name': '[تجربة] جرين بول',
            'tierName': 'أساسي',
          },
        ],
        'totalCount': 3,
        'page': 1,
        'pageSize': 10,
        'totalPages': 1,
        'hasNextPage': false,
        'hasPreviousPage': false,
      };

      final dataSource = SubscriptionPlanRemoteDataSourceImpl(apiServices);
      final response = await dataSource.getTierRestaurantsPage(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        tier: 'Platinum',
        page: 1,
        pageSize: 10,
      );

      expect(response.items?.length, 1);
      expect(response.items?.first.restaurantId, '7ccfc18b-8f31-43c2-8bbf-ca61ee7c95ec');
      expect(response.items?.first.nameAr, '[تجربة] جرين بول');
      expect(response.totalCount, 3);
      expect(response.page, 1);
      expect(response.pageSize, 10);
      expect(response.totalPages, 1);
      expect(response.hasNextPage, false);
    },
  );

  group('Pagination Contract & Typed API Tests', () {
    test(
      'getSubscriptionPrograms sends page and pageSize queries when provided and parses paged response',
      () async {
        adapter.mockResponse = {
          'items': [
            {
              'programId': 'p1',
              'nameAr': 'برنامج صحي',
              'nameEn': 'Healthy Program',
            },
          ],
        };

        final response = await apiServices.getSubscriptionPrograms(
          page: 1,
          pageSize: 20,
        );

        expect(
          adapter.requestedUri.path,
          '/api/v1/customer/subscription-flow/programs',
        );
        expect(adapter.requestedUri.queryParameters['page'], '1');
        expect(adapter.requestedUri.queryParameters['pageSize'], '20');
        expect(response.items?.length, 1);
        expect(response.items?.first.programId, 'p1');
      },
    );

    test(
      'legacy getSubscriptionPrograms does not send pagination query',
      () async {
        adapter.mockResponse = {
          'items': [
            {
              'programId': 'p1',
              'nameAr': 'برنامج قديم',
              'nameEn': 'Legacy Program',
            },
          ],
        };

        final response = await apiServices.getSubscriptionPrograms();

        expect(
          adapter.requestedUri.path,
          '/api/v1/customer/subscription-flow/programs',
        );
        expect(
          adapter.requestedUri.queryParameters.containsKey('page'),
          isFalse,
        );
        expect(
          adapter.requestedUri.queryParameters.containsKey('pageSize'),
          isFalse,
        );
        expect(response.items?.length, 1);
        expect(response.items?.first.programId, 'p1');
      },
    );

    test('getSubscriptionProgramBundles with pagination sends page & pageSize and parses wrapper', () async {
      adapter.mockResponse = {
        'hasDeliveryAddress': true,
        'hasAllergies': false,
        'hasDietaryPreferences': true,
        'isProfileComplete': true,
        'bundles': [
          {'bundleId': 'b1', 'programId': 'p1', 'code': 'B1'}
        ],
        'pagination': {
          'totalCount': 6,
          'page': 1,
          'pageSize': 2,
          'totalPages': 3,
          'hasNextPage': true,
          'hasPreviousPage': false,
        }
      };

      final response = await apiServices.getSubscriptionProgramBundles('p1', page: 1, pageSize: 2);

      expect(adapter.requestedUri.path, '/api/v1/customer/subscription-flow/programs/p1/bundles');
      expect(adapter.requestedUri.queryParameters['page'], '1');
      expect(adapter.requestedUri.queryParameters['pageSize'], '2');
      expect(response.hasDeliveryAddress, isTrue);
      expect(response.bundles?.length, 1);
      expect(response.pagination?.totalCount, 6);
      expect(response.pagination?.hasNextPage, isTrue);

      final paginationEntity = response.pagination.toEntityOrNull();
      expect(paginationEntity?.totalPages, 3);
      expect(paginationEntity?.hasNextPage, isTrue);
    });

    test('legacy getSubscriptionProgramBundles without pagination omits query and handles null pagination', () async {
      adapter.mockResponse = {
        'hasDeliveryAddress': true,
        'hasAllergies': true,
        'hasDietaryPreferences': true,
        'isProfileComplete': true,
        'bundles': [
          {'bundleId': 'b1', 'programId': 'p1', 'code': 'B1'}
        ],
      };

      final response = await apiServices.getSubscriptionProgramBundles('p1');

      expect(adapter.requestedUri.queryParameters.containsKey('page'), isFalse);
      expect(adapter.requestedUri.queryParameters.containsKey('pageSize'), isFalse);
      expect(response.pagination, isNull);
      expect(response.pagination.toEntityOrNull(), isNull);
    });

    test('getSubscriptionTierRestaurantsPage sends required page and pageSize', () async {
      adapter.mockResponse = [
        {'restaurantId': 'r1', 'nameAr': 'مطعم أ'}
      ];

      final response = await apiServices.getSubscriptionTierRestaurants(
        'p1',
        'b1',
        'Platinum',
        null,
        page: 2,
        pageSize: 5,
      );

      expect(adapter.requestedUri.path, '/api/v1/customer/subscription-flow/programs/p1/bundles/b1/tiers/Platinum/restaurants');
      expect(adapter.requestedUri.queryParameters['page'], '2');
      expect(adapter.requestedUri.queryParameters['pageSize'], '5');
      expect(response.first.restaurantId, 'r1');
      expect(response.length, 1);
    });

    test('legacy getSubscriptionTierRestaurants can be called without page/pageSize', () async {
      adapter.mockResponse = [
        {'restaurantId': 'r1', 'nameAr': 'مطعم أ'}
      ];

      final response = await apiServices.getSubscriptionTierRestaurants('p1', 'b1', 'Platinum', null);

      expect(adapter.requestedUri.queryParameters.containsKey('page'), isFalse);
      expect(adapter.requestedUri.queryParameters.containsKey('pageSize'), isFalse);
      expect(response.length, 1);
    });

    test('getSubscriptionSummary sends restaurantsPage, restaurantsPageSize, and promoCode when provided', () async {
      adapter.mockResponse = {
        'programId': 'p1',
        'bundleId': 'b1',
        'tier': 'Basic',
        'durationDays': 26,
        'startDate': '2026-10-01',
        'finalPrice': 90.0,
      };

      await apiServices.getSubscriptionSummary(
        true,
        26,
        'Basic',
        'b1',
        'p1',
        '2026-10-01',
        restaurantsPage: 2,
        restaurantsPageSize: 10,
        promoCode: 'SAVE20',
      );

      expect(adapter.requestedUri.queryParameters['restaurantsPage'], '2');
      expect(adapter.requestedUri.queryParameters['restaurantsPageSize'], '10');
      expect(adapter.requestedUri.queryParameters['promoCode'], 'SAVE20');
    });

    test('PaginationResponseDtoMapper handles nulls and defaults safely', () {
      const dto = PaginationResponseDto();
      final entity = dto.toEntity();

      expect(entity.totalCount, 0);
      expect(entity.page, 1);
      expect(entity.pageSize, 20);
      expect(entity.totalPages, 0);
      expect(entity.hasNextPage, false);
      expect(entity.hasPreviousPage, false);
    });
  });
}

class _CapturingAdapter implements HttpClientAdapter {
  late Uri requestedUri;
  dynamic mockResponse = <String, dynamic>{};

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedUri = options.uri;
    return ResponseBody.fromString(
      jsonEncode(mockResponse),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
