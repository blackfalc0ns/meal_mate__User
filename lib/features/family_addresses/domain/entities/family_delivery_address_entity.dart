class FamilyDeliveryAddressSnapshotEntity {
  const FamilyDeliveryAddressSnapshotEntity({
    required this.subscriptionId,
    required this.currentVersion,
    this.acceptedAddress,
    this.eligibleAddresses = const [],
  });

  final String subscriptionId;
  final int currentVersion;
  final CustomerActiveDeliveryAddressEntity? acceptedAddress;
  final List<FamilyDeliveryAddressChoiceEntity> eligibleAddresses;
}

class FamilyDeliveryAddressChoiceEntity {
  const FamilyDeliveryAddressChoiceEntity({
    required this.id,
    this.label,
    required this.addressLine,
    this.regionId,
  });

  final String id;
  final String? label;
  final String addressLine;
  final String? regionId;
}

class CustomerActiveDeliveryAddressEntity {
  const CustomerActiveDeliveryAddressEntity({
    required this.id,
    this.label,
    required this.addressLine,
  });

  final String id;
  final String? label;
  final String addressLine;
}

class FamilyDeliveryAddressRequestEntity {
  const FamilyDeliveryAddressRequestEntity({
    required this.addressId,
    required this.effectiveFromDate,
    required this.expectedVersion,
  });

  final String addressId;
  final String effectiveFromDate;
  final int expectedVersion;
}

class FamilyDeliveryAddressResultEntity {
  const FamilyDeliveryAddressResultEntity({
    required this.subscriptionId,
    required this.version,
    required this.amendmentId,
    required this.effectiveFromDate,
    this.affectedDayIds = const [],
    this.skippedDayIds = const [],
  });

  final String subscriptionId;
  final int version;
  final String amendmentId;
  final String effectiveFromDate;
  final List<String> affectedDayIds;
  final List<String> skippedDayIds;

  /// Returns true if this delivery date or day has already been locked/protected and was skipped by server.
  bool isDaySkipped(String dayId) => skippedDayIds.contains(dayId);

  /// Returns true if this day's address was amended successfully by the server.
  bool isDayAffected(String dayId) => affectedDayIds.contains(dayId);
}
