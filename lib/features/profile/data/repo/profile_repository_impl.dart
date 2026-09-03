import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:meal_meat_user/features/profile/data/mapper/customer_profile_mapper.dart';
import 'package:meal_meat_user/features/profile/data/mapper/profile_billing_mapper.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<CustomerProfileEntity>> getCustomerProfile() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCustomerProfile();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> updateCustomerProfile(
    UpdateCustomerProfileRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateCustomerProfile(request.toDto());
    });
  }

  @override
  Future<ApiResult<void>> updateCustomerProfileImage(
    ProfileImageRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateCustomerProfileImage(request.toDto());
    });
  }

  @override
  Future<ApiResult<void>> deleteCustomerProfileImage() {
    return safeApiCall(() async {
      await _remoteDataSource.deleteCustomerProfileImage();
    });
  }

  @override
  Future<ApiResult<ProfileBillingCurrentEntity>>
  getCurrentCustomerSubscription() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCurrentCustomerSubscription();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<ProfileBillingFreezeDetailsEntity>>
  getCurrentCustomerSubscriptionFreezeDetails() {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .getCurrentCustomerSubscriptionFreezeDetails();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<ProfileBillingFreezeDetailsEntity>>
  getCustomerSubscriptionFreezeDetails(String subscriptionId) {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .getCustomerSubscriptionFreezeDetails(subscriptionId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<ProfileBillingEntity>> getProfileBilling() {
    return safeApiCall(() async {
      final (current, invoices, paymentMethod, freezePolicy) = await (
        _remoteDataSource.getCurrentCustomerSubscription(),
        _remoteDataSource.getCustomerInvoices(),
        _remoteDataSource.getDefaultCustomerPaymentMethod(),
        _remoteDataSource.getCustomerSubscriptionFreezePolicy(),
      ).wait;

      return ProfileBillingEntity(
        current: current.toEntity(),
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
  Future<ApiResult<ProfileBillingFreezeResponseEntity>>
  createCustomerSubscriptionFreezeRequest({
    required String subscriptionId,
    required ProfileBillingFreezeRequestEntity request,
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
  Future<ApiResult<ProfileBillingCancellationQuoteEntity>>
  getCustomerSubscriptionCancellationQuote(String subscriptionId) {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .getCustomerSubscriptionCancellationQuote(subscriptionId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<ProfileBillingCancellationResultEntity>>
  createCustomerSubscriptionCancellationRequest({
    required String subscriptionId,
    required ProfileBillingCancellationRequestEntity request,
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
