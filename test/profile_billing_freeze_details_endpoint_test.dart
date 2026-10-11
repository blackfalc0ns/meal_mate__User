import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/subscription_settings/data/data_source/subscription_billing_remote_data_source_impl.dart';

void main() {
  test(
    'current freeze details request uses current subscription endpoint',
    () async {
      final adapter = _CapturingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
        ..httpClientAdapter = adapter;
      final dataSource = SubscriptionBillingRemoteDataSourceImpl(
        ApiServices(dio),
      );

      await dataSource.getCurrentCustomerSubscriptionFreezeDetails();

      expect(
        adapter.requestedUri.path,
        '/api/v1/customer/subscriptions/current/freeze-details',
      );
      expect(adapter.requestedUri.queryParametersAll, isEmpty);
    },
  );

  test(
    'subscription freeze details request replaces subscription id path',
    () async {
      final adapter = _CapturingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'http://maelmate.runasp.net'))
        ..httpClientAdapter = adapter;
      final dataSource = SubscriptionBillingRemoteDataSourceImpl(
        ApiServices(dio),
      );

      await dataSource.getCustomerSubscriptionFreezeDetails('sub-1');

      expect(
        adapter.requestedUri.path,
        '/api/v1/customer/subscriptions/sub-1/freeze-details',
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
      jsonEncode(<String, Object?>{}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
