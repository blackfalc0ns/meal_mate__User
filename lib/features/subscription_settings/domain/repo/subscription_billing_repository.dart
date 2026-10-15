import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_auto_renewal_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';

abstract interface class SubscriptionBillingRepository {
  Future<ApiResult<SubscriptionBillingCurrentEntity>>
  getCurrentCustomerSubscription();

  Future<ApiResult<SubscriptionBillingFreezeDetailsEntity>>
  getCurrentCustomerSubscriptionFreezeDetails();

  Future<ApiResult<SubscriptionBillingFreezeDetailsEntity>>
  getCustomerSubscriptionFreezeDetails(String subscriptionId);

  Future<ApiResult<SubscriptionBillingEntity>> getSubscriptionBilling();

  Future<ApiResult<void>> createCustomerSubscriptionRenewalRequest(
    String subscriptionId,
  );

  Future<ApiResult<SubscriptionBillingFreezeResponseEntity>>
  createCustomerSubscriptionFreezeRequest({
    required String subscriptionId,
    required SubscriptionBillingFreezeRequestEntity request,
  });

  Future<ApiResult<SubscriptionBillingCancellationQuoteEntity>>
  getCustomerSubscriptionCancellationQuote(String subscriptionId);

  Future<ApiResult<SubscriptionBillingCancellationResultEntity>>
  createCustomerSubscriptionCancellationRequest({
    required String subscriptionId,
    required SubscriptionBillingCancellationRequestEntity request,
  });

  Future<ApiResult<SubscriptionAutoRenewalEntity>>
  getCustomerSubscriptionAutoRenewal(String subscriptionId);

  Future<ApiResult<SubscriptionAutoRenewalEntity>>
  updateCustomerSubscriptionAutoRenewalConsent({
    required String subscriptionId,
    required bool accepted,
    required String consentVersion,
    required num amount,
    required String currency,
  });

  Future<ApiResult<SubscriptionAutoRenewalEntity>>
  deleteCustomerSubscriptionAutoRenewalConsent(String subscriptionId);
}
