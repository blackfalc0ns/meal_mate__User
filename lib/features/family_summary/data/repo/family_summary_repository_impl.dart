import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_checkout_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_summary/data/data_source/family_summary_remote_data_source.dart';
import 'package:meal_meat_user/features/family_summary/data/mapper/family_summary_mapper.dart';
import 'package:meal_meat_user/features/family_summary/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_summary/data/models/request/family_renewal_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_contract_constants.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_summary/domain/repo/family_summary_repository.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_selection_entity.dart';

@Injectable(as: FamilySummaryRepository)
class FamilySummaryRepositoryImpl implements FamilySummaryRepository {
  FamilySummaryRepositoryImpl(this._remoteDataSource);

  final FamilySummaryRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<FamilySummarySelectionEntity>>
  selectFamilyMemberForCheckout({
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
  Future<ApiResult<FamilySummaryEntity>> getFamilySummary({
    String? memberId,
    String? promoCode,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilySummary(
        memberId: memberId,
        promoCode: promoCode,
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
    int? paymentMethodId,
    String? batchId,
    int? batchVersion,
    String? idempotencyKey,
    int? clientContractVersion,
    String? promoCode,
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
          clientContractVersion:
              clientContractVersion ??
              FamilyCheckoutContractConstants.clientContractVersion,
          promoCode: promoCode,
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
    int? paymentMethodId,
    String? batchId,
    int? batchVersion,
    String? idempotencyKey,
    int clientContractVersion =
        FamilyCheckoutContractConstants.clientContractVersion,
    String? promoCode,
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
          promoCode: promoCode,
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
    int paymentMethodId =
        FamilyCheckoutContractConstants.defaultRenewalPaymentMethodId,
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
          clientContractVersion:
              clientContractVersion ??
              FamilySummaryContractConstants.clientContractVersion,
        ),
      );
      return response.toEntity();
    });
  }
}

typedef FamilyCheckoutRepositoryImpl = FamilySummaryRepositoryImpl;
