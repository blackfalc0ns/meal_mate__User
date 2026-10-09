import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/data_source/subscription_summary_remote_data_source_impl.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

void main() {
  test('restaurant availability endpoint performs GET with all 8 query params and startDate=anchor', () async {
    final adapter = _CapturingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
      ..httpClientAdapter = adapter;
    final dataSource = SubscriptionSummaryRemoteDataSourceImpl(ApiServices(dio));

    const request = SubscriptionSummaryRequestEntity(
      programId: 'prog-123',
      bundleId: 'bundle-456',
      tier: 'Basic',
      durationDays: 26,
      startDate: '2026-10-08',
      includeFriday: true,
      restaurantsPage: 2,
      restaurantsPageSize: 15,
    );

    await dataSource.getRestaurantAvailability(request);

    expect(
      adapter.requestedUri.path,
      '/api/v1/customer/subscription-flow/restaurant-availability',
    );
    expect(adapter.requestedMethod, 'GET');

    final query = adapter.requestedUri.queryParameters;
    expect(query['programId'], 'prog-123');
    expect(query['bundleId'], 'bundle-456');
    expect(query['tier'], 'Basic');
    expect(query['durationDays'], '26');
    expect(query['startDate'], '2026-10-08', reason: 'startDate must be anchor date');
    expect(query['includeFriday'], 'true');
    expect(query['restaurantsPage'], '2');
    expect(query['restaurantsPageSize'], '15');
  });
}

class _CapturingAdapter implements HttpClientAdapter {
  late Uri requestedUri;
  late String requestedMethod;

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
    final responseMap = {
      'availability': {
        'status': 'available',
        'coveredRestaurantCount': 5,
        'eligibleRestaurantCount': 5,
        'checkedAtUtc': '2026-10-08T10:00:00Z',
        'effectiveStartDate': '2026-10-11',
        'messageCode': 'subscription_flow.available',
      },
      'totalCount': 5,
      'pagination': null,
      'restaurants': <Map<String, dynamic>>[],
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
