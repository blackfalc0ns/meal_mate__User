import 'package:json_annotation/json_annotation.dart';

part 'customer_delivery_response_dto.g.dart';

@JsonSerializable()
class CustomerDeliveryWidgetResponseDto {
  const CustomerDeliveryWidgetResponseDto({
    this.serviceDate,
    this.serverTimeUtc,
    this.refreshAfterSeconds,
    this.items,
  });

  factory CustomerDeliveryWidgetResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CustomerDeliveryWidgetResponseDtoFromJson(json);

  final String? serviceDate;
  final DateTime? serverTimeUtc;
  final int? refreshAfterSeconds;
  final List<CustomerDeliveryItemDto>? items;

  Map<String, dynamic> toJson() =>
      _$CustomerDeliveryWidgetResponseDtoToJson(this);
}

@JsonSerializable()
class CustomerDeliveryDetailsResponseDto {
  const CustomerDeliveryDetailsResponseDto({
    this.serviceDate,
    this.serverTimeUtc,
    this.refreshAfterSeconds,
    this.delivery,
  });

  factory CustomerDeliveryDetailsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CustomerDeliveryDetailsResponseDtoFromJson(json);

  final String? serviceDate;
  final DateTime? serverTimeUtc;
  final int? refreshAfterSeconds;
  final CustomerDeliveryItemDto? delivery;

  Map<String, dynamic> toJson() =>
      _$CustomerDeliveryDetailsResponseDtoToJson(this);
}

@JsonSerializable()
class CustomerDeliveryItemDto {
  const CustomerDeliveryItemDto({
    this.subscriptionId,
    this.subscriptionDayId,
    this.orderId,
    this.tripStopId,
    this.orderCode,
    this.deliveryStatus,
    this.deliveryStatusTextAr,
    this.deliveryStatusTextEn,
    this.deliveryStatusText,
    this.isTerminal,
    this.isTrackable,
    this.unavailableReasonCode,
    this.readyAtUtc,
    this.pickedUpAtUtc,
    this.arrivedAtUtc,
    this.deliveredAtUtc,
    this.driver,
    this.vehicle,
    this.location,
    this.etaMinutes,
    this.etaSource,
    this.destinationAddress,
    this.deliveryDetailsUrl,
    this.detailsUrl,
  });

  factory CustomerDeliveryItemDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDeliveryItemDtoFromJson(json);

  final String? subscriptionId;
  final String? subscriptionDayId;
  final String? orderId;
  final String? tripStopId;
  final String? orderCode;
  final String? deliveryStatus;
  final String? deliveryStatusTextAr;
  final String? deliveryStatusTextEn;
  final String? deliveryStatusText;
  final bool? isTerminal;
  final bool? isTrackable;
  final String? unavailableReasonCode;
  final DateTime? readyAtUtc;
  final DateTime? pickedUpAtUtc;
  final DateTime? arrivedAtUtc;
  final DateTime? deliveredAtUtc;
  final CustomerDeliveryDriverDto? driver;
  final CustomerDeliveryVehicleDto? vehicle;
  final CustomerDeliveryLocationDto? location;
  final int? etaMinutes;
  final String? etaSource;
  final String? destinationAddress;
  final String? deliveryDetailsUrl;
  final String? detailsUrl;

  Map<String, dynamic> toJson() => _$CustomerDeliveryItemDtoToJson(this);
}

@JsonSerializable()
class CustomerDeliveryDriverDto {
  const CustomerDeliveryDriverDto({
    this.id,
    this.nameAr,
    this.nameEn,
    this.name,
    this.maskedPhone,
    this.avatarUrl,
    this.rating,
  });

  factory CustomerDeliveryDriverDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDeliveryDriverDtoFromJson(json);

  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? name;
  final String? maskedPhone;
  final String? avatarUrl;
  final double? rating;

  Map<String, dynamic> toJson() => _$CustomerDeliveryDriverDtoToJson(this);
}

@JsonSerializable()
class CustomerDeliveryVehicleDto {
  const CustomerDeliveryVehicleDto({
    this.typeCode,
    this.typeLabelAr,
    this.typeLabelEn,
    this.typeLabel,
    this.plateNumber,
  });

  factory CustomerDeliveryVehicleDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDeliveryVehicleDtoFromJson(json);

  final String? typeCode;
  final String? typeLabelAr;
  final String? typeLabelEn;
  final String? typeLabel;
  final String? plateNumber;

  Map<String, dynamic> toJson() => _$CustomerDeliveryVehicleDtoToJson(this);
}

@JsonSerializable()
class CustomerDeliveryLocationDto {
  const CustomerDeliveryLocationDto({
    this.latitude,
    this.longitude,
    this.capturedAtUtc,
    this.receivedAtUtc,
    this.isLive,
  });

  factory CustomerDeliveryLocationDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDeliveryLocationDtoFromJson(json);

  final double? latitude;
  final double? longitude;
  final DateTime? capturedAtUtc;
  final DateTime? receivedAtUtc;
  final bool? isLive;

  Map<String, dynamic> toJson() => _$CustomerDeliveryLocationDtoToJson(this);
}
