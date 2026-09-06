import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/addresses/data/data_source/addresses_remote_data_source.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/address_coverage_preview_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/map_geocode_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/map_reverse_geocode_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/locations_catalog_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/map_address_autofill_response_dto.dart';

@Injectable(as: AddressesRemoteDataSource)
class AddressesRemoteDataSourceImpl implements AddressesRemoteDataSource {
  AddressesRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<LocationsCatalogResponseDto> getLocationsCatalog(
    String countryCode,
    String? areaId,
  ) {
    return _apiServices.getLocationsCatalog(countryCode, areaId);
  }

  @override
  Future<List<CustomerAddressResponseDto>> getCustomerAddresses() {
    return _apiServices.getCustomerAddresses();
  }

  @override
  Future<CustomerAddressResponseDto> addCustomerAddress(
    CustomerAddressRequestDto request,
  ) {
    return _apiServices.addCustomerAddress(request);
  }

  @override
  Future<CustomerAddressResponseDto> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestDto request,
  ) {
    return _apiServices.updateCustomerAddress(addressId, request);
  }

  @override
  Future<void> deleteCustomerAddress(String addressId) {
    return _apiServices.deleteCustomerAddress(addressId);
  }

  @override
  Future<AddressCoveragePreviewResponseDto> previewNewAddressCoverage(
    AddressCoveragePreviewRequestDto request,
  ) {
    return _apiServices.previewNewAddressCoverage(request);
  }

  @override
  Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(
    String addressId,
  ) {
    return _apiServices.previewExistingAddressCoverage(addressId);
  }

  @override
  Future<CustomerAddressResponseDto> confirmSetDefaultAddress(
    String addressId,
  ) {
    return _apiServices.confirmSetDefaultAddress(addressId, const {});
  }

  @override
  Future<MapAddressAutofillResponseDto> geocode(
    MapGeocodeRequestDto request,
  ) {
    return _apiServices.geocode(request);
  }

  @override
  Future<MapAddressAutofillResponseDto> reverseGeocode(
    MapReverseGeocodeRequestDto request,
  ) {
    return _apiServices.reverseGeocode(request);
  }
}
