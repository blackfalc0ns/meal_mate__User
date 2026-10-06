import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/add_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/confirm_set_default_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/delete_customer_address_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/update_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';

void main() {
  test(
    'locations catalog is requested once while the screen is alive',
    () async {
      final repository = _CountingAddressesRepository();
      final viewModel = AddressesViewModel(
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

      viewModel.doIntent(const GetLocationsCatalogEvent());
      await viewModel.stream.firstWhere((state) => state.locations.isSuccess);
      viewModel.doIntent(const GetLocationsCatalogEvent());
      await Future<void>.delayed(Duration.zero);

      expect(repository.locationsRequests, 1);
      await viewModel.close();
    },
  );

  test('identical reverse geocode coordinates reuse the last result', () async {
    final repository = _CountingAddressesRepository();
    final viewModel = AddressesViewModel(
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

    viewModel.doIntent(
      const ReverseGeocodeEvent(latitude: 29.338785, longitude: 48.079744),
    );
    await viewModel.stream.firstWhere((state) => state.mapAutofill.isSuccess);
    viewModel.doIntent(
      const ReverseGeocodeEvent(latitude: 29.338786, longitude: 48.079745),
    );
    await Future<void>.delayed(Duration.zero);

    expect(repository.reverseGeocodeRequests, 1);
    await viewModel.close();
  });
}

class _CountingAddressesRepository
    implements AddressesRepository, AddressLocationRepository {
  int locationsRequests = 0;
  int reverseGeocodeRequests = 0;

  @override
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode,
    String? areaId,
  ) async {
    locationsRequests++;
    return ApiSuccessResult(
      data: const LocationsCatalogEntity(countryId: 'kw', countryCode: 'KW'),
    );
  }

  @override
  Future<ApiResult<MapAddressAutofillEntity>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    reverseGeocodeRequests++;
    return ApiSuccessResult(
      data: MapAddressAutofillEntity(
        latitude: latitude,
        longitude: longitude,
        formattedAddress: 'Salmiyah',
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
