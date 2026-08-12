import 'package:meal_meat_user/features/addresses/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';

abstract interface class AddressesRemoteDataSource {
  Future<List<CustomerAddressResponseDto>> getCustomerAddresses();

  Future<void> addCustomerAddress(CustomerAddressRequestDto request);

  Future<void> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestDto request,
  );

  Future<void> deleteCustomerAddress(String addressId);
}
