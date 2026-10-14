import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/data/data_source/family_checkout_remote_data_source.dart';
import 'package:meal_meat_user/features/family_checkout/data/mapper/family_checkout_mapper.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_renewal_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_checkout/domain/repo/family_checkout_repository.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

import 'package:meal_meat_user/features/family_checkout/domain/entities/family_checkout_selection_entity.dart';

@Injectable(as: FamilyCheckoutRepository)
class FamilyCheckoutRepositoryImpl implements FamilyCheckoutRepository {
  FamilyCheckoutRepositoryImpl(this._remoteDataSource);

  final FamilyCheckoutRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<FamilyCheckoutSelectionEntity>> selectFamilyMemberForCheckout({
    required String memberId,
    required bool subscribeNow,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.selectFamilyMemberForCheckout(
        memberId: memberId,
        subscribeNow: subscribeNow,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> saveFamilyMemberStartDate({
    required String memberId,
    required String startDate,
  }) {
    return safeApiCall(() async {
      await _remoteDataSource.saveFamilyMemberStartDate(
        memberId: memberId,
        startDate: startDate,
      );
    });
  }

  @override
  Future<ApiResult<FamilySummaryEntity>> getFamilySummary({String? memberId}) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilySummary(
        memberId: memberId,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<List<PaymentMethodEntity>>> getFamilyPaymentMethods(
    double amount,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilyPaymentMethods(amount);
      return response.map((paymentMethod) => paymentMethod.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<PaymentCheckoutEntity>> checkoutFamilySubscription({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    required int paymentMethodId,
    String? batchId,
    int? batchVersion,
    String? idempotencyKey,
    int? clientContractVersion,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.checkoutFamilySubscription(
        FamilyCheckoutRequestDto(
          callbackUrl: callbackUrl,
          errorUrl: errorUrl,
          correlationId: correlationId,
          paymentMethodId: paymentMethodId,
          batchId: batchId,
          batchVersion: batchVersion,
          idempotencyKey: idempotencyKey,
          clientContractVersion: clientContractVersion ?? 1,
        ),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<PaymentCheckoutEntity>> retryFamilySubscriptionPayment({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    required int paymentMethodId,
    required String batchId,
    required int batchVersion,
    required String idempotencyKey,
    int clientContractVersion = 1,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.retryFamilySubscriptionPayment(
        FamilyCheckoutRequestDto(
          callbackUrl: callbackUrl,
          errorUrl: errorUrl,
          correlationId: correlationId,
          paymentMethodId: paymentMethodId,
          batchId: batchId,
          batchVersion: batchVersion,
          idempotencyKey: idempotencyKey,
          clientContractVersion: clientContractVersion,
        ),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<PaymentCheckoutEntity>> checkoutFamilyRenewal({
    required String renewalRequestId,
    required String startDate,
    required String addressId,
    required String callbackUrl,
    required String errorUrl,
    String? correlationId,
    int paymentMethodId = 3,
    String? idempotencyKey,
    int? clientContractVersion,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.checkoutFamilyRenewal(
        renewalRequestId: renewalRequestId,
        request: FamilyRenewalCheckoutRequestDto(
          startDate: startDate,
          addressId: addressId,
          callbackUrl: callbackUrl,
          errorUrl: errorUrl,
          correlationId: correlationId,
          paymentMethodId: paymentMethodId,
          idempotencyKey: idempotencyKey,
          clientContractVersion: clientContractVersion ?? 1,
        ),
      );
      return response.toEntity();
    });
  }
}
