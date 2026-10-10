import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:injectable/injectable.dart';

enum CallKitActionType {
  accept,
  decline,
  ended,
  timeout,
  other,
}

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
  bool _isEndingAllCalls = false;

  void initialize() {
    unawaited(_callKitSubscription?.cancel());
    _callKitSubscription = FlutterCallkitIncoming.onEvent.listen((event) {
      if (event == null) return;

      switch (event) {
        case CallEventActionCallAccept(:final callKitParams):
          debugPrint('[CallKit] Native event: accept (callId: ${callKitParams.id})');
          _actionController.add(
            CallKitActionEvent(
              type: CallKitActionType.accept,
              callId: callKitParams.id,
              extra: callKitParams.extra,
            ),
          );
        case CallEventActionCallDecline(:final callKitParams):
          debugPrint('[CallKit] Native event: decline (callId: ${callKitParams.id})');
          _actionController.add(
            CallKitActionEvent(
              type: CallKitActionType.decline,
              callId: callKitParams.id,
              extra: callKitParams.extra,
            ),
          );
        case CallEventActionCallEnded(:final callKitParams):
          final callId = callKitParams.id;
          if (_isEndingAllCalls || _programmaticEndedCallIds.remove(callId)) {
            debugPrint('[CallKit] Suppressing duplicate native ended event from programmatic dismissal for $callId');
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
          debugPrint('[CallKit] Native event: timeout (callId: $id)');
          _actionController.add(
            CallKitActionEvent(
              type: CallKitActionType.timeout,
              callId: id,
            ),
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
    debugPrint('[CallKit] showIncomingCall: callId=$callId, durationSeconds=$effectiveDuration');

    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'MealMate',
      avatar: callerAvatar,
      handle: callerRole,
      type: 0, // Audio call
      duration: effectiveDuration * 1000,
      extra: <String, dynamic>{
        'callId': callId,
        'tripStopId': ?tripStopId,
      },
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

  Future<void> endCall(String callId) async {
    _programmaticEndedCallIds.add(callId);
    debugPrint('[CallKit] Programmatic endCall for $callId');
    try {
      await FlutterCallkitIncoming.endCall(callId);
    } catch (e) {
      debugPrint('[CallKit] Failed to end call: $e');
    }
  }

  Future<void> endAllCalls() async {
    _isEndingAllCalls = true;
    debugPrint('[CallKit] Programmatic endAllCalls');
    try {
      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      debugPrint('[CallKit] Failed to end all calls: $e');
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        _isEndingAllCalls = false;
        _programmaticEndedCallIds.clear();
      });
    }
  }

  void dispose() {
    unawaited(_callKitSubscription?.cancel());
    unawaited(_actionController.close());
  }
}
