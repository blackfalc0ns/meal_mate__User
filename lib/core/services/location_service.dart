import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';

@lazySingleton
class LocationService {
  const LocationService();

  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  /// Verifies location services and permissions, and fetches the device's current position.
  /// Returns [ApiSuccessResult<Position>] on success, or [ApiErrorResult<Position>] with
  /// corresponding [Failure] (e.g. [LocationServiceDisabledFailure], [LocationPermissionDeniedFailure], etc.).
  Future<ApiResult<Position>> getCurrentLocation() async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return ApiErrorResult(failure: LocationServiceDisabledFailure());
      }

      var permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          return ApiErrorResult(failure: LocationPermissionDeniedFailure());
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return ApiErrorResult(
          failure: LocationPermissionDeniedForeverFailure(),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return ApiSuccessResult(data: position);
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(errorMessage: e.toString(), code: 'location_error'),
      );
    }
  }
}
