import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/calling/service/voice_call_signalr_service.dart';
import 'package:signalr_netcore/signalr_client.dart';

class FakeTokenService extends Fake implements TokenService {
  @override
  Future<String?> getToken() async => 'fake-jwt-token';
}

class TestHubConnection extends Fake implements HubConnection {
  final Map<String, void Function(List<Object?>?)> handlers = {};
  final List<Map<String, dynamic>> invokedMethods = [];
  void Function({String? connectionId})? reconnectedHandler;
  void Function({Exception? error})? closeHandler;

  HubConnectionState _state = HubConnectionState.Disconnected;

  @override
  HubConnectionState get state => _state;

  set state(HubConnectionState s) => _state = s;

  @override
  void on(String methodName, void Function(List<Object?>?) newMethod) {
    handlers[methodName] = newMethod;
  }

  @override
  void onreconnected(void Function({String? connectionId})? callback) {
    reconnectedHandler = callback;
  }

  @override
  void onclose(void Function({Exception? error})? callback) {
    closeHandler = callback;
  }

  @override
  Future<Object?> invoke(String methodName, {List<Object?>? args}) async {
    invokedMethods.add({'method': methodName, 'args': args});
    return null;
  }

  @override
  Future<void> start() async {
    _state = HubConnectionState.Connected;
  }

  @override
  Future<void> stop() async {
    _state = HubConnectionState.Disconnected;
  }

  void emit(String methodName, List<Object?>? args) {
    handlers[methodName]?.call(args);
  }
}

void main() {
  late FakeTokenService tokenService;
  late TestHubConnection testHubConnection;
  late VoiceCallSignalRService service;

  setUp(() async {
    tokenService = FakeTokenService();
    testHubConnection = TestHubConnection();
    service = VoiceCallSignalRService(
      tokenService,
      hubConnectionFactory: (url, {options}) => testHubConnection,
    );
    await service.connectAndBind(
      deviceSessionId: 'sess-123',
      controlProof: 'proof-abc',
    );
  });

  group('VoiceCallSignalRService Seam & Baseline', () {
    test('connectAndBind establishes connection and binds session', () {
      expect(service.isConnected, isTrue);
      expect(service.isBound, isTrue);
      expect(
        testHubConnection.invokedMethods.any(
          (m) => m['method'] == 'BindDeviceSession',
        ),
        isTrue,
      );
    });

    test('can emit named SignalR events via test seam', () {
      Map<String, dynamic>? receivedEvent;
      service.onCallEvent = (envelope) {
        receivedEvent = envelope;
      };

      testHubConnection.emit('call:event', [
        {
          'callId': 'call-1',
          'eventId': 'ev-1',
          'sequence': 1,
          'payload': {'status': 'ringing'},
        },
      ]);

      expect(receivedEvent, isNotNull);
      expect(receivedEvent!['callId'], 'call-1');
      expect(receivedEvent!['eventId'], 'ev-1');
    });
  });

  group('RTC Envelope Decoding (Task 2)', () {
    test('rtc:offer decodes one-item backend envelope correctly', () {
      String? receivedCallId;
      Map<String, dynamic>? receivedOffer;
      String? receivedMessageId;
      int? receivedGen;

      service.onRtcOffer = (callId, offer, messageId, gen) {
        receivedCallId = callId;
        receivedOffer = offer;
        receivedMessageId = messageId;
        receivedGen = gen;
      };

      testHubConnection.emit('rtc:offer', [
        {
          'callId': 'call-offer-1',
          'messageId': 'msg-offer-1',
          'negotiationGeneration': 2,
          'payload': {'type': 'offer', 'sdp': 'v=0\r\no=mock-sdp'},
        },
      ]);

      expect(receivedCallId, 'call-offer-1');
      expect(receivedMessageId, 'msg-offer-1');
      expect(receivedGen, 2);
      expect(receivedOffer, isNotNull);
      expect(receivedOffer!['type'], 'offer');
      expect(receivedOffer!['sdp'], 'v=0\r\no=mock-sdp');
    });

    test(
      'rtc:answer decodes one-item backend envelope correctly with generation > 0',
      () {
        String? receivedCallId;
        Map<String, dynamic>? receivedAnswer;
        String? receivedMessageId;
        int? receivedGen;

        service.onRtcAnswer = (callId, answer, messageId, gen) {
          receivedCallId = callId;
          receivedAnswer = answer;
          receivedMessageId = messageId;
          receivedGen = gen;
        };

        testHubConnection.emit('rtc:answer', [
          {
            'callId': 'call-ans-1',
            'messageId': 'msg-ans-1',
            'negotiationGeneration': 3,
            'payload': {'type': 'answer', 'sdp': 'v=0\r\no=mock-answer-sdp'},
          },
        ]);

        expect(receivedCallId, 'call-ans-1');
        expect(receivedMessageId, 'msg-ans-1');
        expect(receivedGen, 3);
        expect(receivedAnswer, isNotNull);
        expect(receivedAnswer!['type'], 'answer');
        expect(receivedAnswer!['sdp'], 'v=0\r\no=mock-answer-sdp');
      },
    );

    test('rtc:ice-candidate decodes one-item backend envelope correctly', () {
      String? receivedCallId;
      Map<String, dynamic>? receivedIce;
      String? receivedMessageId;
      int? receivedGen;

      service.onRtcIce = (callId, candidate, messageId, gen) {
        receivedCallId = callId;
        receivedIce = candidate;
        receivedMessageId = messageId;
        receivedGen = gen;
      };

      testHubConnection.emit('rtc:ice-candidate', [
        {
          'callId': 'call-ice-1',
          'messageId': 'msg-ice-1',
          'negotiationGeneration': 1,
          'payload': {
            'candidate':
                'candidate:1 1 UDP 2130706431 192.168.1.1 5000 typ host',
            'sdpMid': '0',
            'sdpMLineIndex': 0,
          },
        },
      ]);

      expect(receivedCallId, 'call-ice-1');
      expect(receivedMessageId, 'msg-ice-1');
      expect(receivedGen, 1);
      expect(receivedIce, isNotNull);
      expect(receivedIce!['sdpMid'], '0');
      expect(receivedIce!['sdpMLineIndex'], 0);
    });

    test(
      'supports generation alias field if negotiationGeneration is absent',
      () {
        String? receivedCallId;
        int? receivedGen;

        service.onRtcOffer = (callId, offer, messageId, gen) {
          receivedCallId = callId;
          receivedGen = gen;
        };

        testHubConnection.emit('rtc:offer', [
          {
            'callId': 'call-offer-alt',
            'messageId': 'msg-alt',
            'generation': 4,
            'payload': {'type': 'offer', 'sdp': 'v=0'},
          },
        ]);

        expect(receivedCallId, 'call-offer-alt');
        expect(receivedGen, 4);
      },
    );

    test('legacy 4-argument fallback works for backwards compatibility', () {
      String? receivedCallId;
      Map<String, dynamic>? receivedOffer;
      String? receivedMessageId;
      int? receivedGen;

      service.onRtcOffer = (callId, offer, messageId, gen) {
        receivedCallId = callId;
        receivedOffer = offer;
        receivedMessageId = messageId;
        receivedGen = gen;
      };

      testHubConnection.emit('rtc:offer', [
        'call-leg-1',
        {'type': 'offer', 'sdp': 'v=0\r\no=legacy'},
        'msg-leg-1',
        0,
      ]);

      expect(receivedCallId, 'call-leg-1');
      expect(receivedMessageId, 'msg-leg-1');
      expect(receivedGen, 0);
      expect(receivedOffer?['sdp'], 'v=0\r\no=legacy');
    });

    test('malformed inputs are safely ignored without callback or crash', () {
      int callbackCount = 0;
      service.onRtcOffer = (callId, offer, messageId, gen) => callbackCount++;
      service.onRtcAnswer = (callId, answer, messageId, gen) => callbackCount++;
      service.onRtcIce = (callId, candidate, messageId, gen) => callbackCount++;

      // null arguments
      testHubConnection.emit('rtc:offer', null);
      // empty arguments
      testHubConnection.emit('rtc:offer', []);
      // non-map envelope
      testHubConnection.emit('rtc:offer', ['not-a-map']);
      // missing callId
      testHubConnection.emit('rtc:offer', [
        {
          'messageId': 'm1',
          'negotiationGeneration': 0,
          'payload': {'sdp': 'x'},
        },
      ]);
      // empty callId
      testHubConnection.emit('rtc:offer', [
        {
          'callId': '',
          'messageId': 'm1',
          'negotiationGeneration': 0,
          'payload': {'sdp': 'x'},
        },
      ]);
      // missing messageId
      testHubConnection.emit('rtc:offer', [
        {
          'callId': 'c1',
          'negotiationGeneration': 0,
          'payload': {'sdp': 'x'},
        },
      ]);
      // empty messageId
      testHubConnection.emit('rtc:offer', [
        {
          'callId': 'c1',
          'messageId': '',
          'negotiationGeneration': 0,
          'payload': {'sdp': 'x'},
        },
      ]);
      // missing payload
      testHubConnection.emit('rtc:offer', [
        {'callId': 'c1', 'messageId': 'm1', 'negotiationGeneration': 0},
      ]);
      // non-map payload
      testHubConnection.emit('rtc:offer', [
        {
          'callId': 'c1',
          'messageId': 'm1',
          'negotiationGeneration': 0,
          'payload': 'not-a-map',
        },
      ]);
      // negative generation
      testHubConnection.emit('rtc:offer', [
        {
          'callId': 'c1',
          'messageId': 'm1',
          'negotiationGeneration': -1,
          'payload': {'sdp': 'x'},
        },
      ]);
      // invalid generation type
      testHubConnection.emit('rtc:offer', [
        {
          'callId': 'c1',
          'messageId': 'm1',
          'negotiationGeneration': 'invalid',
          'payload': {'sdp': 'x'},
        },
      ]);

      expect(callbackCount, 0);
    });

    test('outgoing calls preserve four arguments contract', () async {
      await service.sendOffer(
        callId: 'c-out',
        sdp: 'sdp-out',
        messageId: 'm-out',
        generation: 1,
      );

      final sendOfferInvocation = testHubConnection.invokedMethods.firstWhere(
        (m) => m['method'] == 'SendOffer',
      );
      expect(sendOfferInvocation['args'], isNotNull);
      final offerArgs = sendOfferInvocation['args'] as List;
      expect(offerArgs.length, 4);
      expect(offerArgs[0], 'c-out');
      expect(offerArgs[1], {'type': 'offer', 'sdp': 'sdp-out'});
      expect(offerArgs[2], 'm-out');
      expect(offerArgs[3], 1);

      await service.sendAnswer(
        callId: 'c-ans',
        sdp: 'sdp-ans',
        messageId: 'm-ans',
        generation: 2,
      );

      final sendAnswerInvocation = testHubConnection.invokedMethods.firstWhere(
        (m) => m['method'] == 'SendAnswer',
      );
      final ansArgs = sendAnswerInvocation['args'] as List;
      expect(ansArgs.length, 4);
      expect(ansArgs[0], 'c-ans');
      expect(ansArgs[1], {'type': 'answer', 'sdp': 'sdp-ans'});
      expect(ansArgs[2], 'm-ans');
      expect(ansArgs[3], 2);

      await service.sendIceCandidate(
        callId: 'c-ice',
        candidateData: {'candidate': 'cand-text', 'sdpMid': '0'},
        messageId: 'm-ice',
        generation: 3,
      );

      final sendIceInvocation = testHubConnection.invokedMethods.firstWhere(
        (m) => m['method'] == 'SendIceCandidate',
      );
      final iceArgs = sendIceInvocation['args'] as List;
      expect(iceArgs.length, 4);
      expect(iceArgs[0], 'c-ice');
      expect(iceArgs[1], {'candidate': 'cand-text', 'sdpMid': '0'});
      expect(iceArgs[2], 'm-ice');
      expect(iceArgs[3], 3);
    });
  });
}
