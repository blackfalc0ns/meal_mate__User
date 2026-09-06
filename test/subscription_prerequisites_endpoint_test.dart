import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/data_source/subscription_tier_remote_data_source_impl.dart';

void main() {
  test(
    'subscription prerequisites request uses the dedicated endpoint',
    () async {
      final adapter = _CapturingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
        ..httpClientAdapter = adapter;
      final dataSource = SubscriptionTierRemoteDataSourceImpl(ApiServices(dio));

      await dataSource.checkPrerequisites();

      expect(
        adapter.requestedUri.path,
        '/api/v1/customer/subscription-flow/prerequisites',
      );
      expect(adapter.requestedMethod, 'GET');
    },
  );
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
    return ResponseBody.fromString('', 200);
  }
}
