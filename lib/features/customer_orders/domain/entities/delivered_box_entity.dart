class DeliveredBoxEntity {
  const DeliveredBoxEntity({
    required this.subscriptionId,
    required this.subscriptionDayId,
    required this.serviceDate,
    required this.relatedResourceType,
    required this.relatedResourceId,
    this.restaurantDailyOrderId,
    this.restaurantId,
    this.restaurantNameAr,
    this.restaurantNameEn,
    this.boxCount,
    this.orderCode,
    this.deliveredAtUtc,
  });

  final String subscriptionId;
  final String subscriptionDayId;
  final String serviceDate;
  final String relatedResourceType;
  final String relatedResourceId;
  final String? restaurantDailyOrderId;
  final String? restaurantId;
  final String? restaurantNameAr;
  final String? restaurantNameEn;
  final int? boxCount;
  final String? orderCode;
  final String? deliveredAtUtc;
}

class DeliveredBoxesPageEntity {
  const DeliveredBoxesPageEntity({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  final List<DeliveredBoxEntity> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
}
