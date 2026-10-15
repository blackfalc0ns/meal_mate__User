import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_auto_renewal_consent_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_billing_action_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_auto_renewal_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';

abstract interface class SubscriptionBillingRemoteDataSource {
  Future<SubscriptionBillingCurrentResponseDto>
  getCurrentCustomerSubscription();

  Future<List<SubscriptionBillingUncompletedSubscriptionResponseDto>>
  getUncompletedCustomerSubscriptions();

  Future<void> deleteUncompletedCustomerSubscription(String subscriptionId);

  Future<SubscriptionBillingResumePreviewResponseDto>
  getCustomerSubscriptionResumePreview(String subscriptionId);

  Future<SubscriptionBillingResumeResponseDto> resumeCustomerSubscription(
    String subscriptionId,
    SubscriptionBillingResumeRequestDto request,
  );

  Future<SubscriptionBillingFreezeDetailsResponseDto>
  getCurrentCustomerSubscriptionFreezeDetails();

  Future<SubscriptionBillingFreezeDetailsResponseDto>
  getCustomerSubscriptionFreezeDetails(String subscriptionId);

  Future<List<SubscriptionBillingInvoiceResponseDto>> getCustomerInvoices();

  Future<SubscriptionBillingPaymentMethodResponseDto>
  getDefaultCustomerPaymentMethod();

  Future<SubscriptionBillingFreezePolicyResponseDto>
  getCustomerSubscriptionFreezePolicy();

  Future<void> createCustomerSubscriptionRenewalRequest(String subscriptionId);

  Future<SubscriptionBillingFreezeResponseDto>
  createCustomerSubscriptionFreezeRequest(
    String subscriptionId,
    SubscriptionBillingFreezeRequestDto request,
  );

  Future<SubscriptionBillingCancellationQuoteResponseDto>
  getCustomerSubscriptionCancellationQuote(String subscriptionId);

  Future<SubscriptionBillingCancellationResultResponseDto>
  createCustomerSubscriptionCancellationRequest(
    String subscriptionId,
    SubscriptionBillingCancellationRequestDto request,
  );

  Future<SubscriptionAutoRenewalDto> getCustomerSubscriptionAutoRenewal(
    String subscriptionId,
  );

  Future<SubscriptionAutoRenewalDto> updateCustomerSubscriptionAutoRenewalConsent(
    String subscriptionId,
    SubscriptionAutoRenewalConsentRequestDto request,
  );

  Future<SubscriptionAutoRenewalDto> deleteCustomerSubscriptionAutoRenewalConsent(
    String subscriptionId,
  );
}
