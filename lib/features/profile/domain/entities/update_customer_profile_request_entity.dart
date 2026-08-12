class UpdateCustomerProfileRequestEntity {
  const UpdateCustomerProfileRequestEntity({
    required this.fullName,
    this.phoneNumber,
    required this.preferredLanguage,
    this.defaultRegionId,
    this.deliveryAddressLine,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.dateOfBirth,
  });

  final String fullName;
  final String? phoneNumber;
  final String preferredLanguage;
  final String? defaultRegionId;
  final String? deliveryAddressLine;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? dateOfBirth;
}
