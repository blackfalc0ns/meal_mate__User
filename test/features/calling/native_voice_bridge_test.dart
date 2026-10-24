import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calling/data/data_source/native_voice_data_source.dart';
import 'package:meal_meat_user/features/calling/data/data_source/native_voice_data_source_impl.dart';
import 'package:meal_meat_user/features/calling/data/repo/native_voice_repository_impl.dart';
import 'package:meal_meat_user/features/calling/domain/entities/native_call_snapshot_entity.dart';
import 'package:meal_meat_user/features/calling/domain/repo/native_voice_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const methodChannelName = 'kw.mealmate.user/voice_calls/methods';
  const eventChannelName = 'kw.mealmate.user/voice_calls/events';

  final List<MethodCall> methodCalls = [];
  MockStreamHandlerEventSink? eventSink;

  setUp(() {
    methodCalls.clear();
    eventSink = null;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel(methodChannelName),
            (MethodCall call) async {
      methodCalls.add(call);
      switch (call.method) {
        case 'getSnapshot':
          return {
            'schemaVersion': 1,
            'engineInstanceId': 'eng-test',
            'revision': 1,
            'callId': null,
            'phase': 'idle',
            'microphonePermission': 'granted',
            'isMuted': false,
            'audioRouteId': 'earpiece',
            'availableAudioRoutes': ['earpiece', 'speaker'],
          };
        case 'answer':
          final args = call.arguments as Map?;
          if (args?['callId'] == 'call-stale') {
            throw PlatformException(
              code: 'stale_call',
              message: 'Call is stale or already ended',
            );
          }
          return {'status': 'accepted', 'requestId': args?['requestId']};
        case 'reject':
          return {'status': 'accepted', 'requestId': (call.arguments as Map?)?['requestId']};
        case 'end':
          return {'status': 'accepted', 'requestId': (call.arguments as Map?)?['requestId']};
        case 'setMuted':
          return {'status': 'accepted', 'muted': (call.arguments as Map?)?['muted']};
        case 'setAudioRoute':
          final route = (call.arguments as Map?)?['routeId'];
          if (route == 'unsupported_test') {
            throw PlatformException(
              code: 'unsupported_route',
              message: 'Audio route unsupported',
            );
          }
          return {'status': 'accepted', 'routeId': route};
        default:
          return null;
      }
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
      const EventChannel(eventChannelName),
      MockStreamHandler.inline(
        onListen: (args, sink) {
          eventSink = sink;
        },
        onCancel: (args) {
          eventSink = null;
        },
      ),
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel(methodChannelName), null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(const EventChannel(eventChannelName), null);
  });

  group('NativeVoiceDataSource and NativeVoiceRepository Integration', () {
    late NativeVoiceDataSource dataSource;
    late NativeVoiceRepository repository;

    setUp(() {
      dataSource = NativeVoiceDataSourceImpl();
      repository = NativeVoiceRepositoryImpl(dataSource);
    });

    test('getSnapshot returns valid NativeCallSnapshotEntity', () async {
      final result = await repository.getSnapshot();
      expect(result, isA<ApiSuccessResult<NativeCallSnapshotEntity>>());
      final data = (result as ApiSuccessResult<NativeCallSnapshotEntity>).data;
      expect(data.phase, NativeCallPhase.idle);
      expect(data.engineInstanceId, 'eng-test');
      expect(methodCalls.any((c) => c.method == 'getSnapshot'), isTrue);
    });

    test('answer call succeeds and propagates requestId and callId', () async {
      final result = await repository.answer(
        callId: 'call-101',
        lifecycleId: 'local-lc-1',
        requestId: 'req-answer-1',
      );
      expect(result, isA<ApiSuccessResult<void>>());
      final answerCall = methodCalls.firstWhere((c) => c.method == 'answer');
      expect(answerCall.arguments['callId'], 'call-101');
      expect(answerCall.arguments['requestId'], 'req-answer-1');
    });

    test('stale call error is mapped to failure', () async {
      final result = await repository.answer(
        callId: 'call-stale',
        lifecycleId: 'local-lc-1',
        requestId: 'req-answer-stale',
      );
      expect(result, isA<ApiErrorResult<void>>());
      final error = (result as ApiErrorResult<void>).failure;
      expect(error.code, 'stale_call');
    });

    test('snapshot stream drops out-of-order older revision from same engine', () async {
      final snapshots = <NativeCallSnapshotEntity>[];
      final sub = repository.snapshotStream.listen(snapshots.add);
      await pumpEventQueue();

      // Emit revision 2
      eventSink?.success({
        'schemaVersion': 1,
        'engineInstanceId': 'eng-test',
        'revision': 2,
        'callId': 'call-101',
        'phase': 'ringing',
      });
      await pumpEventQueue();

      // Emit out-of-order revision 1
      eventSink?.success({
        'schemaVersion': 1,
        'engineInstanceId': 'eng-test',
        'revision': 1,
        'callId': 'call-101',
        'phase': 'idle',
      });
      await pumpEventQueue();

      // Emit newer revision 3
      eventSink?.success({
        'schemaVersion': 1,
        'engineInstanceId': 'eng-test',
        'revision': 3,
        'callId': 'call-101',
        'phase': 'connected',
      });
      await pumpEventQueue();

      expect(snapshots.length, 2);
      expect(snapshots[0].revision, 2);
      expect(snapshots[0].phase, NativeCallPhase.ringing);
      expect(snapshots[1].revision, 3);
      expect(snapshots[1].phase, NativeCallPhase.connected);

      await sub.cancel();
    });

    test('new engine instance resets revision floor', () async {
      final snapshots = <NativeCallSnapshotEntity>[];
      final sub = repository.snapshotStream.listen(snapshots.add);
      await pumpEventQueue();

      eventSink?.success({
        'schemaVersion': 1,
        'engineInstanceId': 'eng-test-1',
        'revision': 20,
        'callId': 'call-101',
        'phase': 'ringing',
      });
      await pumpEventQueue();

      // Engine restarts with new instance ID and revision 1
      eventSink?.success({
        'schemaVersion': 1,
        'engineInstanceId': 'eng-test-2',
        'revision': 1,
        'callId': 'call-202',
        'phase': 'ringing',
      });
      await pumpEventQueue();

      expect(snapshots.length, 2);
      expect(snapshots[1].engineInstanceId, 'eng-test-2');
      expect(snapshots[1].revision, 1);

      await sub.cancel();
    });
  });
}
