import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';

abstract interface class CustomerOrdersRepository {
  Future<ApiResult<DeliveredBoxesPageEntity>> getDeliveredBoxes({
    required int pageNumber,
    required int pageSize,
    String? fromDate,
    String? toDate,
    String? subscriptionId,
  });
}
