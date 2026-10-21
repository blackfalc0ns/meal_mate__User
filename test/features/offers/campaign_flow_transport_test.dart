import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/offers/data/data_source/offers_remote_data_source_impl.dart';
import 'package:meal_meat_user/features/offers/data/repo/offers_repository_impl.dart';
import 'package:meal_meat_user/features/offers/data/services/campaign_checkout_attempt_store.dart';
import 'package:meal_meat_user/features/offers/data/services/campaign_payment_attempt_store.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_quote_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';

class _Token extends Fake implements TokenService {
  @override
  Future<String?> getCurrentUserId() async => 'authenticated-owner';
}

class _Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  bool timeout = false;
  Object response = <String, dynamic>{};
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (timeout) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.receiveTimeout,
      );
    }
    return ResponseBody.fromString(
      jsonEncode(response),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'campaign transport preserves cursor, uses token owner and buys campaignBundleId with durable quote key',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = SharedPrefHelper(await SharedPreferences.getInstance());
      final adapter = _Adapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      OffersRepositoryImpl repository() => OffersRepositoryImpl(
        OffersRemoteDataSourceImpl(ApiServices(dio)),
        _Token(),
        campaignCheckoutAttemptStore: CampaignCheckoutAttemptStore(prefs),
        campaignPaymentAttemptStore: CampaignPaymentAttemptStore(
          prefs,
          _Token(),
        ),
      );
      adapter.response = {'items': [], 'nextCursor': null};
      await repository().getCampaigns(cursor: 'opaque+/==');
      expect(adapter.requests.last.uri.queryParameters['cursor'], 'opaque+/==');
      expect(adapter.requests.last.path, '/api/v1/customer/campaigns');
      adapter.response = {'quoteId': 'quote-1', 'canCheckout': true};
      await repository().getCampaignQuote(
        const CampaignQuoteRequestEntity(
          campaignId: 'campaign',
          programId: 'program',
          campaignBundleId: 'campaign-bundle',
          durationDays: 6,
          startDate: '2026-11-01',
          addressId: 'address',
        ),
      );
      final quoteBody = adapter.requests.last.data as Map;
      expect(quoteBody['customerId'], 'authenticated-owner');
      expect(quoteBody['campaignBundleId'], 'campaign-bundle');
      expect(quoteBody.containsKey('bundleId'), false);
      adapter.response = {'sessionId': 'session', 'finalCustomerPrice': 48.125};
      await repository().createCampaignCheckoutSession(
        campaignId: 'campaign',
        bundleId: 'campaign-bundle',
        durationDays: 6,
        quoteId: 'quote-1',
        expectedFinalPrice: 48.125,
      );
      final first = Map<String, dynamic>.from(
        adapter.requests.last.data as Map,
      );
      expect(first['quoteId'], 'quote-1');
      expect(first['bundleId'], 'campaign-bundle');
      expect((first['idempotencyKey'] as String).isNotEmpty, true);
      expect(first.containsKey('requestedServiceDates'), false);
      await repository().createCampaignCheckoutSession(
        campaignId: 'campaign',
        bundleId: 'campaign-bundle',
        durationDays: 6,
        quoteId: 'quote-1',
        expectedFinalPrice: 48.125,
      );
      expect(adapter.requests.last.data, first);
      final restored = await repository().restoreCampaignCheckoutSession();
      expect((restored as ApiSuccessResult).data.sessionId, 'session');
      expect((restored as ApiSuccessResult).data.finalCustomerPrice, 48.125);
      adapter.response = {'status': 'Pending'};
      await repository().startCampaignPayment(
        const StartCampaignPaymentRequestEntity(
          sessionId: 'session',
          idempotencyKey: 'original',
          paymentMethodId: 7,
        ),
      );
      final payment = Map<String, dynamic>.from(
        adapter.requests.last.data as Map,
      );
      await repository().startCampaignPayment(
        const StartCampaignPaymentRequestEntity(
          sessionId: 'session',
          idempotencyKey: 'new',
          paymentMethodId: 3,
        ),
      );
      expect(adapter.requests.last.data, payment);
      dio.close();
    },
  );

  test(
    'ambiguous checkout replays persisted request and mismatched price never restores as payable',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = SharedPrefHelper(await SharedPreferences.getInstance());
      final adapter = _Adapter()..timeout = true;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      OffersRepositoryImpl repository() => OffersRepositoryImpl(
        OffersRemoteDataSourceImpl(ApiServices(dio)),
        _Token(),
        campaignCheckoutAttemptStore: CampaignCheckoutAttemptStore(prefs),
      );
      final result = await repository().createCampaignCheckoutSession(
        campaignId: 'c',
        bundleId: 'cb',
        durationDays: 6,
        quoteId: 'q',
        expectedFinalPrice: 48.125,
      );
      expect(result, isA<ApiErrorResult>());
      final original = adapter.requests.last.data;
      adapter.timeout = false;
      adapter.response = {'sessionId': 's', 'finalCustomerPrice': 49.125};
      final mismatch = await repository().restoreCampaignCheckoutSession();
      expect(mismatch, isA<ApiErrorResult>());
      expect(
        (mismatch as ApiErrorResult).failure.code,
        'Campaign.SelectionMismatch',
      );
      expect(adapter.requests.last.data, original);
      final stillBlocked = await repository().restoreCampaignCheckoutSession();
      expect(stillBlocked, isA<ApiErrorResult>());
      adapter.response = {'sessionId': 's', 'finalCustomerPrice': 48.125};
      final restored = await repository().restoreCampaignCheckoutSession();
      expect((restored as ApiSuccessResult).data.sessionId, 's');
      expect(adapter.requests.last.data, original);
      dio.close();
    },
  );
}
