import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/addresses/data/data_source/addresses_remote_data_source.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/address_coverage_preview_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/address_coverage_pagination_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/repo/addresses_repository_impl.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/family_addresses/data/data_source/family_addresses_remote_data_source.dart';
import 'package:meal_meat_user/features/family_addresses/data/repo/family_addresses_repository_impl.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';

void main() {
  group('Address Coverage Pagination Transport Tests', () {
    late Dio dio;
    late List<RequestOptions> captured;
    late ApiServices api;

    setUp(() {
      captured = <RequestOptions>[];
      dio = Dio(BaseOptions(baseUrl: 'https://coverage.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured.add(options);
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'canSetAsDefault': true,
                  'isCurrentSubscriptionRestaurantCovered': true,
                  'servingRestaurants': <Object?>[],
                  'pagination': {
                    'totalCount': 42,
                    'page': 2,
                    'pageSize': 20,
                    'totalPages': 3,
                    'hasNextPage': true,
                    'hasPreviousPage': true,
                  },
                },
              ),
            );
          },
        ),
      );
      api = ApiServices(dio);
    });

    test(
      'customer existing address preview GET sends page and pageSize in query string',
      () async {
        final res = await api.previewExistingAddressCoverage(
          'addr-1',
          page: 2,
          pageSize: 20,
        );
        expect(res.pagination?.totalCount, 42);
        expect(captured.single.method, 'GET');
        expect(
          captured.single.path,
          '/api/v1/customers/me/addresses/addr-1/preview-coverage',
        );
        expect(captured.single.queryParameters['page'], 2);
        expect(captured.single.queryParameters['pageSize'], 20);
      },
    );

    test(
      'customer existing address preview GET omits null pagination query parameters',
      () async {
        await api.previewExistingAddressCoverage('addr-1');
        expect(captured.single.method, 'GET');
        expect(captured.single.queryParameters.containsKey('page'), isFalse);
        expect(
          captured.single.queryParameters.containsKey('pageSize'),
          isFalse,
        );
      },
    );

    test(
      'customer existing address preview GET supports partial opt-in (page only)',
      () async {
        await api.previewExistingAddressCoverage('addr-1', page: 3);
        expect(captured.single.method, 'GET');
        expect(captured.single.queryParameters['page'], 3);
        expect(
          captured.single.queryParameters.containsKey('pageSize'),
          isFalse,
        );
      },
    );

    test(
      'customer new address preview POST sends page and pageSize in body',
      () async {
        await api.previewNewAddressCoverage(
          const AddressCoveragePreviewRequestDto(
            regionId: 'reg-1',
            page: 2,
            pageSize: 20,
          ),
        );
        expect(captured.single.method, 'POST');
        expect(
          captured.single.path,
          '/api/v1/customers/me/addresses/preview-coverage',
        );
        expect(captured.single.queryParameters.containsKey('page'), isFalse);
        final body = captured.single.data as Map<String, dynamic>;
        expect(body['page'], 2);
        expect(body['pageSize'], 20);
      },
    );

    test(
      'family member existing address preview GET sends page and pageSize in query string',
      () async {
        await api.previewExistingFamilyMemberAddress(
          'mem-1',
          'addr-2',
          page: 3,
          pageSize: 15,
        );
        expect(captured.single.method, 'GET');
        expect(
          captured.single.path,
          '/api/v1/customer/family-subscription-flow/members/mem-1/addresses/addr-2/preview-coverage',
        );
        expect(captured.single.queryParameters['page'], 3);
        expect(captured.single.queryParameters['pageSize'], 15);
      },
    );

    test(
      'family member new address preview POST sends page and pageSize in body',
      () async {
        await api.previewFamilyMemberAddress(
          'mem-1',
          const AddressCoveragePreviewRequestDto(
            regionId: 'reg-1',
            page: 1,
            pageSize: 20,
          ),
        );
        expect(captured.single.method, 'POST');
        expect(
          captured.single.path,
          '/api/v1/customer/family-subscription-flow/members/mem-1/addresses/preview-coverage',
        );
        final body = captured.single.data as Map<String, dynamic>;
        expect(body['page'], 1);
        expect(body['pageSize'], 20);
      },
    );

    test(
      'customer repository forwards pagination parameters and handles success & failure',
      () async {
        final fakeDataSource = _FakeAddressesRemoteDataSource();
        final repo = AddressesRepositoryImpl(fakeDataSource);

        const request = CustomerAddressRequestEntity(
          label: 'Home',
          addressLine: 'Block 1',
          latitude: 29.3,
          longitude: 48.0,
          isDefault: true,
          notifyOnDelivery: false,
        );

        final postResult = await repo.previewNewAddressCoverage(
          request,
          page: 2,
          pageSize: 20,
        );
        expect(postResult, isA<ApiSuccessResult>());
        expect(fakeDataSource.lastPostRequest?.page, 2);
        expect(fakeDataSource.lastPostRequest?.pageSize, 20);

        final getResult = await repo.previewExistingAddressCoverage(
          'addr-99',
          page: 4,
          pageSize: 10,
        );
        expect(getResult, isA<ApiSuccessResult>());
        expect(fakeDataSource.lastGetAddressId, 'addr-99');
        expect(fakeDataSource.lastGetPage, 4);
        expect(fakeDataSource.lastGetPageSize, 10);

        fakeDataSource.shouldThrow = true;
        final errorResult = await repo.previewExistingAddressCoverage(
          'addr-99',
          page: 4,
          pageSize: 10,
        );
        expect(errorResult, isA<ApiErrorResult>());
      },
    );

    test(
      'family repository forwards pagination parameters and handles success & failure',
      () async {
        final fakeDataSource = _FakeFamilyAddressesRemoteDataSource();
        final repo = FamilyAddressesRepositoryImpl(
          fakeDataSource,
          FamilyFlowSnapshotStore(),
        );

        const request = CustomerAddressRequestEntity(
          label: 'Home',
          addressLine: 'Block 1',
          latitude: 29.3,
          longitude: 48.0,
          isDefault: true,
          notifyOnDelivery: false,
        );

        final postResult = await repo.previewAddress(
          'mem-1',
          request,
          page: 1,
          pageSize: 20,
        );
        expect(postResult, isA<ApiSuccessResult>());
        expect(fakeDataSource.lastPostMemberId, 'mem-1');
        expect(fakeDataSource.lastPostRequest?.page, 1);
        expect(fakeDataSource.lastPostRequest?.pageSize, 20);

        final getResult = await repo.previewExistingAddress(
          'mem-1',
          'addr-2',
          page: 2,
          pageSize: 20,
        );
        expect(getResult, isA<ApiSuccessResult>());
        expect(fakeDataSource.lastGetMemberId, 'mem-1');
        expect(fakeDataSource.lastGetAddressId, 'addr-2');
        expect(fakeDataSource.lastGetPage, 2);
        expect(fakeDataSource.lastGetPageSize, 20);

        fakeDataSource.shouldThrow = true;
        final errorResult = await repo.previewExistingAddress(
          'mem-1',
          'addr-2',
          page: 2,
          pageSize: 20,
        );
        expect(errorResult, isA<ApiErrorResult>());
      },
    );
  });
}

class _FakeAddressesRemoteDataSource implements AddressesRemoteDataSource {
  AddressCoveragePreviewRequestDto? lastPostRequest;
  String? lastGetAddressId;
  int? lastGetPage;
  int? lastGetPageSize;
  bool shouldThrow = false;

  @override
  Future<AddressCoveragePreviewResponseDto> previewNewAddressCoverage(
    AddressCoveragePreviewRequestDto request,
  ) async {
    if (shouldThrow) {
      throw DioException(requestOptions: RequestOptions(path: '/preview'));
    }
    lastPostRequest = request;
    return const AddressCoveragePreviewResponseDto(
      pagination: AddressCoveragePaginationResponseDto(page: 2, totalCount: 10),
    );
  }

  @override
  Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(
    String addressId, {
    int? page,
    int? pageSize,
  }) async {
    if (shouldThrow) {
      throw DioException(requestOptions: RequestOptions(path: '/preview'));
    }
    lastGetAddressId = addressId;
    lastGetPage = page;
    lastGetPageSize = pageSize;
    return const AddressCoveragePreviewResponseDto(
      pagination: AddressCoveragePaginationResponseDto(page: 4, totalCount: 10),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFamilyAddressesRemoteDataSource
    implements FamilyAddressesRemoteDataSource {
  String? lastPostMemberId;
  AddressCoveragePreviewRequestDto? lastPostRequest;
  String? lastGetMemberId;
  String? lastGetAddressId;
  int? lastGetPage;
  int? lastGetPageSize;
  bool shouldThrow = false;

  @override
  Future<AddressCoveragePreviewResponseDto> previewAddress(
    String memberId,
    AddressCoveragePreviewRequestDto request,
  ) async {
    if (shouldThrow) {
      throw DioException(requestOptions: RequestOptions(path: '/preview'));
    }
    lastPostMemberId = memberId;
    lastPostRequest = request;
    return const AddressCoveragePreviewResponseDto(
      pagination: AddressCoveragePaginationResponseDto(page: 1, totalCount: 10),
    );
  }

  @override
  Future<AddressCoveragePreviewResponseDto> previewExistingAddress(
    String memberId,
    String addressId, {
    int? page,
    int? pageSize,
  }) async {
    if (shouldThrow) {
      throw DioException(requestOptions: RequestOptions(path: '/preview'));
    }
    lastGetMemberId = memberId;
    lastGetAddressId = addressId;
    lastGetPage = page;
    lastGetPageSize = pageSize;
    return const AddressCoveragePreviewResponseDto(
      pagination: AddressCoveragePaginationResponseDto(page: 2, totalCount: 10),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
