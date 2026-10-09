import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/data/data_source/payment_remote_data_source.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/repo/payment_repository.dart';

@Injectable(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._remoteDataSource);

  final PaymentRemoteDataSource _remoteDataSource;

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

  @override
  Future<ApiResult<PaymentStatusEntity>> getSubscriptionPaymentStatus(
    String subscriptionId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSubscriptionPaymentStatus(
        subscriptionId,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<dynamic>> getSubscriptionCalendar(String subscriptionId) {
    return safeApiCall(() async {
      return await _remoteDataSource.getSubscriptionCalendar(subscriptionId);
    });
  }
}
