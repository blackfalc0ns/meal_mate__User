import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class VoicePermissionService {
  @factoryMethod
  const VoicePermissionService.create() : _channelOverride = null;

  const VoicePermissionService({MethodChannel? channel})
      : _channelOverride = channel;

  final MethodChannel? _channelOverride;

  static const MethodChannel _voiceChannel =
      MethodChannel('kw.mealmate.user/voice_calls/methods');
  static const MethodChannel _legacyChannel =
      MethodChannel('kw.mealmate.user2/permissions');

  static const VoicePermissionService instance = VoicePermissionService();

  MethodChannel get _channel => _channelOverride ?? _voiceChannel;

  Future<bool> isMicrophoneGranted() async {
    try {
      final res = await _channel.invokeMethod<dynamic>('getMicrophonePermission');
      if (res != null) {
        return res.toString().toLowerCase().trim() == 'granted';
      }
    } catch (_) {
      try {
        final legacyRes =
            await _legacyChannel.invokeMethod<bool>('checkMicrophonePermission');
        return legacyRes ?? false;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  Future<bool> requestMicrophone() async {
    try {
      final res =
          await _channel.invokeMethod<dynamic>('requestMicrophonePermission');
      if (res != null) {
        return res.toString().toLowerCase().trim() == 'granted';
      }
    } catch (_) {
      try {
        final legacyRes =
            await _legacyChannel.invokeMethod<bool>('requestMicrophonePermission');
        return legacyRes ?? false;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  Future<void> openAppSettings() async {
    try {
      await _channel.invokeMethod<dynamic>('openAppSettings');
    } catch (_) {
      try {
        await _legacyChannel.invokeMethod<dynamic>('openAppSettings');
      } catch (_) {}
    }
  }

  static const String _explainerShownKey = 'voice_permission_explainer_shown';

  Future<bool> hasShownExplainer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_explainerShownKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> markExplainerShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_explainerShownKey, true);
    } catch (_) {}
  }
}
