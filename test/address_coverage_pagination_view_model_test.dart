import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_pagination_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/add_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/confirm_set_default_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/delete_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/update_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';

void main() {
  group('AddressesViewModel Coverage Pagination Tests', () {
    late _ControlledAddressesRepository repository;
    late AddressesViewModel viewModel;

    setUp(() {
      repository = _ControlledAddressesRepository();
      viewModel = AddressesViewModel(
        GetCustomerAddressesUseCase(repository),
        GetLocationsCatalogUseCase(repository),
        AddCustomerAddressUseCase(repository),
        UpdateCustomerAddressUseCase(repository),
        DeleteCustomerAddressUseCase(repository),
        GeocodeAddressUseCase(repository),
        ReverseGeocodeLocationUseCase(repository),
        PreviewNewAddressCoverageUseCase(repository),
        PreviewExistingAddressCoverageUseCase(repository),
        ConfirmSetDefaultAddressUseCase(repository),
      );
    });

    tearDown(() async {
      await viewModel.close();
    });

    const validRequest = CustomerAddressRequestEntity(
      label: 'Home',
      addressLine: 'Salmiya',
      latitude: 29.34,
      longitude: 48.08,
      isDefault: true,
      notifyOnDelivery: false,
    );

    test(
      'first page request uses (1, 20) and subsequent load-more uses (2, 20) merging restaurants',
      () async {
        repository.pageResponses[1] = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [
            ServingRestaurantEntity(id: 'r1', nameAr: 'مطعم 1', nameEn: 'R1'),
          ],
          pagination: AddressCoveragePaginationEntity(
            page: 1,
            pageSize: 20,
            totalCount: 40,
            totalPages: 2,
            hasNextPage: true,
            hasPreviousPage: false,
          ),
        );

        repository.pageResponses[2] = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [
            ServingRestaurantEntity(id: 'r2', nameAr: 'مطعم 2', nameEn: 'R2'),
          ],
          pagination: AddressCoveragePaginationEntity(
            page: 2,
            pageSize: 20,
            totalCount: 40,
            totalPages: 2,
            hasNextPage: false,
            hasPreviousPage: true,
          ),
        );

        viewModel.doIntent(const PreviewNewAddressCoverageEvent(validRequest));
        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>(
              (s) =>
                  s.coveragePreview.isSuccess &&
                  s.coveragePreview.preview?.servingRestaurants.length == 1,
            ),
          ),
        );

        expect(repository.recordedCalls, [(1, 20)]);
        expect(viewModel.state.coveragePreview.canLoadMore, isTrue);

        viewModel.doIntent(const LoadMoreAddressCoverageRestaurantsEvent());
        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>(
              (s) =>
                  s.coveragePreview.isSuccess &&
                  s.coveragePreview.preview?.servingRestaurants.length == 2 &&
                  !s.coveragePreview.isLoadingMore,
            ),
          ),
        );

        expect(repository.recordedCalls, [(1, 20), (2, 20)]);
        final restaurants =
            viewModel.state.coveragePreview.preview!.servingRestaurants;
        expect(restaurants.map((e) => e.id).toList(), ['r1', 'r2']);
        expect(viewModel.state.coveragePreview.canLoadMore, isFalse);
      },
    );

    test(
      'duplicate load-more requests issue only one in-flight call',
      () async {
        repository.pageResponses[1] = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [
            ServingRestaurantEntity(id: 'r1', nameAr: 'مطعم 1', nameEn: 'R1'),
          ],
          pagination: AddressCoveragePaginationEntity(
            page: 1,
            pageSize: 20,
            totalCount: 40,
            totalPages: 2,
            hasNextPage: true,
            hasPreviousPage: false,
          ),
        );

        final page2Completer =
            Completer<ApiResult<AddressCoveragePreviewEntity>>();
        repository.customResponseForCall = (page, pageSize) {
          if (page == 2) return page2Completer.future;
          return null;
        };

        viewModel.doIntent(const PreviewNewAddressCoverageEvent(validRequest));
        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>((s) => s.coveragePreview.isSuccess),
          ),
        );

        viewModel.doIntent(const LoadMoreAddressCoverageRestaurantsEvent());
        viewModel.doIntent(const LoadMoreAddressCoverageRestaurantsEvent());

        expect(repository.recordedCalls, [(1, 20), (2, 20)]);

        page2Completer.complete(
          ApiSuccessResult(
            data: const AddressCoveragePreviewEntity(
              canSetAsDefault: true,
              isCurrentSubscriptionRestaurantCovered: true,
              hasActiveSubscription: true,
              servingRestaurants: [
                ServingRestaurantEntity(
                  id: 'r2',
                  nameAr: 'مطعم 2',
                  nameEn: 'R2',
                ),
              ],
              pagination: AddressCoveragePaginationEntity(
                page: 2,
                pageSize: 20,
                totalCount: 40,
                totalPages: 2,
                hasNextPage: false,
              ),
            ),
          ),
        );

        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>((s) => !s.coveragePreview.isLoadingMore),
          ),
        );

        expect(repository.recordedCalls.where((c) => c.$1 == 2).length, 1);
      },
    );

    test(
      'deduplicates existing IDs in server order and preserves empty IDs as distinct',
      () async {
        repository.pageResponses[1] = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [
            ServingRestaurantEntity(id: 'r1', nameAr: 'مطعم 1', nameEn: 'R1'),
            ServingRestaurantEntity(
              id: '',
              nameAr: 'بلا معرف 1',
              nameEn: 'No ID 1',
            ),
          ],
          pagination: AddressCoveragePaginationEntity(
            page: 1,
            pageSize: 20,
            hasNextPage: true,
          ),
        );

        repository.pageResponses[2] = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [
            ServingRestaurantEntity(
              id: 'r1',
              nameAr: 'مطعم 1 مكرر',
              nameEn: 'R1 dup',
            ),
            ServingRestaurantEntity(
              id: '',
              nameAr: 'بلا معرف 2',
              nameEn: 'No ID 2',
            ),
            ServingRestaurantEntity(id: 'r2', nameAr: 'مطعم 2', nameEn: 'R2'),
          ],
          pagination: AddressCoveragePaginationEntity(
            page: 2,
            pageSize: 20,
            hasNextPage: false,
          ),
        );

        viewModel.doIntent(const PreviewNewAddressCoverageEvent(validRequest));
        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>((s) => s.coveragePreview.isSuccess),
          ),
        );

        viewModel.doIntent(const LoadMoreAddressCoverageRestaurantsEvent());
        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>((s) => !s.coveragePreview.isLoadingMore),
          ),
        );

        final result =
            viewModel.state.coveragePreview.preview!.servingRestaurants;
        expect(result.length, 4); // r1, empty1, empty2, r2
        expect(result[0].id, 'r1');
        expect(result[0].nameEn, 'R1'); // first seen preserved
        expect(result[1].nameEn, 'No ID 1');
        expect(result[2].nameEn, 'No ID 2');
        expect(result[3].id, 'r2');
      },
    );

    test(
      'incremental error preserves accumulated restaurants and retry requests same page',
      () async {
        repository.pageResponses[1] = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [
            ServingRestaurantEntity(id: 'r1', nameAr: 'مطعم 1', nameEn: 'R1'),
          ],
          pagination: AddressCoveragePaginationEntity(
            page: 1,
            pageSize: 20,
            totalCount: 40,
            totalPages: 2,
            hasNextPage: true,
          ),
        );

        repository.customResponseForCall = (page, pageSize) {
          if (page == 2 &&
              repository.recordedCalls.where((c) => c.$1 == 2).length == 1) {
            return Future.value(
              ApiErrorResult(failure: Failure(errorMessage: 'Fail')),
            );
          }
          return null;
        };

        repository.pageResponses[2] = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [
            ServingRestaurantEntity(id: 'r2', nameAr: 'مطعم 2', nameEn: 'R2'),
          ],
          pagination: AddressCoveragePaginationEntity(
            page: 2,
            pageSize: 20,
            totalCount: 40,
            totalPages: 2,
            hasNextPage: false,
          ),
        );

        viewModel.doIntent(const PreviewNewAddressCoverageEvent(validRequest));
        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>((s) => s.coveragePreview.isSuccess),
          ),
        );

        viewModel.doIntent(const LoadMoreAddressCoverageRestaurantsEvent());
        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>(
              (s) => s.coveragePreview.loadMoreFailure != null,
            ),
          ),
        );

        expect(
          viewModel.state.coveragePreview.preview!.servingRestaurants.length,
          1,
        );
        expect(viewModel.state.coveragePreview.loadMoreFailure, isNotNull);

        // Retry should request page 2 again
        viewModel.doIntent(const RetryAddressCoveragePreviewEvent());
        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>(
              (s) =>
                  s.coveragePreview.loadMoreFailure == null &&
                  s.coveragePreview.preview!.servingRestaurants.length == 2,
            ),
          ),
        );

        expect(repository.recordedCalls, [(1, 20), (2, 20), (2, 20)]);
      },
    );

    test(
      'stale response or error from superseded session is discarded',
      () async {
        final firstRequestCompleter =
            Completer<ApiResult<AddressCoveragePreviewEntity>>();
        repository.customResponseForCall = (page, pageSize) {
          if (repository.recordedCalls.length == 1) {
            return firstRequestCompleter.future;
          }
          return null;
        };

        repository.pageResponses[1] = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [
            ServingRestaurantEntity(
              id: 'r-fresh',
              nameAr: 'طازج',
              nameEn: 'Fresh',
            ),
          ],
          pagination: AddressCoveragePaginationEntity(
            page: 1,
            pageSize: 20,
            hasNextPage: false,
          ),
        );

        viewModel.doIntent(const PreviewNewAddressCoverageEvent(validRequest));
        final initialSessionId = viewModel.state.coveragePreview.sessionId;

        // Start new preview session
        viewModel.doIntent(const PreviewNewAddressCoverageEvent(validRequest));
        expect(
          viewModel.state.coveragePreview.sessionId,
          greaterThan(initialSessionId),
        );

        await expectLater(
          viewModel.stream,
          emitsThrough(
            predicate<AddressesState>(
              (s) =>
                  s.coveragePreview.isSuccess &&
                  s.coveragePreview.preview?.servingRestaurants.first.id ==
                      'r-fresh',
            ),
          ),
        );

        // Now complete old session with failure; it should be ignored
        firstRequestCompleter.complete(
          ApiErrorResult(failure: Failure(errorMessage: 'Old error')),
        );
        await Future.delayed(const Duration(milliseconds: 50));

        expect(viewModel.state.coveragePreview.isSuccess, isTrue);
        expect(viewModel.state.coveragePreview.failure, isNull);
        expect(
          viewModel.state.coveragePreview.preview?.servingRestaurants.first.id,
          'r-fresh',
        );
      },
    );
  });
}

class _ControlledAddressesRepository implements AddressesRepository {
  final Map<int, AddressCoveragePreviewEntity> pageResponses = {};
  Future<ApiResult<AddressCoveragePreviewEntity>>? Function(
    int page,
    int pageSize,
  )?
  customResponseForCall;
  final List<(int, int)> recordedCalls = [];

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>> previewNewAddressCoverage(
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  }) async {
    final p = page ?? 1;
    final ps = pageSize ?? 20;
    recordedCalls.add((p, ps));

    if (customResponseForCall != null) {
      final custom = customResponseForCall!(p, ps);
      if (custom != null) return custom;
    }

    final entity =
        pageResponses[p] ??
        const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
        );
    return ApiSuccessResult(data: entity);
  }

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>>
  previewExistingAddressCoverage(
    String addressId, {
    int? page,
    int? pageSize,
  }) async {
    return previewNewAddressCoverage(
      const CustomerAddressRequestEntity(
        label: '',
        addressLine: '',
        latitude: 29.3,
        longitude: 48.0,
        isDefault: false,
        notifyOnDelivery: false,
      ),
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
