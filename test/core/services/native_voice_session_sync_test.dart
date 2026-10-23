import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/services/native_voice_session_bridge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sessionChannelName = 'kw.mealmate.user/voice_session/methods';
  final List<MethodCall> calls = [];
  int currentRevision = 10;
  Map<String, dynamic> storedSession = {
    'sessionRevision': 10,
    'accountId': 'user-100',
    'voiceDeviceSessionId': 'session-v2-123',
    'controlProof': 'proof-xyz',
    'accessToken': 'token-old',
  };

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel(sessionChannelName),
            (MethodCall call) async {
      calls.add(call);
      final args = call.arguments as Map?;
      final expectedRevision = args?['expectedRevision'] as int?;

      switch (call.method) {
        case 'getSessionMetadata':
          return {
            'sessionRevision': currentRevision,
            'hasSession': storedSession['accountId'] != null,
            'accountId': storedSession['accountId'],
          };

        case 'installSession':
          if (expectedRevision != null && expectedRevision != currentRevision) {
            throw PlatformException(
              code: 'conflict_revision',
              message: 'Expected revision $expectedRevision != current $currentRevision',
            );
          }
          currentRevision++;
          storedSession = {
            'sessionRevision': currentRevision,
            'accountId': args?['accountId'],
            'voiceDeviceSessionId': args?['voiceDeviceSessionId'],
            'controlProof': args?['controlProof'],
            'accessToken': args?['accessToken'],
          };
          return {'status': 'installed', 'sessionRevision': currentRevision};

        case 'readAccessToken':
          return storedSession['accessToken'];

        case 'refreshSession':
          if (expectedRevision != null && expectedRevision != currentRevision) {
            throw PlatformException(
              code: 'conflict_revision',
              message: 'Concurrent modification',
            );
          }
          currentRevision++;
          storedSession['sessionRevision'] = currentRevision;
          storedSession['accessToken'] = 'token-refreshed';
          return {
            'status': 'refreshed',
            'sessionRevision': currentRevision,
            'accessToken': 'token-refreshed',
          };

        case 'clearSession':
          currentRevision++;
          storedSession = {'sessionRevision': currentRevision};
          return {'status': 'cleared', 'sessionRevision': currentRevision};

        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel(sessionChannelName), null);
  });

  group('NativeVoiceSessionBridge Tests', () {
    late NativeVoiceSessionBridge bridge;

    setUp(() {
      bridge = NativeVoiceSessionBridge();
    });

    test('getSessionMetadata reads correct metadata from platform store', () async {
      final meta = await bridge.getSessionMetadata();
      expect(meta.sessionRevision, 10);
      expect(meta.hasSession, isTrue);
      expect(meta.accountId, 'user-100');
    });

    test('installSession updates credentials atomically with CAS revision check', () async {
      final result = await bridge.installSession(
        expectedRevision: 10,
        accountId: 'user-100',
        voiceDeviceSessionId: 'session-v2-new',
        controlProof: 'proof-new',
        accessToken: 'token-new',
      );
      expect(result.isSuccess, isTrue);
      expect(result.newRevision, 11);

      final meta = await bridge.getSessionMetadata();
      expect(meta.sessionRevision, 11);
    });

    test('installSession fails when expectedRevision conflicts', () async {
      final result = await bridge.installSession(
        expectedRevision: 999, // wrong revision
        accountId: 'user-100',
        voiceDeviceSessionId: 'session-v2-new',
        controlProof: 'proof-new',
        accessToken: 'token-new',
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorCode, 'conflict_revision');
    });

    test('clearSession clears store and increments revision', () async {
      final result = await bridge.clearSession(expectedRevision: 10, reason: 'logout');
      expect(result.isSuccess, isTrue);

      final meta = await bridge.getSessionMetadata();
      expect(meta.hasSession, isFalse);
    });
  });
}
