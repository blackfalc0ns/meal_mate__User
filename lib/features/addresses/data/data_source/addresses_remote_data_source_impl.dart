import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/addresses/data/data_source/addresses_remote_data_source.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/locations_catalog_response_dto.dart';

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
  Future<void> addCustomerAddress(CustomerAddressRequestDto request) {
    return _apiServices.addCustomerAddress(request);
  }

  @override
  Future<void> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestDto request,
  ) {
    return _apiServices.updateCustomerAddress(addressId, request);
  }

  @override
  Future<void> deleteCustomerAddress(String addressId) {
    return _apiServices.deleteCustomerAddress(addressId);
  }
}
