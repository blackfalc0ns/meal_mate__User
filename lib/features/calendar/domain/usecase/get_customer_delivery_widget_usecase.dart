import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';

@injectable
class GetCustomerDeliveryWidgetUseCase {
  GetCustomerDeliveryWidgetUseCase(this._repository);

  final CalendarRepository _repository;

  Future<ApiResult<CustomerDeliveryWidgetEntity>> call({
    String? serviceDate,
    String? subscriptionId,
  }) {
    return _repository.getDeliveryWidget(
      serviceDate: serviceDate,
      subscriptionId: subscriptionId,
    );
  }
}
