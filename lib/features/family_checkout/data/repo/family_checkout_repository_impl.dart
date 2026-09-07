import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/data/data_source/family_checkout_remote_data_source.dart';
import 'package:meal_meat_user/features/family_checkout/data/mapper/family_checkout_mapper.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_checkout/domain/repo/family_checkout_repository.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

@Injectable(as: FamilyCheckoutRepository)
class FamilyCheckoutRepositoryImpl implements FamilyCheckoutRepository {
  FamilyCheckoutRepositoryImpl(this._remoteDataSource);

  final FamilyCheckoutRemoteDataSource _remoteDataSource;

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
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.checkoutFamilySubscription(
        FamilyCheckoutRequestDto(
          callbackUrl: callbackUrl,
          errorUrl: errorUrl,
          correlationId: correlationId,
          paymentMethodId: paymentMethodId,
        ),
      );
      return response.toEntity();
    });
  }
}
