import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

class NativeSessionMetadata {
  final int sessionRevision;
  final bool hasSession;
  final String? accountId;
  final String? apnsVoipToken;

  const NativeSessionMetadata({
    required this.sessionRevision,
    required this.hasSession,
    this.accountId,
    this.apnsVoipToken,
  });

  factory NativeSessionMetadata.fromMap(Map<String, dynamic> map) {
    return NativeSessionMetadata(
      sessionRevision: (map['sessionRevision'] as num?)?.toInt() ?? 0,
      hasSession: map['hasSession'] as bool? ?? false,
      accountId: map['accountId']?.toString(),
      apnsVoipToken: map['apnsVoipToken']?.toString(),
    );
  }
}

class NativeSessionResult {
  final bool isSuccess;
  final int? newRevision;
  final String? errorCode;
  final String? errorMessage;
  final String? accessToken;

  const NativeSessionResult({
    required this.isSuccess,
    this.newRevision,
    this.errorCode,
    this.errorMessage,
    this.accessToken,
  });

  factory NativeSessionResult.success({int? newRevision, String? accessToken}) {
    return NativeSessionResult(
      isSuccess: true,
      newRevision: newRevision,
      accessToken: accessToken,
    );
  }

  factory NativeSessionResult.failure({required String code, String? message}) {
    return NativeSessionResult(
      isSuccess: false,
      errorCode: code,
      errorMessage: message,
    );
  }
}

@lazySingleton
class NativeVoiceSessionBridge {
  static const MethodChannel _channel = MethodChannel(
    'kw.mealmate.user/voice_session/methods',
  );

  final MethodChannel channel;
  final MethodChannel voiceChannel;

  @factoryMethod
  NativeVoiceSessionBridge.create()
    : channel = _channel,
      voiceChannel = const MethodChannel(
        'kw.mealmate.user/voice_calls/methods',
      );

  NativeVoiceSessionBridge({
    MethodChannel? channelOverride,
    MethodChannel? voiceChannelOverride,
  }) : channel = channelOverride ?? _channel,
       voiceChannel =
           voiceChannelOverride ??
           const MethodChannel('kw.mealmate.user/voice_calls/methods');

  Future<void> handlePush(Map<String, dynamic> data) =>
      voiceChannel.invokeMethod<void>('handlePush', {'data': data});

  Future<void> resume() => voiceChannel.invokeMethod<void>('resume');

  void setVoipTokenChangedHandler(Future<void> Function()? handler) {
    channel.setMethodCallHandler(
      handler == null
          ? null
          : (call) async {
              if (call.method == 'voipTokenChanged') await handler();
            },
    );
  }

  Future<Map<String, dynamic>?> readSessionTokens(int revision) async {
    try {
      final value = await channel.invokeMapMethod<String, dynamic>(
        'readSessionTokens',
        {'expectedRevision': revision},
      );
      return value;
    } on MissingPluginException {
      return null;
    }
  }

  Future<NativeSessionMetadata> getSessionMetadata() async {
    try {
      final res = await channel.invokeMethod<dynamic>('getSessionMetadata');
      if (res is Map) {
        return NativeSessionMetadata.fromMap(Map<String, dynamic>.from(res));
      }
    } catch (_) {}
    return const NativeSessionMetadata(sessionRevision: 0, hasSession: false);
  }

  Future<NativeSessionResult> installSession({
    required int expectedRevision,
    required String accountId,
    required String voiceDeviceSessionId,
    required String controlProof,
    String? accessToken,
    String? refreshToken,
    String? expiresAtUtc,
  }) async {
    try {
      final res = await channel.invokeMethod<dynamic>('installSession', {
        'expectedRevision': expectedRevision,
        'accountId': accountId,
        'voiceDeviceSessionId': voiceDeviceSessionId,
        'controlProof': controlProof,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresAtUtc': expiresAtUtc,
      });
      final map = res is Map ? Map<String, dynamic>.from(res) : null;
      return NativeSessionResult.success(
        newRevision: (map?['sessionRevision'] as num?)?.toInt(),
      );
    } on PlatformException catch (e) {
      return NativeSessionResult.failure(code: e.code, message: e.message);
    } catch (e) {
      return NativeSessionResult.failure(
        code: 'install_error',
        message: e.toString(),
      );
    }
  }

  Future<String?> readAccessToken(int expectedRevision) async {
    try {
      final res = await channel.invokeMethod<dynamic>('readAccessToken', {
        'expectedRevision': expectedRevision,
      });
      return res?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<NativeSessionResult> refreshSession(int expectedRevision) async {
    try {
      final res = await channel.invokeMethod<dynamic>('refreshSession', {
        'expectedRevision': expectedRevision,
      });
      final map = res is Map ? Map<String, dynamic>.from(res) : null;
      return NativeSessionResult.success(
        newRevision: (map?['sessionRevision'] as num?)?.toInt(),
        accessToken: map?['accessToken']?.toString(),
      );
    } on PlatformException catch (e) {
      return NativeSessionResult.failure(code: e.code, message: e.message);
    } catch (e) {
      return NativeSessionResult.failure(
        code: 'refresh_error',
        message: e.toString(),
      );
    }
  }

  Future<NativeSessionResult> clearSession({
    required int expectedRevision,
    required String reason,
  }) async {
    try {
      final res = await channel.invokeMethod<dynamic>('clearSession', {
        'expectedRevision': expectedRevision,
        'reason': reason,
      });
      final map = res is Map ? Map<String, dynamic>.from(res) : null;
      return NativeSessionResult.success(
        newRevision: (map?['sessionRevision'] as num?)?.toInt(),
      );
    } on PlatformException catch (e) {
      return NativeSessionResult.failure(code: e.code, message: e.message);
    } catch (e) {
      return NativeSessionResult.failure(
        code: 'clear_error',
        message: e.toString(),
      );
    }
  }
}
