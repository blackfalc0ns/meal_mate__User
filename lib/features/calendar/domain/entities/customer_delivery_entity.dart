import 'package:flutter/foundation.dart';

enum CustomerDeliveryStatus {
  scheduled,
  preparing,
  ready,
  outForDelivery,
  arrived,
  delivered,
  failed,
  cancelled,
  unknown;

  static CustomerDeliveryStatus fromString(String? raw) {
    if (raw == null) return CustomerDeliveryStatus.unknown;
    final normalized = raw.trim().toLowerCase();
    return switch (normalized) {
      'scheduled' => CustomerDeliveryStatus.scheduled,
      'preparing' => CustomerDeliveryStatus.preparing,
      'ready' => CustomerDeliveryStatus.ready,
      'outfordelivery' || 'out_for_delivery' => CustomerDeliveryStatus.outForDelivery,
      'arrived' => CustomerDeliveryStatus.arrived,
      'delivered' => CustomerDeliveryStatus.delivered,
      'failed' => CustomerDeliveryStatus.failed,
      'cancelled' || 'canceled' => CustomerDeliveryStatus.cancelled,
      _ => CustomerDeliveryStatus.unknown,
    };
  }
}

@immutable
class CustomerDeliveryWidgetEntity {
  const CustomerDeliveryWidgetEntity({
    this.serviceDate,
    this.serverTimeUtc,
    this.refreshAfterSeconds,
    this.items = const [],
  });

  final String? serviceDate;
  final DateTime? serverTimeUtc;
  final int? refreshAfterSeconds;
  final List<CustomerDeliveryItemEntity> items;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}

@immutable
class CustomerDeliveryDetailsEntity {
  const CustomerDeliveryDetailsEntity({
    this.serviceDate,
    this.serverTimeUtc,
    this.refreshAfterSeconds,
    this.delivery,
  });

  final String? serviceDate;
  final DateTime? serverTimeUtc;
  final int? refreshAfterSeconds;
  final CustomerDeliveryItemEntity? delivery;

  bool get hasDelivery => delivery != null;
}

@immutable
class CustomerDeliveryItemEntity {
  const CustomerDeliveryItemEntity({
    this.subscriptionId,
    this.subscriptionDayId,
    this.orderId,
    this.tripStopId,
    this.orderCode,
    required this.deliveryStatus,
    this.deliveryStatusRaw,
    this.deliveryStatusTextAr,
    this.deliveryStatusTextEn,
    this.deliveryStatusText,
    required this.isTerminal,
    required this.isTrackable,
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

  final String? subscriptionId;
  final String? subscriptionDayId;
  final String? orderId;
  final String? tripStopId;
  final String? orderCode;
  final CustomerDeliveryStatus deliveryStatus;
  final String? deliveryStatusRaw;
  final String? deliveryStatusTextAr;
  final String? deliveryStatusTextEn;
  final String? deliveryStatusText;
  final bool isTerminal;
  final bool isTrackable;
  final String? unavailableReasonCode;
  final DateTime? readyAtUtc;
  final DateTime? pickedUpAtUtc;
  final DateTime? arrivedAtUtc;
  final DateTime? deliveredAtUtc;
  final CustomerDeliveryDriverEntity? driver;
  final CustomerDeliveryVehicleEntity? vehicle;
  final CustomerDeliveryLocationEntity? location;
  final int? etaMinutes;
  final String? etaSource;
  final String? destinationAddress;
  final String? deliveryDetailsUrl;
  final String? detailsUrl;

  bool get isOutForDelivery =>
      deliveryStatus == CustomerDeliveryStatus.outForDelivery;

  bool get isDelivered => deliveryStatus == CustomerDeliveryStatus.delivered;

  bool get isFailed => deliveryStatus == CustomerDeliveryStatus.failed;

  bool get isCancelled => deliveryStatus == CustomerDeliveryStatus.cancelled;

  bool get isTerminalStatus =>
      isTerminal || isDelivered || isFailed || isCancelled;

  bool get canTrack => isOutForDelivery && isTrackable && !isTerminalStatus;

  DateTime? get actualDeliveryTimeUtc => deliveredAtUtc;

  bool get hasReady => readyAtUtc != null;
  bool get hasPickedUp => pickedUpAtUtc != null;
  bool get hasArrived => arrivedAtUtc != null;
  bool get hasDelivered => deliveredAtUtc != null;

  String localizedStatus(String languageCode) {
    if (languageCode.startsWith('ar')) {
      if (deliveryStatusTextAr != null && deliveryStatusTextAr!.isNotEmpty) {
        return deliveryStatusTextAr!;
      }
    } else {
      if (deliveryStatusTextEn != null && deliveryStatusTextEn!.isNotEmpty) {
        return deliveryStatusTextEn!;
      }
    }
    if (deliveryStatusText != null && deliveryStatusText!.isNotEmpty) {
      return deliveryStatusText!;
    }
    return switch (deliveryStatus) {
      CustomerDeliveryStatus.scheduled =>
        languageCode.startsWith('ar') ? 'مجدول' : 'Scheduled',
      CustomerDeliveryStatus.preparing =>
        languageCode.startsWith('ar') ? 'قيد التحضير' : 'Preparing',
      CustomerDeliveryStatus.ready =>
        languageCode.startsWith('ar') ? 'جاهز للتوصيل' : 'Ready',
      CustomerDeliveryStatus.outForDelivery =>
        languageCode.startsWith('ar') ? 'خرج للتوصيل' : 'Out for Delivery',
      CustomerDeliveryStatus.arrived =>
        languageCode.startsWith('ar') ? 'وصل السائق' : 'Driver Arrived',
      CustomerDeliveryStatus.delivered =>
        languageCode.startsWith('ar') ? 'تم التوصيل' : 'Delivered',
      CustomerDeliveryStatus.failed =>
        languageCode.startsWith('ar') ? 'تعذر التوصيل' : 'Delivery Failed',
      CustomerDeliveryStatus.cancelled =>
        languageCode.startsWith('ar') ? 'ملغي' : 'Cancelled',
      CustomerDeliveryStatus.unknown =>
        languageCode.startsWith('ar') ? 'غير معروف' : 'Unknown',
    };
  }
}

@immutable
class CustomerDeliveryDriverEntity {
  const CustomerDeliveryDriverEntity({
    this.id,
    this.nameAr,
    this.nameEn,
    this.name,
    this.maskedPhone,
    this.avatarUrl,
    this.rating,
  });

  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? name;
  final String? maskedPhone;
  final String? avatarUrl;
  final double? rating;

  String displayName(String languageCode) {
    if (languageCode.startsWith('ar')) {
      if (nameAr != null && nameAr!.isNotEmpty) return nameAr!;
    } else {
      if (nameEn != null && nameEn!.isNotEmpty) return nameEn!;
    }
    if (name != null && name!.isNotEmpty) return name!;
    if (nameEn != null && nameEn!.isNotEmpty) return nameEn!;
    if (nameAr != null && nameAr!.isNotEmpty) return nameAr!;
    return '';
  }
}

@immutable
class CustomerDeliveryVehicleEntity {
  const CustomerDeliveryVehicleEntity({
    this.typeCode,
    this.typeLabelAr,
    this.typeLabelEn,
    this.typeLabel,
    this.plateNumber,
  });

  final String? typeCode;
  final String? typeLabelAr;
  final String? typeLabelEn;
  final String? typeLabel;
  final String? plateNumber;

  String displayLabel(String languageCode) {
    if (languageCode.startsWith('ar')) {
      if (typeLabelAr != null && typeLabelAr!.isNotEmpty) return typeLabelAr!;
    } else {
      if (typeLabelEn != null && typeLabelEn!.isNotEmpty) return typeLabelEn!;
    }
    if (typeLabel != null && typeLabel!.isNotEmpty) return typeLabel!;
    if (typeLabelEn != null && typeLabelEn!.isNotEmpty) return typeLabelEn!;
    if (typeLabelAr != null && typeLabelAr!.isNotEmpty) return typeLabelAr!;
    return '';
  }
}

@immutable
class CustomerDeliveryLocationEntity {
  const CustomerDeliveryLocationEntity({
    this.latitude,
    this.longitude,
    this.capturedAtUtc,
    this.receivedAtUtc,
    this.isLive = false,
  });

  final double? latitude;
  final double? longitude;
  final DateTime? capturedAtUtc;
  final DateTime? receivedAtUtc;
  final bool isLive;

  bool get hasValidCoordinates => latitude != null && longitude != null;
}
