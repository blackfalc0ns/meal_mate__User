import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/customer_delivery_response_dto.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

extension CustomerDeliveryWidgetDtoMapper on CustomerDeliveryWidgetResponseDto {
  CustomerDeliveryWidgetEntity toEntity() {
    return CustomerDeliveryWidgetEntity(
      serviceDate: serviceDate,
      serverTimeUtc: serverTimeUtc,
      refreshAfterSeconds: refreshAfterSeconds,
      items: items?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension CustomerDeliveryDetailsDtoMapper on CustomerDeliveryDetailsResponseDto {
  CustomerDeliveryDetailsEntity toEntity() {
    return CustomerDeliveryDetailsEntity(
      serviceDate: serviceDate,
      serverTimeUtc: serverTimeUtc,
      refreshAfterSeconds: refreshAfterSeconds,
      delivery: delivery?.toEntity(),
    );
  }
}

extension CustomerDeliveryItemDtoMapper on CustomerDeliveryItemDto {
  CustomerDeliveryItemEntity toEntity() {
    return CustomerDeliveryItemEntity(
      subscriptionId: subscriptionId,
      subscriptionDayId: subscriptionDayId,
      orderId: orderId,
      tripStopId: tripStopId,
      orderCode: orderCode,
      deliveryStatus: CustomerDeliveryStatus.fromString(deliveryStatus),
      deliveryStatusRaw: deliveryStatus,
      deliveryStatusTextAr: deliveryStatusTextAr,
      deliveryStatusTextEn: deliveryStatusTextEn,
      deliveryStatusText: deliveryStatusText,
      isTerminal: isTerminal ?? false,
      isTrackable: isTrackable ?? false,
      unavailableReasonCode: unavailableReasonCode,
      readyAtUtc: readyAtUtc,
      pickedUpAtUtc: pickedUpAtUtc,
      arrivedAtUtc: arrivedAtUtc,
      deliveredAtUtc: deliveredAtUtc,
      driver: driver?.toEntity(),
      vehicle: vehicle?.toEntity(),
      location: location?.toEntity(),
      etaMinutes: etaMinutes,
      etaSource: etaSource,
      destinationAddress: destinationAddress?.addressLine,
      destinationLatitude: destinationAddress?.latitude,
      destinationLongitude: destinationAddress?.longitude,
      deliveryDetailsUrl: deliveryDetailsUrl,
      detailsUrl: detailsUrl,
    );
  }
}

extension CustomerDeliveryDriverDtoMapper on CustomerDeliveryDriverDto {
  CustomerDeliveryDriverEntity toEntity() {
    return CustomerDeliveryDriverEntity(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      name: name,
      maskedPhone: maskedPhone,
      avatarUrl: _resolveAvatarUrl(avatarUrl),
      rating: rating,
    );
  }

  static String? _resolveAvatarUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    if (raw.startsWith('/')) return '${NetworkConstants.baseUrl}$raw';
    return '${NetworkConstants.baseUrl}/$raw';
  }
}

extension CustomerDeliveryVehicleDtoMapper on CustomerDeliveryVehicleDto {
  CustomerDeliveryVehicleEntity toEntity() {
    return CustomerDeliveryVehicleEntity(
      typeCode: typeCode,
      typeLabelAr: typeLabelAr,
      typeLabelEn: typeLabelEn,
      typeLabel: typeLabel,
      plateNumber: plateNumber,
    );
  }
}

extension CustomerDeliveryLocationDtoMapper on CustomerDeliveryLocationDto {
  CustomerDeliveryLocationEntity toEntity() {
    return CustomerDeliveryLocationEntity(
      latitude: latitude,
      longitude: longitude,
      capturedAtUtc: capturedAtUtc,
      receivedAtUtc: receivedAtUtc,
      isLive: isLive ?? false,
    );
  }
}
