import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/repo/payment_repository.dart';

@injectable
class GetSubscriptionPaymentStatusUseCase {
  GetSubscriptionPaymentStatusUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<PaymentStatusEntity>> call(String subscriptionId) {
    return _repository.getSubscriptionPaymentStatus(subscriptionId);
  }
}
