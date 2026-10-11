import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/calendar/data/data_source/calendar_remote_data_source_impl.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_restaurants_page_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/repo/calendar_repository_impl.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurants_page_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';

void main() {
  group('Calendar Restaurants Pagination Contract', () {
    test(
      'RemoteDataSource passes page, pageSize and query correctly',
      () async {
        RequestOptions? recordedOptions;
        final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
          ..httpClientAdapter = _MockAdapter((options) {
            recordedOptions = options;
            return ResponseBody.fromString(
              jsonEncode({
                'serviceDate': '2026-10-15',
                'limit': 8,
                'adminCeiling': 8,
                'restaurants': [
                  {
                    'restaurantId': 'r1',
                    'nameEn': 'Kitchen',
                    'rating': null,
                    'ratingCount': 0,
                    'isEnabled': false,
                    'disabledReason': 'calendar.quota_exhausted',
                  },
                ],
                'page': 1,
                'pageSize': 20,
                'totalCount': 21,
                'totalPages': 2,
                'hasNextPage': true,
                'hasPreviousPage': false,
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          });

        final dataSource = CalendarRemoteDataSourceImpl(ApiServices(dio));
        final responseDto = await dataSource.getRestaurants(
          subscriptionId: 'sub-1',
          date: '2026-10-15',
          query: 'Kitchen',
          page: 1,
          pageSize: 20,
        );

        expect(recordedOptions?.method, 'GET');
        expect(
          recordedOptions?.uri.path,
          '/api/v1/customer/subscriptions/sub-1/days/2026-10-15/restaurants',
        );
        expect(recordedOptions?.uri.queryParameters['query'], 'Kitchen');
        expect(recordedOptions?.uri.queryParameters['page'], '1');
        expect(recordedOptions?.uri.queryParameters['pageSize'], '20');

        expect(responseDto.page, 1);
        expect(responseDto.pageSize, 20);
        expect(responseDto.totalCount, 21);
        expect(responseDto.totalPages, 2);
        expect(responseDto.hasNextPage, isTrue);
        expect(responseDto.hasPreviousPage, isFalse);
        expect(responseDto.restaurants?.length, 1);
        expect(responseDto.restaurants?.first.restaurantId, 'r1');
      },
    );

    test('Legacy call does not send page/pageSize query params', () async {
      RequestOptions? recordedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
        ..httpClientAdapter = _MockAdapter((options) {
          recordedOptions = options;
          return ResponseBody.fromString(
            jsonEncode({
              'restaurants': [
                {'restaurantId': 'r1', 'name': 'Kitchen'},
              ],
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

      final dataSource = CalendarRemoteDataSourceImpl(ApiServices(dio));
      await dataSource.getRestaurants(
        subscriptionId: 'sub-legacy',
        date: '2026-10-15',
      );

      expect(recordedOptions?.uri.queryParameters.containsKey('page'), isFalse);
      expect(
        recordedOptions?.uri.queryParameters.containsKey('pageSize'),
        isFalse,
      );
      expect(
        recordedOptions?.uri.queryParameters.containsKey('query'),
        isFalse,
      );
    });

    test(
      'Mapper preserves metadata when present and filters empty restaurantId without mutating totalCount',
      () {
        final dto = CalendarRestaurantsResponseDto(
          serviceDate: '2026-10-15',
          limit: 8,
          adminCeiling: 8,
          page: 1,
          pageSize: 20,
          totalCount: 21,
          totalPages: 2,
          hasNextPage: true,
          hasPreviousPage: false,
          restaurants: [
            CalendarRestaurantResponseDto(
              restaurantId: 'r1',
              nameEn: 'Kitchen',
              rating: null,
              ratingCount: 0,
              isEnabled: false,
            ),
            CalendarRestaurantResponseDto(
              restaurantId: '', // Should be filtered out
              nameEn: 'Invalid',
            ),
          ],
        );

        final entity = dto.toEntity(localeName: 'en');
        expect(entity.page, 1);
        expect(entity.pageSize, 20);
        expect(entity.totalCount, 21); // Remains 21 from response
        expect(entity.totalPages, 2);
        expect(entity.hasNextPage, isTrue);
        expect(entity.hasPreviousPage, isFalse);
        expect(entity.restaurants.length, 1);
        expect(entity.restaurants.first.id, 'r1');
        expect(entity.restaurants.first.isEnabled, isFalse);
      },
    );

    test(
      'Mapper falls back safely for legacy response missing pagination fields',
      () {
        final dto = CalendarRestaurantsResponseDto(
          restaurants: [
            CalendarRestaurantResponseDto(
              restaurantId: 'r1',
              name: 'Restaurant 1',
            ),
            CalendarRestaurantResponseDto(
              restaurantId: 'r2',
              name: 'Restaurant 2',
            ),
          ],
        );

        final entity = dto.toEntity(localeName: 'en');
        expect(entity.page, 1);
        expect(entity.pageSize, 2);
        expect(entity.totalCount, 2);
        expect(entity.totalPages, 1);
        expect(entity.hasNextPage, isFalse);
        expect(entity.hasPreviousPage, isFalse);
        expect(entity.restaurants.length, 2);
      },
    );

    test(
      'Mapper falls back safely when restaurants list is empty and pagination metadata is null',
      () {
        final dto = CalendarRestaurantsResponseDto(restaurants: []);

        final entity = dto.toEntity(localeName: 'en');
        expect(entity.page, 1);
        expect(entity.pageSize, 1);
        expect(entity.totalCount, 0);
        expect(entity.totalPages, 0);
        expect(entity.hasNextPage, isFalse);
        expect(entity.hasPreviousPage, isFalse);
        expect(entity.restaurants, isEmpty);
      },
    );

    test(
      'Repository and UseCase return ApiResult<CalendarRestaurantsPageEntity>',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
          ..httpClientAdapter = _MockAdapter((options) {
            return ResponseBody.fromString(
              jsonEncode({
                'page': 2,
                'pageSize': 20,
                'totalCount': 22,
                'totalPages': 2,
                'hasNextPage': false,
                'hasPreviousPage': true,
                'restaurants': [
                  {'restaurantId': 'r2', 'name': 'Kitchen 2'},
                ],
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          });

        final dataSource = CalendarRemoteDataSourceImpl(ApiServices(dio));
        final repo = CalendarRepositoryImpl(dataSource);
        final useCase = GetCalendarRestaurantsUseCase(repo);

        final result = await useCase(
          subscriptionId: 'sub-1',
          date: '2026-10-15',
          localeName: 'en',
          page: 2,
          pageSize: 20,
        );

        expect(result, isA<ApiSuccessResult<CalendarRestaurantsPageEntity>>());
        final pageEntity =
            (result as ApiSuccessResult<CalendarRestaurantsPageEntity>).data;
        expect(pageEntity.page, 2);
        expect(pageEntity.hasNextPage, isFalse);
        expect(pageEntity.restaurants.length, 1);
        expect(pageEntity.restaurants.first.id, 'r2');
      },
    );
  });
}

class _MockAdapter implements HttpClientAdapter {
  final FutureOr<ResponseBody> Function(RequestOptions options) handler;
  _MockAdapter(this.handler);

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }
}
