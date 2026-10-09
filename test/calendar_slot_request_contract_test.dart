import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/calendar/data/data_source/calendar_remote_data_source_impl.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_save_meals_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_set_restaurant_request_dto.dart';

void main() {
  group(
    'Calendar Slot, Restaurant & Complete Request Contract Tests (Task 8)',
    () {
      late _CapturingAdapter adapter;
      late Dio dio;
      late CalendarRemoteDataSourceImpl dataSource;

      setUp(() {
        adapter = _CapturingAdapter();
        dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
          ..httpClientAdapter = adapter;
        dataSource = CalendarRemoteDataSourceImpl(ApiServices(dio));
      });

      test(
        'setDayRestaurant sends POST to /restaurant with restaurantId body',
        () async {
          await dataSource.setDayRestaurant(
            subscriptionId: 'sub-101',
            date: '2026-10-15',
            request: const CalendarSetRestaurantRequestDto(
              restaurantId: 'rest-42',
            ),
          );

          expect(adapter.requestedMethod, 'POST');
          expect(
            adapter.requestedUri.path,
            '/api/v1/customer/subscriptions/sub-101/days/2026-10-15/restaurant',
          );
          expect(adapter.capturedRequestBody, {'restaurantId': 'rest-42'});
        },
      );

      test(
        'saveDayMeals sends POST to /meals/slot with mealId and slot body',
        () async {
          await dataSource.saveDayMeals(
            subscriptionId: 'sub-101',
            date: '2026-10-15',
            request: const CalendarSaveMealsRequestDto(
              mealId: 'meal-99',
              slot: 'Lunch',
            ),
          );

          expect(adapter.requestedMethod, 'POST');
          expect(
            adapter.requestedUri.path,
            '/api/v1/customer/subscriptions/sub-101/days/2026-10-15/meals/slot',
          );
          expect(adapter.capturedRequestBody, {
            'mealId': 'meal-99',
            'slot': 'Lunch',
          });
        },
      );

      test('autoSelect (complete) sends POST to /complete', () async {
        await dataSource.autoSelect(
          subscriptionId: 'sub-101',
          date: '2026-10-15',
        );

        expect(adapter.requestedMethod, 'POST');
        expect(
          adapter.requestedUri.path,
          '/api/v1/customer/subscriptions/sub-101/days/2026-10-15/complete',
        );
      });
    },
  );
}

class _CapturingAdapter implements HttpClientAdapter {
  late Uri requestedUri;
  late String requestedMethod;
  dynamic capturedRequestBody;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedUri = options.uri;
    requestedMethod = options.method;
    capturedRequestBody = options.data;

    final responseMap = {
      'id': 'day-1',
      'date': '2026-10-15',
      'status': 'Scheduled',
      'canEdit': true,
    };

    return ResponseBody.fromString(
      jsonEncode(responseMap),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
