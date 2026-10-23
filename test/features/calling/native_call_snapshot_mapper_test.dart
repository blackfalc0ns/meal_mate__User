import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/calling/data/mapper/native_call_snapshot_mapper.dart';
import 'package:meal_meat_user/features/calling/data/models/response/native_call_snapshot_dto.dart';
import 'package:meal_meat_user/features/calling/domain/entities/native_call_snapshot_entity.dart';

void main() {
  group('NativeCallSnapshotDto & Mapper Tests', () {
    test('null callId with idle phase is valid and maps to entity', () {
      final json = {
        'schemaVersion': 1,
        'engineInstanceId': 'engine-test-1',
        'revision': 1,
        'callId': null,
        'lifecycleId': null,
        'serverSequence': 0,
        'negotiationGeneration': 0,
        'phase': 'idle',
        'serverStatus': null,
        'microphonePermission': 'granted',
        'isMuted': false,
        'audioRouteId': 'earpiece',
        'availableAudioRoutes': ['earpiece', 'speaker'],
        'mediaTransportConnected': false,
        'audioSessionActive': false,
        'connectedAtUtc': null,
        'elapsedSeconds': 0,
        'errorCode': null,
      };

      final dto = NativeCallSnapshotDto.fromJson(json);
      expect(dto.callId, isNull);
      expect(dto.phase, 'idle');

      final entity = dto.toEntity();
      expect(entity.callId, isNull);
      expect(entity.phase, NativeCallPhase.idle);
      expect(entity.engineInstanceId, 'engine-test-1');
      expect(entity.revision, 1);
      expect(entity.isMuted, isFalse);
      expect(entity.audioRouteId, 'earpiece');
      expect(entity.availableAudioRoutes, contains('speaker'));
    });

    test('connected phase with valid callId and callerDisplay maps correctly', () {
      final json = {
        'schemaVersion': 1,
        'engineInstanceId': 'engine-test-1',
        'revision': 18,
        'callId': 'call-101',
        'lifecycleId': 'lifecycle-101',
        'serverSequence': 7,
        'negotiationGeneration': 0,
        'phase': 'connected',
        'serverStatus': 'accepted',
        'microphonePermission': 'granted',
        'isMuted': true,
        'audioRouteId': 'speaker',
        'availableAudioRoutes': ['earpiece', 'speaker', 'bluetooth'],
        'mediaTransportConnected': true,
        'audioSessionActive': true,
        'connectedAtUtc': '2026-10-22T18:00:08.000Z',
        'elapsedSeconds': 42,
        'errorCode': null,
        'callerDisplay': {
          'callerName': 'Mohamed Delivery',
          'callerRole': 'driver',
          'avatarUrl': 'https://cdn.trymealmate.com/avatars/driver_1.png',
          'orderNumber': '#1024',
          'deliveryAddress': 'Al-Shuhada, Block 2, St 15, Bldg 4',
          'addressTitle': 'Home',
        },
      };

      final dto = NativeCallSnapshotDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.callId, 'call-101');
      expect(entity.lifecycleId, 'lifecycle-101');
      expect(entity.phase, NativeCallPhase.connected);
      expect(entity.isMuted, isTrue);
      expect(entity.audioRouteId, 'speaker');
      expect(entity.mediaTransportConnected, isTrue);
      expect(entity.audioSessionActive, isTrue);
      expect(entity.elapsedSeconds, 42);
      expect(entity.callerDisplay?.callerName, 'Mohamed Delivery');
      expect(entity.callerDisplay?.orderNumber, '#1024');
      expect(entity.callerDisplay?.deliveryAddress, 'Al-Shuhada, Block 2, St 15, Bldg 4');
      expect(entity.callerDisplay?.addressTitle, 'Home');
    });

    test('missing or null fields in callerDisplay fallback cleanly without error', () {
      final json = {
        'schemaVersion': 1,
        'engineInstanceId': 'engine-test-1',
        'revision': 5,
        'callId': 'call-sparse',
        'phase': 'ringing',
        'callerDisplay': {
          'callerName': null,
          'callerRole': null,
          'avatarUrl': null,
          'orderNumber': null,
          'deliveryAddress': null,
          'addressTitle': null,
        },
      };

      final dto = NativeCallSnapshotDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.callerDisplay?.callerName, '');
      expect(entity.callerDisplay?.callerRole, isNull);
      expect(entity.callerDisplay?.avatarUrl, isNull);
      expect(entity.callerDisplay?.orderNumber, isNull);
      expect(entity.callerDisplay?.deliveryAddress, isNull);
      expect(entity.callerDisplay?.addressTitle, isNull);
    });

    test('non-idle phase missing callId throws FormatException', () {
      final invalidJson = {
        'schemaVersion': 1,
        'engineInstanceId': 'engine-test-1',
        'revision': 2,
        'phase': 'connected',
        'callId': null,
      };

      final dto = NativeCallSnapshotDto.fromJson(invalidJson);
      expect(dto.toEntity, throwsFormatException);
    });

    test('unknown schemaVersion or negative revision throws FormatException', () {
      final invalidSchema = {
        'schemaVersion': 99,
        'engineInstanceId': 'engine-test-1',
        'revision': 1,
        'phase': 'idle',
      };
      final dtoSchema = NativeCallSnapshotDto.fromJson(invalidSchema);
      expect(dtoSchema.toEntity, throwsFormatException);

      final invalidRev = {
        'schemaVersion': 1,
        'engineInstanceId': 'engine-test-1',
        'revision': -5,
        'phase': 'idle',
      };
      final dtoRev = NativeCallSnapshotDto.fromJson(invalidRev);
      expect(dtoRev.toEntity, throwsFormatException);
    });

    test('unknown phase falls back or reports properly', () {
      final unknownPhase = {
        'schemaVersion': 1,
        'engineInstanceId': 'engine-test-1',
        'revision': 3,
        'phase': 'some_future_phase',
        'callId': 'call-123',
      };
      final dto = NativeCallSnapshotDto.fromJson(unknownPhase);
      expect(dto.toEntity().phase, NativeCallPhase.unknown);
    });
  });
}
