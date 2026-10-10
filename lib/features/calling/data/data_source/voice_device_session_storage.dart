import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/voice_device_session_entity.dart';

@lazySingleton
class VoiceDeviceSessionStorage {
  VoiceDeviceSessionStorage(
    this._secureStorage,
    this._sharedPreferences,
  );

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  static const String _sessionKey = 'voice_device_session_id';
  static const String _proofKey = 'voice_device_control_proof';
  static const String _expiryKey = 'voice_device_expires_at_utc';
  static const String _fcmTokenIdKey = 'voice_device_fcm_token_id';

  Future<void> saveSession(VoiceDeviceSessionEntity session) async {
    await _secureStorage.write(key: _sessionKey, value: session.deviceSessionId);
    await _secureStorage.write(key: _proofKey, value: session.controlProof);
    await _sharedPreferences.setString(
      _expiryKey,
      session.expiresAtUtc.toUtc().toIso8601String(),
    );
    if (session.fcmDeviceTokenId != null) {
      await _sharedPreferences.setString(
        _fcmTokenIdKey,
        session.fcmDeviceTokenId!,
      );
    }
  }

  Future<VoiceDeviceSessionEntity?> getSession() async {
    final sessionId = await _secureStorage.read(key: _sessionKey);
    final proof = await _secureStorage.read(key: _proofKey);
    final expiryIso = _sharedPreferences.getString(_expiryKey);
    final fcmTokenId = _sharedPreferences.getString(_fcmTokenIdKey);

    if (sessionId == null || sessionId.isEmpty || proof == null || proof.isEmpty || expiryIso == null) {
      return null;
    }

    final expiresAt = DateTime.tryParse(expiryIso)?.toUtc();
    if (expiresAt == null) {
      return null;
    }

    return VoiceDeviceSessionEntity(
      deviceSessionId: sessionId,
      controlProof: proof,
      expiresAtUtc: expiresAt,
      fcmDeviceTokenId: fcmTokenId,
    );
  }

  Future<void> saveFcmDeviceTokenId(String fcmDeviceTokenId) async {
    await _sharedPreferences.setString(_fcmTokenIdKey, fcmDeviceTokenId);
  }

  Future<String?> getFcmDeviceTokenId() async {
    return _sharedPreferences.getString(_fcmTokenIdKey);
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: _sessionKey);
    await _secureStorage.delete(key: _proofKey);
    await _sharedPreferences.remove(_expiryKey);
    await _sharedPreferences.remove(_fcmTokenIdKey);
  }
}
