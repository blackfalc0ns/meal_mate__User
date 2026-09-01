import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/notifications/data/models/request/device_token_register_request_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/request/device_token_unregister_request_dto.dart';

void main() {
  group('Device token request DTOs', () {
    test('serializes register request using backend field names', () {
      const request = DeviceTokenRegisterRequestDto(
        token: 'fcm-token',
        platform: 1,
        deviceId: 'device-id',
      );

      expect(request.toJson(), {
        'token': 'fcm-token',
        'platform': 1,
        'deviceId': 'device-id',
      });
    });

    test('serializes unregister request using token only', () {
      const request = DeviceTokenUnregisterRequestDto(token: 'fcm-token');

      expect(request.toJson(), {'token': 'fcm-token'});
    });
  });
}
