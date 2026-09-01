import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/data_source/subscription_tier_remote_data_source_impl.dart';

void main() {
  test(
    'tier restaurants request uses path params without restaurantIds query',
    () async {
      final adapter = _CapturingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
        ..httpClientAdapter = adapter;
      final dataSource = SubscriptionTierRemoteDataSourceImpl(ApiServices(dio));

      await dataSource.getTierRestaurants(
        programId: 'program-1',
        bundleId: 'bundle-1',
        tier: 'Elite',
      );

      expect(
        adapter.requestedUri.path,
        '/api/v1/customer/subscription-flow/programs/program-1/bundles/bundle-1/tiers/Elite/restaurants',
      );
      expect(adapter.requestedUri.queryParametersAll, isEmpty);
    },
  );
}

class _CapturingAdapter implements HttpClientAdapter {
  late Uri requestedUri;

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
      jsonEncode(<Object>[]),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
