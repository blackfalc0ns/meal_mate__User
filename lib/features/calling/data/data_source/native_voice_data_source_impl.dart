import 'dart:async';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../models/response/native_call_snapshot_dto.dart';
import 'native_voice_data_source.dart';

@LazySingleton(as: NativeVoiceDataSource)
class NativeVoiceDataSourceImpl implements NativeVoiceDataSource {
  static const MethodChannel _methodChannel =
      MethodChannel('kw.mealmate.user/voice_calls/methods');
  static const EventChannel _eventChannel =
      EventChannel('kw.mealmate.user/voice_calls/events');

  final MethodChannel methodChannel;
  final EventChannel eventChannel;

  @factoryMethod
  NativeVoiceDataSourceImpl.create()
      : methodChannel = _methodChannel,
        eventChannel = _eventChannel;

  NativeVoiceDataSourceImpl({
    MethodChannel? methodChannelOverride,
    EventChannel? eventChannelOverride,
  })  : methodChannel = methodChannelOverride ?? _methodChannel,
        eventChannel = eventChannelOverride ?? _eventChannel;

  Stream<NativeCallSnapshotDto>? _cachedStream;

  @override
  Future<NativeCallSnapshotDto> getSnapshot() async {
    final result = await methodChannel.invokeMethod<dynamic>('getSnapshot');
    if (result is Map) {
      return NativeCallSnapshotDto.fromJson(
        Map<String, dynamic>.from(result),
      );
    }
    return const NativeCallSnapshotDto(phase: 'idle');
  }

  @override
  Future<void> answer({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async {
    await methodChannel.invokeMethod<dynamic>('answer', {
      'callId': callId,
      'lifecycleId': lifecycleId,
      'requestId': requestId,
    });
  }

  @override
  Future<void> reject({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async {
    await methodChannel.invokeMethod<dynamic>('reject', {
      'callId': callId,
      'lifecycleId': lifecycleId,
      'requestId': requestId,
    });
  }

  @override
  Future<void> end({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async {
    await methodChannel.invokeMethod<dynamic>('end', {
      'callId': callId,
      'lifecycleId': lifecycleId,
      'requestId': requestId,
    });
  }

  @override
  Future<void> setMuted({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required bool muted,
  }) async {
    await methodChannel.invokeMethod<dynamic>('setMuted', {
      'callId': callId,
      'lifecycleId': lifecycleId,
      'requestId': requestId,
      'muted': muted,
    });
  }

  @override
  Future<void> setAudioRoute({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required String routeId,
  }) async {
    await methodChannel.invokeMethod<dynamic>('setAudioRoute', {
      'callId': callId,
      'lifecycleId': lifecycleId,
      'requestId': requestId,
      'routeId': routeId,
    });
  }

  @override
  Future<String> getMicrophonePermission() async {
    final result = await methodChannel.invokeMethod<dynamic>('getMicrophonePermission');
    return result?.toString() ?? 'notDetermined';
  }

  @override
  Future<String> requestMicrophonePermission() async {
    final result = await methodChannel.invokeMethod<dynamic>('requestMicrophonePermission');
    return result?.toString() ?? 'notDetermined';
  }

  @override
  Future<bool> openAppSettings() async {
    final result = await methodChannel.invokeMethod<dynamic>('openAppSettings');
    return result == true;
  }

  @override
  Future<void> setPresentationContext({
    required bool appVisible,
    String? localeTag,
    int? uiRevision,
  }) async {
    await methodChannel.invokeMethod<dynamic>('setPresentationContext', {
      'appVisible': appVisible,
      'localeTag': localeTag,
      'uiRevision': uiRevision,
    });
  }

  @override
  Stream<NativeCallSnapshotDto> get snapshotStream {
    _cachedStream ??= eventChannel
        .receiveBroadcastStream()
        .where((event) => event is Map)
        .map((event) => NativeCallSnapshotDto.fromJson(
              Map<String, dynamic>.from(event as Map),
            ))
        .asBroadcastStream();
    return _cachedStream!;
  }
}
