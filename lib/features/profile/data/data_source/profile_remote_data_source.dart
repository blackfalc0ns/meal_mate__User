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

abstract interface class ProfileRemoteDataSource {
  Future<CustomerProfileResponseDto> getCustomerProfile();

  Future<void> updateCustomerProfile(UpdateCustomerProfileRequestDto request);

  Future<UploadFileResponseDto> uploadFile(UploadFileRequestDto request);

  Future<void> updateCustomerProfileImage(ProfileImageRequestDto request);

  Future<void> deleteCustomerProfileImage();

  Future<List<CustomerAddressResponseDto>> getCustomerAddresses();

  Future<void> addCustomerAddress(CustomerAddressRequestDto request);

  Future<void> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestDto request,
  );

  Future<void> deleteCustomerAddress(String addressId);

  Future<void> changeCustomerPassword(ChangeCustomerPasswordRequestDto request);

  Future<FoodPreferencesResponseDto> getFoodPreferences();

  Future<void> updateFoodPreferences(FoodPreferencesRequestDto request);
}
