import 'dart:io';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VoicePermissionService {
  const VoicePermissionService();

  static const MethodChannel _channel =
      MethodChannel('kw.mealmate.user2/permissions');

  static const VoicePermissionService instance = VoicePermissionService();

  Future<bool> isMicrophoneGranted() async {
    if (!Platform.isAndroid) return true;
    try {
      final res =
          await _channel.invokeMethod<bool>('checkMicrophonePermission');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> requestMicrophone() async {
    if (!Platform.isAndroid) return true;
    try {
      final res =
          await _channel.invokeMethod<bool>('requestMicrophonePermission');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> openAppSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<bool>('openAppSettings');
    } catch (_) {}
  }
}
