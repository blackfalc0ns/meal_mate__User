import 'package:meal_meat_user/features/addresses/data/models/request/address_coverage_preview_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/map_geocode_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/map_reverse_geocode_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/locations_catalog_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/map_address_autofill_response_dto.dart';

abstract interface class AddressesRemoteDataSource {
  Future<LocationsCatalogResponseDto> getLocationsCatalog(
    String countryCode,
    String? areaId,
  );

  Future<List<CustomerAddressResponseDto>> getCustomerAddresses();

  Future<CustomerAddressResponseDto> addCustomerAddress(
    CustomerAddressRequestDto request,
  );

  Future<CustomerAddressResponseDto> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestDto request,
  );

  Future<void> deleteCustomerAddress(String addressId);

  Future<AddressCoveragePreviewResponseDto> previewNewAddressCoverage(
    AddressCoveragePreviewRequestDto request,
  );

  Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(
    String addressId,
  );

  Future<CustomerAddressResponseDto> confirmSetDefaultAddress(String addressId);

  Future<MapAddressAutofillResponseDto> geocode(MapGeocodeRequestDto request);

  Future<MapAddressAutofillResponseDto> reverseGeocode(
    MapReverseGeocodeRequestDto request,
  );
}
