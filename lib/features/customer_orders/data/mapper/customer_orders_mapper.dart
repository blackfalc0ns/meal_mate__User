import 'package:meal_meat_user/features/customer_orders/data/models/response/delivered_boxes_response_dto.dart';
import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';

extension DeliveredBoxesMapper on DeliveredBoxesResponseDto {
  DeliveredBoxesPageEntity toEntity() => DeliveredBoxesPageEntity(
    items: items
        .map(
          (box) => DeliveredBoxEntity(
            subscriptionId: box.subscriptionId,
            subscriptionDayId: box.subscriptionDayId,
            serviceDate: box.serviceDate,
            relatedResourceType: box.relatedResourceType,
            relatedResourceId: box.relatedResourceId,
            restaurantDailyOrderId: box.restaurantDailyOrderId,
            restaurantId: box.restaurantId,
            restaurantNameAr: box.restaurantNameAr,
            restaurantNameEn: box.restaurantNameEn,
            boxCount: box.boxCount,
            orderCode: box.orderCode,
            deliveredAtUtc: box.deliveredAtUtc,
          ),
        )
        .toList(),
    totalCount: totalCount,
    pageNumber: pageNumber,
    pageSize: pageSize,
  );
}
