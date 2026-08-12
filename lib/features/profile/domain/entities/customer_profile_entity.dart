class CustomerProfileEntity {
  const CustomerProfileEntity({
    required this.userId,
    required this.fullName,
    this.email,
    this.phoneNumber,
    required this.preferredLanguage,
    this.defaultRegionId,
    this.deliveryAddressLine,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.dateOfBirth,
    required this.onboardingCompleted,
    this.profileImageStorageKey,
    this.profileImageUrl,
    required this.accountStatus,
  });

  final String userId;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String preferredLanguage;
  final String? defaultRegionId;
  final String? deliveryAddressLine;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? dateOfBirth;
  final bool onboardingCompleted;
  final String? profileImageStorageKey;
  final String? profileImageUrl;
  final String accountStatus;

  String get displayContact => email ?? phoneNumber ?? '';
}
