import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/change_customer_password_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_request_entity.dart';

abstract interface class ProfileRepository {
  Future<ApiResult<CustomerProfileEntity>> getCustomerProfile();

  Future<ApiResult<void>> updateCustomerProfile(
    UpdateCustomerProfileRequestEntity request,
  );

  Future<ApiResult<UploadFileEntity>> uploadFile(
    UploadFileRequestEntity request,
  );

  Future<ApiResult<void>> updateCustomerProfileImage(
    ProfileImageRequestEntity request,
  );

  Future<ApiResult<void>> deleteCustomerProfileImage();

  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses();

  Future<ApiResult<void>> addCustomerAddress(
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<void>> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<void>> deleteCustomerAddress(String addressId);

  Future<ApiResult<void>> changeCustomerPassword(
    ChangeCustomerPasswordRequestEntity request,
  );

  Future<ApiResult<FoodPreferencesEntity>> getFoodPreferences();

  Future<ApiResult<void>> updateFoodPreferences(
    FoodPreferencesEntity preferences,
  );
}
