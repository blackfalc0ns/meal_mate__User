import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/data/data_source/payment_remote_data_source.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/repo/payment_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_confirmation_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_confirmation_entity.dart';

@Injectable(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._remoteDataSource);

  final PaymentRemoteDataSource _remoteDataSource;

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

  @override
  Future<ApiResult<SubscriptionConfirmationEntity>> getSubscriptionConfirmation(
    String subscriptionId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSubscriptionConfirmation(
        subscriptionId,
      );
      return response.toEntity();
    });
  }
}
