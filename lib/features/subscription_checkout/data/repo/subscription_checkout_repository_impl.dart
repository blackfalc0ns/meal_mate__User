import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/data_source/subscription_checkout_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_checkout_mapper.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_checkout_repository.dart';

@Injectable(as: SubscriptionCheckoutRepository)
class SubscriptionCheckoutRepositoryImpl
    implements SubscriptionCheckoutRepository {
  SubscriptionCheckoutRepositoryImpl(this._remoteDataSource);
  final SubscriptionCheckoutRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<PaymentMethodEntity>>> getPaymentMethods({
    required double amount,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getPaymentMethods(
        amount: amount,
      );
      return response.map((method) => method.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<PaymentCheckoutEntity>> checkout(
    PaymentCheckoutRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.checkout(request.toDto());
      return response.toEntity();
    });
  }
}
