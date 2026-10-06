import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/data/mapper/customer_address_mapper.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/data/data_source/addresses_remote_data_source.dart';
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
  Future<ApiResult<CustomerAddressEntity>> addCustomerAddress(
    CustomerAddressRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addCustomerAddress(
        request.toDto(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateCustomerAddress(
        addressId,
        request.toDto(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> deleteCustomerAddress(String addressId) {
    return safeApiCall(() async {
      await _remoteDataSource.deleteCustomerAddress(addressId);
    });
  }

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>> previewNewAddressCoverage(
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.previewNewAddressCoverage(
        request.toPreviewDto(page: page, pageSize: pageSize),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>>
  previewExistingAddressCoverage(String addressId, {int? page, int? pageSize}) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.previewExistingAddressCoverage(
        addressId,
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> confirmSetDefaultAddress(
    String addressId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.confirmSetDefaultAddress(
        addressId,
      );
      return response.toEntity();
    });
  }
}
