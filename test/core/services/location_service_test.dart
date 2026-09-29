import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/services/location_service.dart';

void main() {
  group('LocationService & Failures', () {
    test('LocationServiceDisabledFailure has correct code and message', () {
      final failure = LocationServiceDisabledFailure();
      expect(failure.code, 'location_service_disabled');
      expect(failure.errorMessage, 'location_service_disabled');
    });

    test('LocationPermissionDeniedFailure has correct code and message', () {
      final failure = LocationPermissionDeniedFailure();
      expect(failure.code, 'location_permission_denied');
      expect(failure.errorMessage, 'location_permission_denied');
    });

    test('LocationPermissionDeniedForeverFailure has correct code and message', () {
      final failure = LocationPermissionDeniedForeverFailure();
      expect(failure.code, 'location_permission_denied_forever');
      expect(failure.errorMessage, 'location_permission_denied_forever');
    });

    test('LocationService instance can be created as const', () {
      const service = LocationService();
      expect(service, isNotNull);
    });
  });
}
