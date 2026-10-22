import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_checkout_repository.dart';

@injectable
class GetPaymentMethodsUseCase {
  GetPaymentMethodsUseCase(this._repository);

  final SubscriptionCheckoutRepository _repository;

  Future<ApiResult<List<PaymentMethodEntity>>> call({required double amount}) {
    return _repository.getPaymentMethods(amount: amount);
  }
}
