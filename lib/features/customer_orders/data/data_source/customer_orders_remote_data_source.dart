import 'package:meal_meat_user/features/customer_orders/data/models/response/delivered_boxes_response_dto.dart';

abstract interface class CustomerOrdersRemoteDataSource {
  Future<DeliveredBoxesResponseDto> getDeliveredBoxes({
    required int pageNumber,
    required int pageSize,
    String? fromDate,
    String? toDate,
    String? subscriptionId,
  });
}
