import 'package:meal_meat_user/features/profile/data/models/request/profile_image_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/update_customer_profile_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_profile_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/profile_billing_response_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<CustomerProfileResponseDto> getCustomerProfile();

  Future<void> updateCustomerProfile(UpdateCustomerProfileRequestDto request);

  Future<void> updateCustomerProfileImage(ProfileImageRequestDto request);

  Future<void> deleteCustomerProfileImage();

  Future<ProfileBillingCurrentResponseDto> getCurrentCustomerSubscription();

  Future<List<ProfileBillingInvoiceResponseDto>> getCustomerInvoices();

  Future<ProfileBillingPaymentMethodResponseDto>
  getDefaultCustomerPaymentMethod();

  Future<ProfileBillingFreezePolicyResponseDto>
  getCustomerSubscriptionFreezePolicy();
}
