import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/data/data_source/subscription_billing_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_billing_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';

@Injectable(as: SubscriptionBillingRepository)
class SubscriptionBillingRepositoryImpl
    implements SubscriptionBillingRepository {
  const SubscriptionBillingRepositoryImpl(this._remoteDataSource);

  final SubscriptionBillingRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>>
  getCurrentCustomerSubscription() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCurrentCustomerSubscription();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionBillingFreezeDetailsEntity>>
  getCurrentCustomerSubscriptionFreezeDetails() {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .getCurrentCustomerSubscriptionFreezeDetails();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionBillingFreezeDetailsEntity>>
  getCustomerSubscriptionFreezeDetails(String subscriptionId) {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .getCustomerSubscriptionFreezeDetails(subscriptionId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionBillingEntity>> getSubscriptionBilling() {
    return safeApiCall(() async {
      final (
        current,
        uncompleted,
        invoices,
        paymentMethod,
        freezePolicy,
      ) = await (
        _remoteDataSource.getCurrentCustomerSubscription(),
        _remoteDataSource.getUncompletedCustomerSubscriptions(),
        _remoteDataSource.getCustomerInvoices(),
        _remoteDataSource.getDefaultCustomerPaymentMethod(),
        _remoteDataSource.getCustomerSubscriptionFreezePolicy(),
      ).wait;

      return SubscriptionBillingEntity(
        current: current.toEntity(),
        uncompletedSubscriptions: uncompleted
            .map((subscription) => subscription.toEntity())
            .toList(),
        invoices: invoices.map((invoice) => invoice.toEntity()).toList(),
        paymentMethod: paymentMethod.toEntity(),
        freezePolicy: freezePolicy.toEntity(),
      );
    });
  }

  @override
  Future<ApiResult<void>> createCustomerSubscriptionRenewalRequest(
    String subscriptionId,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.createCustomerSubscriptionRenewalRequest(
        subscriptionId,
      );
    });
  }

  @override
  Future<ApiResult<SubscriptionBillingFreezeResponseEntity>>
  createCustomerSubscriptionFreezeRequest({
    required String subscriptionId,
    required SubscriptionBillingFreezeRequestEntity request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .createCustomerSubscriptionFreezeRequest(
            subscriptionId,
            request.toDto(),
          );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionBillingCancellationQuoteEntity>>
  getCustomerSubscriptionCancellationQuote(String subscriptionId) {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .getCustomerSubscriptionCancellationQuote(subscriptionId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionBillingCancellationResultEntity>>
  createCustomerSubscriptionCancellationRequest({
    required String subscriptionId,
    required SubscriptionBillingCancellationRequestEntity request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .createCustomerSubscriptionCancellationRequest(
            subscriptionId,
            request.toDto(),
          );
      return response.toEntity();
    });
  }
}
