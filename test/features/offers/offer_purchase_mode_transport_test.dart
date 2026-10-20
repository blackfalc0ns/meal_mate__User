import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/offers/data/data_source/offers_remote_data_source_impl.dart';
import 'package:meal_meat_user/features/offers/data/repo/offers_repository_impl.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_available_offers_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_state.dart';

class _CapturingAdapter implements HttpClientAdapter {
  late RequestOptions lastOptions;
  List<Map<String, dynamic>> responseBody = [];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    return ResponseBody.fromString(
      jsonEncode(responseBody),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class _FakeTokenService implements TokenService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Offer purchaseMode transport and includeCampaigns tests', () {
    late _CapturingAdapter adapter;
    late Dio dio;
    late ApiServices apiServices;
    late OffersRemoteDataSourceImpl remoteDataSource;
    late OffersRepositoryImpl repository;
    late GetAvailableOffersUseCase useCase;

    setUp(() {
      adapter = _CapturingAdapter();
      dio = Dio(BaseOptions(baseUrl: 'https://api.trymealmate.com'))..httpClientAdapter = adapter;
      apiServices = ApiServices(dio);
      remoteDataSource = OffersRemoteDataSourceImpl(apiServices);
      repository = OffersRepositoryImpl(remoteDataSource, _FakeTokenService());
      useCase = GetAvailableOffersUseCase(repository);
    });

    test('ApiServices sends includeCampaigns=false when includeCampaigns is false', () async {
      adapter.responseBody = [];
      await apiServices.getCustomerAvailableOffers(includeCampaigns: false);

      expect(adapter.lastOptions.uri.path, '/api/v1/customer/offers/available');
      expect(adapter.lastOptions.uri.queryParameters['includeCampaigns'], 'false');
    });

    test('ApiServices omits includeCampaigns when includeCampaigns is null', () async {
      adapter.responseBody = [];
      await apiServices.getCustomerAvailableOffers();

      expect(adapter.lastOptions.uri.path, '/api/v1/customer/offers/available');
      expect(adapter.lastOptions.uri.queryParameters.containsKey('includeCampaigns'), isFalse);
    });

    test('GetAvailableOffersUseCase threads includeCampaigns=false through data source to Retrofit', () async {
      adapter.responseBody = [
        {
          'id': 'direct-offer-qa',
          'title': 'Direct Test Offer',
          'description': 'QA direct offer',
          'purchaseMode': 'DirectPurchase',
          'price': 15.0,
        },
        {
          'id': 'coupon-offer-qa',
          'title': 'Coupon Test Offer',
          'description': 'QA coupon offer',
          'purchaseMode': 'CouponOnly',
          'promoCode': 'TEST50',
        },
      ];

      final result = await useCase(includeCampaigns: false);

      // Verify the generated Retrofit query sends includeCampaigns=false
      expect(adapter.lastOptions.uri.queryParameters['includeCampaigns'], 'false');

      // Verify the response entity mapping and purchaseMode partition
      expect(result, isA<ApiSuccessResult<List<OfferEntity>>>());
      final offers = (result as ApiSuccessResult<List<OfferEntity>>).data;
      expect(offers, hasLength(2));

      // Acceptance assertions from plan
      final rawResponse = adapter.responseBody;
      expect(rawResponse.any((item) => item['purchaseMode'] == 'DirectPurchase'), isTrue);

      final state = OffersState(filteredOffers: offers);
      expect(state.readyOffers.every((offer) => offer.isDirectPurchase), isTrue);
      expect(state.couponOffers.every((offer) => offer.isCouponOnly), isTrue);
      expect(state.readyOffers.map((o) => o.id), ['direct-offer-qa']);
      expect(state.couponOffers.map((o) => o.id), ['coupon-offer-qa']);
    });

    test('purchaseOptions is never called for coupon-only offers', () async {
      int purchaseOptionsCalls = 0;
      final countingAdapter = _CapturingAdapter();
      final countingDio = Dio(BaseOptions(baseUrl: 'https://api.trymealmate.com'))..httpClientAdapter = countingAdapter;

      // Intercept purchase options calls
      countingDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.uri.path.contains('/purchase-options')) {
              purchaseOptionsCalls++;
            }
            handler.next(options);
          },
        ),
      );

      final offers = [
        const OfferEntity(
          id: 'coupon-1',
          nameAr: 'كوبون',
          nameEn: 'Coupon',
          descriptionAr: 'وصف',
          descriptionEn: 'Desc',
          promoCode: 'SAVE20',
          purchaseMode: OfferPurchaseMode.couponOnly,
        ),
      ];

      final state = OffersState(filteredOffers: offers);

      // Inspecting coupon offers should never trigger purchaseOptions request
      expect(state.couponOffers, hasLength(1));
      expect(state.readyOffers, isEmpty);
      expect(purchaseOptionsCalls, 0);
    });
  });
}
