import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';

abstract interface class ProfileRepository {
  Future<ApiResult<CustomerProfileEntity>> getCustomerProfile();

  Future<ApiResult<void>> updateCustomerProfile(
    UpdateCustomerProfileRequestEntity request,
  );

  Future<ApiResult<void>> updateCustomerProfileImage(
    ProfileImageRequestEntity request,
  );

  Future<ApiResult<void>> deleteCustomerProfileImage();

  Future<ApiResult<ProfileBillingCurrentEntity>>
  getCurrentCustomerSubscription();

  Future<ApiResult<ProfileBillingEntity>> getProfileBilling();
}
