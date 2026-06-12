import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_meat_user/core/utils/constants.dart';

@lazySingleton
class DeviceIdService {
  DeviceIdService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  Future<String> getOrCreateDeviceId() async {
    final cachedId = _sharedPreferences.getString(AppConstants.deviceIdKey);
    if (cachedId != null && cachedId.isNotEmpty) {
      return cachedId;
    }

    final generatedId = _generateDeviceId();
    await _sharedPreferences.setString(AppConstants.deviceIdKey, generatedId);
    return generatedId;
  }

  String _generateDeviceId() {
    final random = Random.secure();
    final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    final randomPart = List.generate(
      4,
      (_) => random.nextInt(0xFFFFFFFF).toRadixString(16).padLeft(8, '0'),
    ).join();

    return 'guest-$timestamp-$randomPart';
  }
}
