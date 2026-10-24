class DeliveredBoxDto {
  const DeliveredBoxDto({
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

  factory DeliveredBoxDto.fromJson(Map<String, dynamic> json) =>
      DeliveredBoxDto(
        subscriptionId: json['subscriptionId'] as String? ?? '',
        subscriptionDayId: json['subscriptionDayId'] as String? ?? '',
        serviceDate: json['serviceDate'] as String? ?? '',
        relatedResourceType: json['relatedResourceType'] as String? ?? '',
        relatedResourceId: json['relatedResourceId'] as String? ?? '',
        restaurantDailyOrderId: json['restaurantDailyOrderId'] as String?,
        restaurantId: json['restaurantId'] as String?,
        restaurantNameAr: json['restaurantNameAr'] as String?,
        restaurantNameEn: json['restaurantNameEn'] as String?,
        boxCount: json['boxCount'] as int?,
        orderCode: json['orderCode'] as String?,
        deliveredAtUtc: json['deliveredAtUtc'] as String?,
      );

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

class DeliveredBoxesResponseDto {
  const DeliveredBoxesResponseDto({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  factory DeliveredBoxesResponseDto.fromJson(Map<String, dynamic> json) =>
      DeliveredBoxesResponseDto(
        items: ((json['items'] as List<dynamic>?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(DeliveredBoxDto.fromJson)
            .toList(),
        totalCount: json['totalCount'] as int? ?? 0,
        pageNumber: json['pageNumber'] as int? ?? 1,
        pageSize: json['pageSize'] as int? ?? 20,
      );

  final List<DeliveredBoxDto> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
}
