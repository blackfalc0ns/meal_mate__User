class CustomerAddressEntity {
  const CustomerAddressEntity({
    required this.addressId,
    required this.label,
    required this.addressLine,
    this.regionId,
    this.governorate,
    this.area,
    this.block,
    this.blockRegionId,
    this.street,
    this.building,
    this.unit,
    this.floor,
    this.latitude,
    this.longitude,
    this.notes,
    required this.isDefault,
    this.isDeliveryActive = false,
    this.deliveryEffectiveFromUtc,
    this.deliveryChangeNotice,
    required this.notifyOnDelivery,
  });

  final String addressId;
  final String label;
  final String addressLine;
  final String? regionId;
  final String? governorate;
  final String? area;
  final String? block;
  final String? blockRegionId;
  final String? street;
  final String? building;
  final String? unit;
  final String? floor;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final bool isDefault;
  final bool isDeliveryActive;
  final DateTime? deliveryEffectiveFromUtc;
  final String? deliveryChangeNotice;
  final bool notifyOnDelivery;

  bool get canDelete => !isDeliveryActive;
}
