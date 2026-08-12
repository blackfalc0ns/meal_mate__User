import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:meal_meat_user/features/profile/data/models/request/change_customer_password_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/food_preferences_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/profile_image_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/update_customer_profile_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/upload_file_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_profile_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/food_preferences_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/upload_file_response_dto.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<CustomerProfileResponseDto> getCustomerProfile() {
    return _apiServices.getCustomerProfile();
  }

  @override
  Future<void> updateCustomerProfile(UpdateCustomerProfileRequestDto request) {
    return _apiServices.updateCustomerProfile(request);
  }

  @override
  Future<UploadFileResponseDto> uploadFile(UploadFileRequestDto request) {
    return _apiServices.uploadFile(request.file, request.scope, request.folder);
  }

  @override
  Future<void> updateCustomerProfileImage(ProfileImageRequestDto request) {
    return _apiServices.updateCustomerProfileImage(request);
  }

  @override
  Future<void> deleteCustomerProfileImage() {
    return _apiServices.deleteCustomerProfileImage();
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

  @override
  Future<void> changeCustomerPassword(
    ChangeCustomerPasswordRequestDto request,
  ) {
    return _apiServices.changeCustomerPassword(request);
  }

  @override
  Future<FoodPreferencesResponseDto> getFoodPreferences() {
    return _apiServices.getFoodPreferences();
  }

  @override
  Future<void> updateFoodPreferences(FoodPreferencesRequestDto request) {
    return _apiServices.updateFoodPreferences(request);
  }
}
