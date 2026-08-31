class MapAddressAutofillEntity {
  const MapAddressAutofillEntity({
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    this.governorate,
    this.area,
    this.block,
    this.street,
    this.avenue,
    this.building,
    this.suggestedRegionId,
    this.suggestedRegionNameAr,
    this.suggestedGovernorateId,
    this.suggestedGovernorateNameAr,
    this.suggestedBlockId,
    this.suggestedBlockNameAr,
    this.suggestedRegionName,
    this.suggestedGovernorateName,
    this.suggestedBlockName,
  });

  final String formattedAddress;
  final double latitude;
  final double longitude;
  final String? governorate;
  final String? area;
  final String? block;
  final String? street;
  final String? avenue;
  final String? building;
  final String? suggestedRegionId;
  final String? suggestedRegionNameAr;
  final String? suggestedGovernorateId;
  final String? suggestedGovernorateNameAr;
  final String? suggestedBlockId;
  final String? suggestedBlockNameAr;
  final String? suggestedRegionName;
  final String? suggestedGovernorateName;
  final String? suggestedBlockName;
}
