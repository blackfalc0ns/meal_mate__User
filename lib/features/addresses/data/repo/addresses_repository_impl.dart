import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/data/data_source/addresses_remote_data_source.dart';
import 'package:meal_meat_user/features/addresses/data/mapper/customer_address_mapper.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@Injectable(as: AddressesRepository)
class AddressesRepositoryImpl implements AddressesRepository {
  AddressesRepositoryImpl(this._remoteDataSource);

  final AddressesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCustomerAddresses();
      return response.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<void>> addCustomerAddress(
    CustomerAddressRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.addCustomerAddress(request.toDto());
    });
  }

  @override
  Future<ApiResult<void>> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateCustomerAddress(addressId, request.toDto());
    });
  }

  @override
  Future<ApiResult<void>> deleteCustomerAddress(String addressId) {
    return safeApiCall(() async {
      await _remoteDataSource.deleteCustomerAddress(addressId);
    });
  }
}
