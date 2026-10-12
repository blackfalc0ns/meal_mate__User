import 'dart:convert';
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

  static const String _terminalCallIdsKey = 'voice_terminal_call_ids';
  static const String _lastSequencesKey = 'voice_last_sequences';
  static const String _processedEventIdsKey = 'voice_processed_event_ids';
  static const String _processedMessageIdsKey = 'voice_processed_message_ids';

  Future<void> saveTerminalCallId(String callId) async {
    final list = _sharedPreferences.getStringList(_terminalCallIdsKey) ?? [];
    if (!list.contains(callId)) {
      list.add(callId);
      if (list.length > 100) list.removeAt(0);
      await _sharedPreferences.setStringList(_terminalCallIdsKey, list);
    }
  }

  Set<String> getTerminalCallIds() {
    return (_sharedPreferences.getStringList(_terminalCallIdsKey) ?? []).toSet();
  }

  Future<void> saveLastSequence(String callId, int sequence) async {
    final raw = _sharedPreferences.getString(_lastSequencesKey);
    Map<String, dynamic> map = {};
    if (raw != null) {
      try {
        map = Map<String, dynamic>.from(const JsonDecoder().convert(raw) as Map);
      } catch (_) {}
    }
    map[callId] = sequence;
    if (map.length > 100) {
      map.remove(map.keys.first);
    }
    await _sharedPreferences.setString(
      _lastSequencesKey,
      const JsonEncoder().convert(map),
    );
  }

  Map<String, int> getLastSequences() {
    final raw = _sharedPreferences.getString(_lastSequencesKey);
    if (raw == null) return {};
    try {
      final decoded = const JsonDecoder().convert(raw) as Map;
      return decoded.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveProcessedEventId(String eventId) async {
    final list = _sharedPreferences.getStringList(_processedEventIdsKey) ?? [];
    if (!list.contains(eventId)) {
      list.add(eventId);
      if (list.length > 200) list.removeAt(0);
      await _sharedPreferences.setStringList(_processedEventIdsKey, list);
    }
  }

  Set<String> getProcessedEventIds() {
    return (_sharedPreferences.getStringList(_processedEventIdsKey) ?? []).toSet();
  }

  Future<void> saveProcessedMessageId(String messageId) async {
    final list = _sharedPreferences.getStringList(_processedMessageIdsKey) ?? [];
    if (!list.contains(messageId)) {
      list.add(messageId);
      if (list.length > 200) list.removeAt(0);
      await _sharedPreferences.setStringList(_processedMessageIdsKey, list);
    }
  }

  Set<String> getProcessedMessageIds() {
    return (_sharedPreferences.getStringList(_processedMessageIdsKey) ?? []).toSet();
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: _sessionKey);
    await _secureStorage.delete(key: _proofKey);
    await _sharedPreferences.remove(_expiryKey);
    await _sharedPreferences.remove(_fcmTokenIdKey);
  }

  Future<void> clearOnLogout() async {
    await clearSession();
    await _sharedPreferences.remove(_terminalCallIdsKey);
    await _sharedPreferences.remove(_lastSequencesKey);
    await _sharedPreferences.remove(_processedEventIdsKey);
    await _sharedPreferences.remove(_processedMessageIdsKey);
  }
}

