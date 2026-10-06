import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/address/domain/contracts/address_editor_operations.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
import 'package:meal_meat_user/core/address/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_event.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_view_model.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/customer_address_editor_operations.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_address_editor_operations.dart';

class FakeAddressLocationRepo implements AddressLocationRepository {
  FakeAddressLocationRepo({
    this.catalogResult,
    this.geocodeResult,
    this.reverseGeocodeResult,
  });

  LocationsCatalogEntity? catalogResult;
  MapAddressAutofillEntity? geocodeResult;
  MapAddressAutofillEntity? reverseGeocodeResult;

  @override
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode, [
    String? areaId,
  ]) async {
    final catalog = catalogResult ??
        LocationsCatalogEntity(
          countryId: 'country-1',
          countryCode: countryCode,
          governorates: [
            LocationGovernorateEntity(
              id: 'gov-1',
              nameAr: 'العاصمة',
              nameEn: 'Capital',
              code: 'CAP',
              areas: [
                LocationAreaEntity(
                  id: 'area-1',
                  nameAr: 'الشرق',
                  nameEn: 'Sharq',
                  code: 'SHQ',
                  blocks: [
                    LocationBlockEntity(
                      id: 'block-1',
                      nameAr: 'قطعة 1',
                      nameEn: 'Block 1',
                      code: 'B1',
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
    return ApiSuccessResult(data: catalog);
  }

  @override
  Future<ApiResult<MapAddressAutofillEntity>> geocode(
    String address, {
    String countryCode = 'KW',
  }) async {
    return ApiSuccessResult(
      data: geocodeResult ??
          const MapAddressAutofillEntity(
            latitude: 29.35,
            longitude: 48.01,
            formattedAddress: 'Sharq, Block 1',
            street: 'Salem Street',
          ),
    );
  }

  @override
  Future<ApiResult<MapAddressAutofillEntity>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    return ApiSuccessResult(
      data: reverseGeocodeResult ??
          MapAddressAutofillEntity(
            latitude: latitude,
            longitude: longitude,
            formattedAddress: 'Sharq, Block 1',
            street: 'Salem Street',
          ),
    );
  }
}

void main() {
  group('AddressEditorViewModel tests', () {
    const validRequest = CustomerAddressRequestEntity(
      label: 'Home',
      addressLine: 'Kuwait City',
      latitude: 29.34,
      longitude: 48.08,
      isDefault: true,
      notifyOnDelivery: true,
    );

    const outOfBoundsRequest = CustomerAddressRequestEntity(
      label: 'Home',
      addressLine: 'Outside Kuwait',
      latitude: 10.0,
      longitude: 10.0,
      isDefault: true,
      notifyOnDelivery: true,
    );

    const dummyAddress = CustomerAddressEntity(
      addressId: 'addr-123',
      label: 'Home',
      addressLine: 'Kuwait City',
      isDefault: true,
      notifyOnDelivery: true,
    );

    const dummyPreview = AddressCoveragePreviewEntity(
      canSetAsDefault: true,
      isCurrentSubscriptionRestaurantCovered: true,
      hasActiveSubscription: true,
      servingRestaurants: [],
    );

    late FakeAddressLocationRepo fakeRepo;
    late GetLocationsCatalogUseCase getCatalog;
    late GeocodeAddressUseCase geocode;
    late ReverseGeocodeLocationUseCase reverseGeocode;

    setUp(() {
      fakeRepo = FakeAddressLocationRepo();
      getCatalog = GetLocationsCatalogUseCase(fakeRepo);
      geocode = GeocodeAddressUseCase(fakeRepo);
      reverseGeocode = ReverseGeocodeLocationUseCase(fakeRepo);
    });

    test('customer operations add, update, setDefault delegate and emit success', () async {
      final ops = CustomerAddressEditorOperations(
        previewNewAddressCoverage: (req, {page, pageSize}) async =>
            const ApiSuccessResult(data: dummyPreview),
        previewExistingAddressCoverage: (id, {page, pageSize}) async =>
            const ApiSuccessResult(data: dummyPreview),
        addCustomerAddress: (req) async =>
            const ApiSuccessResult(data: dummyAddress),
        updateCustomerAddress: (id, req) async =>
            const ApiSuccessResult(data: dummyAddress),
        confirmSetDefaultAddress: (id) async =>
            const ApiSuccessResult(data: dummyAddress),
      );

      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      // Add address
      await vm.doIntent(const SubmitAddressEvent(request: validRequest));
      expect(vm.state.action.isSuccess, isTrue);
      expect(vm.state.action.address?.addressId, 'addr-123');

      // Update address
      await vm.doIntent(const SubmitAddressEvent(
        request: validRequest,
        addressId: 'addr-123',
      ));
      expect(vm.state.action.isSuccess, isTrue);

      // Set default
      await vm.doIntent(const SetDefaultAddressEvent('addr-123'));
      expect(vm.state.action.isSuccess, isTrue);

      await vm.close();
    });

    test('family operations guard against unsupported update and setDefault', () async {
      final ops = FamilyAddressEditorOperations(
        memberId: 'member-1',
        previewFamilyMemberAddress: (mId, req, {page, pageSize}) async =>
            const ApiSuccessResult(data: dummyPreview),
        addFamilyMemberAddress: (mId, req) async =>
            const ApiSuccessResult(data: dummyAddress),
      );

      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      // Add should succeed
      await vm.doIntent(const SubmitAddressEvent(request: validRequest));
      expect(vm.state.action.isSuccess, isTrue);

      // Update should immediately fail without calling API
      await vm.doIntent(const SubmitAddressEvent(
        request: validRequest,
        addressId: 'addr-123',
      ));
      expect(vm.state.action.isSuccess, isFalse);
      expect(vm.state.action.failure?.errorMessage, contains('not supported'));

      // Set default should immediately fail without calling API
      await vm.doIntent(const SetDefaultAddressEvent('addr-123'));
      expect(vm.state.action.isSuccess, isFalse);
      expect(vm.state.action.failure?.errorMessage, contains('not supported'));

      await vm.close();
    });

    test('validates Kuwait bounds before submit and preview', () async {
      var addCalled = false;
      final ops = CustomerAddressEditorOperations(
        addCustomerAddress: (req) async {
          addCalled = true;
          return const ApiSuccessResult(data: dummyAddress);
        },
      );

      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      await vm.doIntent(const SubmitAddressEvent(request: outOfBoundsRequest));
      expect(addCalled, isFalse);
      expect(vm.state.action.failure, isA<AddressOutOfBoundsFailure>());

      await vm.doIntent(const PreviewNewAddressCoverageEvent(outOfBoundsRequest));
      expect(vm.state.coveragePreview.failure, isA<AddressOutOfBoundsFailure>());

      await vm.close();
    });

    test('await doIntent waits for async completion before returning', () async {
      final completer = Completer<ApiResult<CustomerAddressEntity>>();

      final ops = CustomerAddressEditorOperations(
        addCustomerAddress: (req) => completer.future,
      );

      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      var finished = false;
      final future = vm.doIntent(const SubmitAddressEvent(request: validRequest)).then((_) {
        finished = true;
      });

      // Give microtasks time to run
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(finished, isFalse);
      expect(vm.state.action.isLoading, isTrue);

      completer.complete(const ApiSuccessResult(data: dummyAddress));
      await future;

      expect(finished, isTrue);
      expect(vm.state.action.isLoading, isFalse);
      expect(vm.state.action.isSuccess, isTrue);

      await vm.close();
    });

    test('catalog loading and area selection updates state correctly', () async {
      final ops = CustomerAddressEditorOperations();
      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      await vm.doIntent(const GetLocationsCatalogEvent());
      expect(vm.state.locations.isSuccess, isTrue);
      expect(vm.state.locations.governorates.length, 1);

      final gov = vm.state.locations.governorates.first;
      vm.doIntent(SelectAddressGovernorateEvent(gov));
      expect(vm.state.locations.selectedGovernorate, gov);

      final area = gov.areas.first;
      await vm.doIntent(SelectAddressAreaEvent(area));
      expect(vm.state.locations.selectedArea?.id, area.id);

      await vm.close();
    });
  });
}
