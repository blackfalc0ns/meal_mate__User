import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:meal_meat_user/features/profile/data/models/request/profile_image_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/update_customer_profile_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_profile_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/profile_billing_response_dto.dart';

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
  Future<void> updateCustomerProfileImage(ProfileImageRequestDto request) {
    return _apiServices.updateCustomerProfileImage(request);
  }

  @override
  Future<void> deleteCustomerProfileImage() {
    return _apiServices.deleteCustomerProfileImage();
  }

  @override
  Future<ProfileBillingCurrentResponseDto> getCurrentCustomerSubscription() {
    return _apiServices.getCurrentCustomerSubscription();
  }

  @override
  Future<List<ProfileBillingInvoiceResponseDto>> getCustomerInvoices() {
    return _apiServices.getCustomerInvoices();
  }

  @override
  Future<ProfileBillingPaymentMethodResponseDto>
  getDefaultCustomerPaymentMethod() {
    return _apiServices.getDefaultCustomerPaymentMethod();
  }

  @override
  Future<ProfileBillingFreezePolicyResponseDto>
  getCustomerSubscriptionFreezePolicy() {
    return _apiServices.getCustomerSubscriptionFreezePolicy();
  }
}
