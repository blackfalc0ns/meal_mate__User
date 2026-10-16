import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:injectable/injectable.dart';

enum CallKitActionType { accept, decline, ended, timeout, other }

class CallKitActionEvent {
  const CallKitActionEvent({
    required this.type,
    required this.callId,
    this.extra,
  });

  final CallKitActionType type;
  final String callId;
  final Map<String, dynamic>? extra;
}

@lazySingleton
class VoiceCallKitService {
  final _actionController = StreamController<CallKitActionEvent>.broadcast();
  Stream<CallKitActionEvent> get onAction => _actionController.stream;

  StreamSubscription? _callKitSubscription;
  final Set<String> _programmaticEndedCallIds = {};
  final Set<String> _connectedCallIds = {};
  bool _isEndingAllCalls = false;

  void initialize() {
    unawaited(_callKitSubscription?.cancel());
    _callKitSubscription = FlutterCallkitIncoming.onEvent.listen((event) {
      if (event == null) return;

      switch (event) {
        case CallEventActionCallAccept(:final callKitParams):
          debugPrint(
            '[CallKit] Native event: accept (callId: ${callKitParams.id})',
          );
          _actionController.add(
            CallKitActionEvent(
              type: CallKitActionType.accept,
              callId: callKitParams.id,
              extra: callKitParams.extra,
            ),
          );
        case CallEventActionCallDecline(:final callKitParams):
          final callId = callKitParams.id;
          if (_isEndingAllCalls ||
              _programmaticEndedCallIds.remove(callId) ||
              _connectedCallIds.contains(callId)) {
            debugPrint(
              '[CallKit] Suppressing native decline event for programmatic dismissal/connected call $callId',
            );
            return;
          }
          debugPrint(
            '[CallKit] Native event: decline (callId: $callId)',
          );
          _actionController.add(
            CallKitActionEvent(
              type: CallKitActionType.decline,
              callId: callId,
              extra: callKitParams.extra,
            ),
          );
        case CallEventActionCallEnded(:final callKitParams):
          final callId = callKitParams.id;
          if (_isEndingAllCalls ||
              _programmaticEndedCallIds.remove(callId) ||
              _connectedCallIds.contains(callId)) {
            debugPrint(
              '[CallKit] Suppressing native ended event for programmatic dismissal/connected call $callId',
            );
            return;
          }
          debugPrint('[CallKit] Native event: ended by user (callId: $callId)');
          _actionController.add(
            CallKitActionEvent(
              type: CallKitActionType.ended,
              callId: callId,
              extra: callKitParams.extra,
            ),
          );
        case CallEventActionCallTimeout(:final id):
          if (_isEndingAllCalls ||
              _programmaticEndedCallIds.contains(id) ||
              _connectedCallIds.contains(id)) {
            debugPrint('[CallKit] Suppressing native timeout for connected/dismissed call $id');
            return;
          }
          debugPrint('[CallKit] Native event: timeout (callId: $id)');
          _actionController.add(
            CallKitActionEvent(type: CallKitActionType.timeout, callId: id),
          );
        default:
          break;
      }
    });
  }

  Future<void> showIncomingCall({
    required String callId,
    required String callerName,
    required String callerRole,
    String? callerAvatar,
    String? tripStopId,
    int durationSeconds = 30,
  }) async {
    final effectiveDuration = durationSeconds > 0 ? durationSeconds : 30;
    debugPrint(
      '[CallKit] showIncomingCall: callId=$callId, durationSeconds=$effectiveDuration',
    );

    final isForeground =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

    if (defaultTargetPlatform == TargetPlatform.android && isForeground) {
      debugPrint(
        '[CallKit] App is in foreground on Android; playing native ringtone directly without notification banner',
      );
      await startForegroundRingtone();
      return;
    }

    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'MealMate',
      avatar: callerAvatar,
      handle: callerRole,
      type: 0, // Audio call
      duration: effectiveDuration * 1000,
      extra: <String, dynamic>{'callId': callId, 'tripStopId': ?tripStopId},
      headers: <String, dynamic>{},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#090909',
        actionColor: '#078847',
        textColor: '#ffffff',
        textAccept: 'Accept',
        textDecline: 'Decline',
      ),
      ios: const IOSParams(
        iconName: 'AppIcon',
        handleType: 'generic',
        supportsVideo: false,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'voiceChat',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: false,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
      ),
    );

    try {
      await FlutterCallkitIncoming.showCallkitIncoming(params);
    } catch (e) {
      debugPrint('[CallKit] Failed to show call notification: $e');
    }
  }

  static const MethodChannel _ringtoneChannel =
      MethodChannel('kw.mealmate/ringtone');

  Future<void> startForegroundRingtone() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _ringtoneChannel.invokeMethod('startRingtone');
    } catch (e) {
      debugPrint('[CallKit] Failed to start foreground ringtone: $e');
    }
  }

  Future<void> stopForegroundRingtone() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _ringtoneChannel.invokeMethod('stopRingtone');
    } catch (e) {
      debugPrint('[CallKit] Failed to stop foreground ringtone: $e');
    }
  }

  Future<void> endCall(String callId) async {
    await stopForegroundRingtone();
    _connectedCallIds.remove(callId);
    _programmaticEndedCallIds.add(callId);
    debugPrint('[CallKit] Programmatic endCall for $callId');
    try {
      await FlutterCallkitIncoming.endCall(callId);
    } catch (e) {
      debugPrint('[CallKit] Failed to end call: $e');
    }
  }

  Future<void> setCallConnected(String callId) async {
    await stopForegroundRingtone();
    if (_connectedCallIds.contains(callId)) return;
    _connectedCallIds.add(callId);
    try {
      await FlutterCallkitIncoming.setCallConnected(callId);
      if (defaultTargetPlatform == TargetPlatform.android) {
        // On Android, dismiss the incoming heads-up notification banner
        // so it does not float over the in-app active call screen.
        await hideIncomingCall(callId);
        await endCall(callId);
      }
    } catch (e) {
      debugPrint('[CallKit] Failed to mark call connected: $e');
    }
  }

  Future<void> hideIncomingCall(String callId) async {
    try {
      await FlutterCallkitIncoming.hideCallkitIncoming(
        CallKitParams(id: callId),
      );
    } catch (e) {
      debugPrint('[CallKit] Failed to hide incoming call: $e');
    }
  }

  Future<void> endAllCalls() async {
    await stopForegroundRingtone();
    _isEndingAllCalls = true;
    _connectedCallIds.clear();
    debugPrint('[CallKit] Programmatic endAllCalls');
    try {
      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      debugPrint('[CallKit] Failed to end all calls: $e');
    } finally {
      _isEndingAllCalls = false;
      _programmaticEndedCallIds.clear();
    }
  }

  void dispose() {
    unawaited(stopForegroundRingtone());
    _isEndingAllCalls = false;
    _connectedCallIds.clear();
    _programmaticEndedCallIds.clear();
    unawaited(_callKitSubscription?.cancel());
    unawaited(_actionController.close());
  }
}
