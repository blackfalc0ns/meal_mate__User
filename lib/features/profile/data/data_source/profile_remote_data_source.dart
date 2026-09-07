import 'package:meal_meat_user/features/profile/data/models/request/profile_image_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/profile_billing_action_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/update_customer_profile_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_profile_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/profile_billing_response_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<CustomerProfileResponseDto> getCustomerProfile();

  Future<void> updateCustomerProfile(UpdateCustomerProfileRequestDto request);

  Future<void> updateCustomerProfileImage(ProfileImageRequestDto request);

  Future<void> deleteCustomerProfileImage();

  Future<ProfileBillingCurrentResponseDto> getCurrentCustomerSubscription();

  Future<List<ProfileBillingUncompletedSubscriptionResponseDto>>
  getUncompletedCustomerSubscriptions();

  Future<void> deleteUncompletedCustomerSubscription(String subscriptionId);

  Future<ProfileBillingResumePreviewResponseDto>
  getCustomerSubscriptionResumePreview(String subscriptionId);

  Future<ProfileBillingResumeResponseDto> resumeCustomerSubscription(
    String subscriptionId,
    ProfileBillingResumeRequestDto request,
  );

  Future<ProfileBillingFreezeDetailsResponseDto>
  getCurrentCustomerSubscriptionFreezeDetails();

  Future<ProfileBillingFreezeDetailsResponseDto>
  getCustomerSubscriptionFreezeDetails(String subscriptionId);

  Future<List<ProfileBillingInvoiceResponseDto>> getCustomerInvoices();

  Future<ProfileBillingPaymentMethodResponseDto>
  getDefaultCustomerPaymentMethod();

  Future<ProfileBillingFreezePolicyResponseDto>
  getCustomerSubscriptionFreezePolicy();

  Future<void> createCustomerSubscriptionRenewalRequest(String subscriptionId);

  Future<ProfileBillingFreezeResponseDto>
  createCustomerSubscriptionFreezeRequest(
    String subscriptionId,
    ProfileBillingFreezeRequestDto request,
  );

  Future<ProfileBillingCancellationQuoteResponseDto>
  getCustomerSubscriptionCancellationQuote(String subscriptionId);

  Future<ProfileBillingCancellationResultResponseDto>
  createCustomerSubscriptionCancellationRequest(
    String subscriptionId,
    ProfileBillingCancellationRequestDto request,
  );
}
