import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/calendar/data/data_source/calendar_remote_data_source_impl.dart';

void main() {
  test('calendar restaurants loads only the date-scoped endpoint', () async {
    final adapter = _RecordingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
      ..httpClientAdapter = adapter;
    final dataSource = CalendarRemoteDataSourceImpl(ApiServices(dio));

    final response = await dataSource.getRestaurants(
      subscriptionId: 'subscription-1',
      date: '2026-09-15',
    );

    expect(response.restaurants?.single.restaurantId, 'restaurant-1');
    expect(adapter.requestedUris, hasLength(1));
    expect(
      adapter.requestedUris.single.path,
      '/api/v1/customer/subscriptions/subscription-1/days/2026-09-15/restaurants',
    );
  });
}

class _RecordingAdapter implements HttpClientAdapter {
  final List<Uri> requestedUris = [];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedUris.add(options.uri);
    return ResponseBody.fromString(
      jsonEncode({
        'restaurantCount': 1,
        'restaurants': [
          {
            'restaurantId': 'restaurant-1',
            'name': 'Test Restaurant',
            'isEnabled': true,
          },
        ],
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
