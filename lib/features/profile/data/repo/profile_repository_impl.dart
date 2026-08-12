import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:meal_meat_user/features/profile/data/mapper/customer_profile_mapper.dart';
import 'package:meal_meat_user/features/profile/domain/entities/change_customer_password_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<CustomerProfileEntity>> getCustomerProfile() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCustomerProfile();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> updateCustomerProfile(
    UpdateCustomerProfileRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateCustomerProfile(request.toDto());
    });
  }

  @override
  Future<ApiResult<UploadFileEntity>> uploadFile(
    UploadFileRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.uploadFile(
        await request.toDto(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> updateCustomerProfileImage(
    ProfileImageRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateCustomerProfileImage(request.toDto());
    });
  }

  @override
  Future<ApiResult<void>> deleteCustomerProfileImage() {
    return safeApiCall(() async {
      await _remoteDataSource.deleteCustomerProfileImage();
    });
  }

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

  @override
  Future<ApiResult<void>> changeCustomerPassword(
    ChangeCustomerPasswordRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.changeCustomerPassword(request.toDto());
    });
  }

  @override
  Future<ApiResult<FoodPreferencesEntity>> getFoodPreferences() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFoodPreferences();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> updateFoodPreferences(
    FoodPreferencesEntity preferences,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateFoodPreferences(preferences.toDto());
    });
  }
}
