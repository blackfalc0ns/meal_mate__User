/// Exception thrown when location services or permissions fail.
class LocationServiceException implements Exception {
  const LocationServiceException(this.message, this.type);

  final String message;
  final LocationErrorType type;

  @override
  String toString() => message;
}

/// The type of location error encountered.
enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}
