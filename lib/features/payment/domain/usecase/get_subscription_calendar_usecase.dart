import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/domain/repo/payment_repository.dart';

@injectable
class GetSubscriptionCalendarUseCase {
  GetSubscriptionCalendarUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<dynamic>> call(String subscriptionId) {
    return _repository.getSubscriptionCalendar(subscriptionId);
  }
}
