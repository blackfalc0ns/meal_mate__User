class VoiceCallDisplayEntity {
  const VoiceCallDisplayEntity({
    required this.callId,
    this.tripStopId,
    this.driverName,
    this.driverImageUrl,
    this.driverRole,
    this.vehicleType,
    this.plateNumber,
    this.deliveryAddress,
    this.deliveryZone,
    this.orderCode,
    this.mealSummary,
    this.slotLabel,
    this.boxCount,
    this.stopStatus,
  });

  final String callId;
  final String? tripStopId;
  final String? driverName;
  final String? driverImageUrl;
  final String? driverRole;
  final String? vehicleType;
  final String? plateNumber;
  final String? deliveryAddress;
  final String? deliveryZone;
  final String? orderCode;
  final String? mealSummary;
  final String? slotLabel;
  final int? boxCount;
  final String? stopStatus;

  String? resolveDriverImageUrl(String baseUrl) {
    if (driverImageUrl == null || driverImageUrl!.trim().isEmpty) {
      return null;
    }
    final trimmed = driverImageUrl!.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    try {
      final baseUri = Uri.parse(baseUrl);
      return baseUri.resolve(trimmed).toString();
    } catch (_) {
      return null;
    }
  }

  String get resolvedAddress {
    if (deliveryAddress != null && deliveryAddress!.trim().isNotEmpty) {
      return deliveryAddress!.trim();
    }
    if (deliveryZone != null && deliveryZone!.trim().isNotEmpty) {
      return deliveryZone!.trim();
    }
    return '';
  }

  String get resolvedDriverName {
    if (driverName != null && driverName!.trim().isNotEmpty) {
      return driverName!.trim();
    }
    return '';
  }

  String resolveStopStatus(String languageCode) {
    if (stopStatus == null || stopStatus!.trim().isEmpty) return '';
    final code = stopStatus!.trim().toLowerCase();
    final isAr = languageCode.startsWith('ar');
    switch (code) {
      case 'pickedup':
      case 'picked_up':
        return isAr ? 'تم استلام الطلب' : 'Order Picked Up';
      case 'arrived':
        return isAr ? 'وصل المندوب' : 'Driver Arrived';
      case 'delivering':
      case 'in_transit':
        return isAr ? 'في الطريق' : 'On the Way';
      case 'completed':
        return isAr ? 'مكتمل' : 'Completed';
      default:
        return stopStatus!;
    }
  }
}
