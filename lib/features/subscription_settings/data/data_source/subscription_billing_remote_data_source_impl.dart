import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/subscription_settings/data/data_source/subscription_billing_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_auto_renewal_consent_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_billing_action_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_auto_renewal_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';

@Injectable(as: SubscriptionBillingRemoteDataSource)
class SubscriptionBillingRemoteDataSourceImpl
    implements SubscriptionBillingRemoteDataSource {
  const SubscriptionBillingRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<SubscriptionBillingCurrentResponseDto>
  getCurrentCustomerSubscription() {
    return _apiServices.getCurrentCustomerSubscription();
  }

  @override
  Future<List<SubscriptionBillingUncompletedSubscriptionResponseDto>>
  getUncompletedCustomerSubscriptions() {
    return _apiServices.getUncompletedCustomerSubscriptions();
  }

  @override
  Future<void> deleteUncompletedCustomerSubscription(String subscriptionId) {
    return _apiServices.deleteUncompletedCustomerSubscription(subscriptionId);
  }

  @override
  Future<SubscriptionBillingResumePreviewResponseDto>
  getCustomerSubscriptionResumePreview(String subscriptionId) {
    return _apiServices.getCustomerSubscriptionResumePreview(subscriptionId);
  }

  @override
  Future<SubscriptionBillingResumeResponseDto> resumeCustomerSubscription(
    String subscriptionId,
    SubscriptionBillingResumeRequestDto request,
  ) {
    return _apiServices.resumeCustomerSubscription(subscriptionId, request);
  }

  @override
  Future<SubscriptionBillingFreezeDetailsResponseDto>
  getCurrentCustomerSubscriptionFreezeDetails() {
    return _apiServices.getCurrentCustomerSubscriptionFreezeDetails();
  }

  @override
  Future<SubscriptionBillingFreezeDetailsResponseDto>
  getCustomerSubscriptionFreezeDetails(String subscriptionId) {
    return _apiServices.getCustomerSubscriptionFreezeDetails(subscriptionId);
  }

  @override
  Future<List<SubscriptionBillingInvoiceResponseDto>> getCustomerInvoices() {
    return _apiServices.getCustomerInvoices();
  }

  @override
  Future<SubscriptionBillingPaymentMethodResponseDto>
  getDefaultCustomerPaymentMethod() {
    return _apiServices.getDefaultCustomerPaymentMethod();
  }

  @override
  Future<SubscriptionBillingFreezePolicyResponseDto>
  getCustomerSubscriptionFreezePolicy() {
    return _apiServices.getCustomerSubscriptionFreezePolicy();
  }

  @override
  Future<void> createCustomerSubscriptionRenewalRequest(String subscriptionId) {
    return _apiServices.createCustomerSubscriptionRenewalRequest(
      subscriptionId,
    );
  }

  @override
  Future<SubscriptionBillingFreezeResponseDto>
  createCustomerSubscriptionFreezeRequest(
    String subscriptionId,
    SubscriptionBillingFreezeRequestDto request,
  ) {
    return _apiServices.createCustomerSubscriptionFreezeRequest(
      subscriptionId,
      request,
    );
  }

  @override
  Future<SubscriptionBillingCancellationQuoteResponseDto>
  getCustomerSubscriptionCancellationQuote(String subscriptionId) {
    return _apiServices.getCustomerSubscriptionCancellationQuote(
      subscriptionId,
    );
  }

  @override
  Future<SubscriptionBillingCancellationResultResponseDto>
  createCustomerSubscriptionCancellationRequest(
    String subscriptionId,
    SubscriptionBillingCancellationRequestDto request,
  ) {
    return _apiServices.createCustomerSubscriptionCancellationRequest(
      subscriptionId,
      request,
    );
  }

  @override
  Future<SubscriptionAutoRenewalDto> getCustomerSubscriptionAutoRenewal(
    String subscriptionId,
  ) {
    return _apiServices.getSubscriptionAutoRenewal(subscriptionId);
  }

  @override
  Future<SubscriptionAutoRenewalDto> updateCustomerSubscriptionAutoRenewalConsent(
    String subscriptionId,
    SubscriptionAutoRenewalConsentRequestDto request,
  ) {
    return _apiServices.updateSubscriptionAutoRenewalConsent(
      subscriptionId,
      request,
    );
  }

  @override
  Future<SubscriptionAutoRenewalDto> deleteCustomerSubscriptionAutoRenewalConsent(
    String subscriptionId,
  ) {
    return _apiServices.deleteSubscriptionAutoRenewalConsent(subscriptionId);
  }
}
