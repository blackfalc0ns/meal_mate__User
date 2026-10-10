import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/calling/data/mapper/voice_call_mapper.dart';
import 'package:meal_meat_user/features/calling/data/models/request/voice_device_register_request_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/request/voice_media_report_request_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_call_display_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_call_event_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_call_snapshot_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_device_register_response_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_ice_servers_response_dto.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_display_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_status.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_device_session_entity.dart';

void main() {
  group('Voice Calls v2 - DTO & Domain Entity Unit Tests', () {
    test('VoiceDeviceRegisterRequestDto enforces capabilityVersion = 2', () {
      const dto = VoiceDeviceRegisterRequestDto(
        installationId: 'inst-1234',
        platform: 'android',
        capabilityVersion: 2,
        fcmDeviceTokenId: 'fcm-token-id-owned',
      );

      final json = dto.toJson();
      expect(json['installationId'], 'inst-1234');
      expect(json['platform'], 'android');
      expect(json['capabilityVersion'], 2);
      expect(json['fcmDeviceTokenId'], 'fcm-token-id-owned');
      expect(json['apnsVoipToken'], isNull);
    });

    test(
      'VoiceDeviceRegisterResponseDto and Session Entity mapping & expiry check',
      () {
        final nowUtc = DateTime.now().toUtc();
        final expiresUtc = nowUtc.add(const Duration(minutes: 60));

        final json = {
          'deviceSessionId': 'session-uuid-123',
          'controlProof': 'proof-secret-123',
          'expiresAtUtc': expiresUtc.toIso8601String(),
        };

        final dto = VoiceDeviceRegisterResponseDto.fromJson(json);
        expect(dto.deviceSessionId, 'session-uuid-123');
        expect(dto.controlProof, 'proof-secret-123');
        expect(dto.expiresAtUtc, isNotNull);

        final entity = VoiceCallMapper.toDeviceSessionEntity(dto);
        expect(entity.deviceSessionId, 'session-uuid-123');
        expect(entity.controlProof, 'proof-secret-123');
        expect(entity.isValid, isTrue);

        final expiredEntity = VoiceDeviceSessionEntity(
          deviceSessionId: 'sess-exp',
          controlProof: 'proof',
          expiresAtUtc: nowUtc.subtract(const Duration(minutes: 5)),
        );
        expect(expiredEntity.isValid, isFalse);
      },
    );

    test(
      'VoiceCallSnapshotDto correctly handles nullables, status and monotonic sequence',
      () {
        final json = {
          'callId': 'call-uuid-999',
          'tripStopId': 'stop-uuid-456',
          'protocolVersion': 2,
          'sequence': 42,
          'status': 'Active',
          'endReason': null,
          'startedAtUtc': '2026-10-10T02:00:00Z',
          'acceptedAtUtc': '2026-10-10T02:00:10Z',
          'connectedAtUtc': '2026-10-10T02:00:15Z',
          'winningDeviceSessionId': 'session-winner-777',
          'localParticipantRole': 'customer',
        };

        final dto = VoiceCallSnapshotDto.fromJson(json);
        expect(dto.callId, 'call-uuid-999');
        expect(dto.sequence, 42);
        expect(dto.status, 'Active');
        expect(dto.winningDeviceSessionId, 'session-winner-777');
        expect(dto.localParticipantRole, 'customer');

        final entity = VoiceCallMapper.toSnapshotEntity(dto);
        expect(entity.callId, 'call-uuid-999');
        expect(entity.tripStopId, 'stop-uuid-456');
        expect(entity.sequence, 42);
        expect(entity.status, VoiceCallStatus.active);
        expect(entity.status.isLive, isTrue);
        expect(entity.status.isTerminal, isFalse);
        expect(entity.winningDeviceSessionId, 'session-winner-777');
      },
    );

    test('VoiceCallStatus parses all lifecycle statuses correctly', () {
      expect(VoiceCallStatus.fromString('Created'), VoiceCallStatus.created);
      expect(VoiceCallStatus.fromString('Ringing'), VoiceCallStatus.ringing);
      expect(VoiceCallStatus.fromString('Accepted'), VoiceCallStatus.accepted);
      expect(
        VoiceCallStatus.fromString('Connecting'),
        VoiceCallStatus.connecting,
      );
      expect(VoiceCallStatus.fromString('Active'), VoiceCallStatus.active);
      expect(VoiceCallStatus.fromString('Rejected'), VoiceCallStatus.rejected);
      expect(
        VoiceCallStatus.fromString('Cancelled'),
        VoiceCallStatus.cancelled,
      );
      expect(VoiceCallStatus.fromString('Missed'), VoiceCallStatus.missed);
      expect(VoiceCallStatus.fromString('Failed'), VoiceCallStatus.failed);
      expect(VoiceCallStatus.fromString('Ended'), VoiceCallStatus.ended);
      expect(
        VoiceCallStatus.fromString('UnknownStatus'),
        VoiceCallStatus.unknown,
      );

      expect(VoiceCallStatus.rejected.isTerminal, isTrue);
      expect(VoiceCallStatus.cancelled.isTerminal, isTrue);
      expect(VoiceCallStatus.missed.isTerminal, isTrue);
      expect(VoiceCallStatus.failed.isTerminal, isTrue);
      expect(VoiceCallStatus.ended.isTerminal, isTrue);
    });

    test('VoiceCallEventDto parsing envelope metadata correctly', () {
      final json = {
        'eventId': 'evt-111',
        'protocolVersion': 2,
        'callId': 'call-111',
        'sequence': 5,
        'eventType': 'call:ringing',
        'occurredAtUtc': '2026-10-10T02:00:05Z',
        'payload': {
          'callId': 'call-111',
          'sequence': 5,
          'status': 'Ringing',
          'startedAtUtc': '2026-10-10T02:00:00Z',
        },
      };

      final dto = VoiceCallEventDto.fromJson(json);
      expect(dto.eventId, 'evt-111');
      expect(dto.callId, 'call-111');
      expect(dto.sequence, 5);
      expect(dto.eventType, 'call:ringing');
      expect(dto.payload, isNotNull);

      final entity = VoiceCallMapper.toEventEntity(dto);
      expect(entity.eventId, 'evt-111');
      expect(entity.eventType, 'call:ringing');
      expect(entity.sequence, 5);
      expect(entity.payloadSnapshot?.status, VoiceCallStatus.ringing);
    });

    test(
      'VoiceIceServersResponseDto parses STUN/TURN URLs and credentials without leaking secrets',
      () {
        final json = {
          'ttlSeconds': 3600,
          'iceServers': [
            {
              'urls': ['stun:stun.l.google.com:19302'],
            },
            {
              'urls': [
                'turn:turn.mealmate.app:3478?transport=udp',
                'turn:turn.mealmate.app:3478?transport=tcp',
              ],
              'username': 'temp-user-123',
              'credential': 'temp-password-abc',
              'expiresAtUtc': '2026-10-10T03:00:00Z',
            },
          ],
        };

        final dto = VoiceIceServersResponseDto.fromJson(json);
        expect(dto.ttlSeconds, 3600);
        expect(dto.iceServers?.length, 2);

        final entity = VoiceCallMapper.toIceServersConfigEntity(dto);
        expect(entity.iceServers.length, 2);
        expect(entity.iceServers[0].urls.first, 'stun:stun.l.google.com:19302');
        expect(entity.iceServers[0].username, isNull);
        expect(entity.iceServers[1].username, 'temp-user-123');
        expect(entity.iceServers[1].credential, 'temp-password-abc');
        expect(entity.iceServers[1].urls.length, 2);
      },
    );

    test('VoiceMediaReportRequestDto serialization', () {
      const dto = VoiceMediaReportRequestDto(
        callId: 'call-xyz',
        timestampUtc: '2026-10-10T02:05:00Z',
        metrics: {'rtt': 45, 'jitter': 2},
      );

      final json = dto.toJson();
      expect(json['callId'], 'call-xyz');
      expect(json['timestampUtc'], '2026-10-10T02:05:00Z');
      expect(json['metrics']['rtt'], 45);
    });

    test(
      'VoiceCallDisplayDto deserialization, mapping, and relative URL resolution',
      () {
        final json = {
          'callId': 'c1e7a634-972f-412c-b26a-613d9ea5db50',
          'tripStopId': '7c2e9124-7df5-4309-8809-548c22d4f208',
          'driverName': 'أحمد محمود',
          'driverImageUrl': '/uploads/drivers/avatar_123.jpg',
          'driverRole': 'مندوب التوصيل',
          'vehicleType': 'دراجة نارية',
          'plateNumber': '1234 أ ب ج',
          'deliveryAddress': 'شارع الملك فهد، مبنى 10',
          'deliveryZone': 'المنطقة الأولى',
          'orderCode': 'ORD-9988',
          'mealSummary': 'وجبة عائلية x 1',
          'slotLabel': '12:00 PM - 01:00 PM',
          'boxCount': 2,
          'stopStatus': 'PickedUp',
        };

        final dto = VoiceCallDisplayDto.fromJson(json);
        expect(dto.callId, 'c1e7a634-972f-412c-b26a-613d9ea5db50');
        expect(dto.driverName, 'أحمد محمود');
        expect(dto.driverImageUrl, '/uploads/drivers/avatar_123.jpg');

        final entity = VoiceCallMapper.toDisplayEntity(dto);
        expect(entity.callId, 'c1e7a634-972f-412c-b26a-613d9ea5db50');
        expect(entity.resolvedDriverName, 'أحمد محمود');
        expect(entity.resolvedAddress, 'شارع الملك فهد، مبنى 10');
        expect(
          entity.resolveDriverImageUrl('https://maelmate.runasp.net'),
          'https://maelmate.runasp.net/uploads/drivers/avatar_123.jpg',
        );
        expect(entity.resolveStopStatus('ar'), 'تم استلام الطلب');
        expect(entity.resolveStopStatus('en'), 'Order Picked Up');
      },
    );

    test(
      'VoiceCallDisplayEntity falls back to deliveryZone when deliveryAddress is empty or null',
      () {
        const entityWithNullAddress = VoiceCallDisplayEntity(
          callId: 'call-1',
          deliveryAddress: null,
          deliveryZone: 'حي النرجس',
        );
        expect(entityWithNullAddress.resolvedAddress, 'حي النرجس');

        const entityWithEmptyAddress = VoiceCallDisplayEntity(
          callId: 'call-2',
          deliveryAddress: '   ',
          deliveryZone: 'حي الياسمين',
        );
        expect(entityWithEmptyAddress.resolvedAddress, 'حي الياسمين');

        const entityWithNullZone = VoiceCallDisplayEntity(
          callId: 'call-3',
          deliveryAddress: null,
          deliveryZone: null,
        );
        expect(entityWithNullZone.resolvedAddress, '');
      },
    );

    test(
      'VoiceCallDisplayEntity handles null or empty driver name and image gracefully',
      () {
        const entity = VoiceCallDisplayEntity(
          callId: 'call-empty',
          driverName: '',
          driverImageUrl: null,
        );
        expect(entity.resolvedDriverName, '');
        expect(
          entity.resolveDriverImageUrl('https://maelmate.runasp.net'),
          isNull,
        );
      },
    );
  });
}
