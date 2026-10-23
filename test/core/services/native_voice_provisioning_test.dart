import 'dart:async';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/native_voice_provisioner.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/core/utils/constants.dart';
import 'package:meal_meat_user/features/calling/domain/entities/native_call_snapshot_entity.dart';
import 'package:meal_meat_user/features/calling/domain/repo/native_voice_repository.dart';
import 'package:meal_meat_user/features/calling/domain/repo/voice_call_repository.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/register_voice_device_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/revoke_voice_device_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_meat_user/core/services/native_voice_session_bridge.dart';
import 'package:meal_meat_user/features/calling/data/data_source/voice_device_session_storage.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_device_session_entity.dart';

class RegistrationRepository implements VoiceCallRepository {
  RegistrationRepository(this.storage);
  final VoiceDeviceSessionStorage storage;
  int registrations = 0;
  bool? lastForce;
  Completer<void>? waitForRegistration;
  Completer<void>? registrationStarted;
  final session = VoiceDeviceSessionEntity(
    deviceSessionId: 'voice-full',
    controlProof: 'proof-full',
    expiresAtUtc: DateTime.utc(2030),
  );
  @override
  Future<ApiResult<VoiceDeviceSessionEntity>> registerDevice({
    String? fcmDeviceTokenId,
    String? apnsVoipToken,
    bool force = false,
  }) async {
    registrations++;
    lastForce = force;
    registrationStarted?.complete();
    await waitForRegistration?.future;
    await storage.saveSession(session);
    return ApiSuccessResult(data: session);
  }

  @override
  Future<ApiResult<void>> revokeDevice() async {
    await storage.clearSession();
    return const ApiSuccessResult(data: null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class NativeStateRepository implements NativeVoiceRepository {
  NativeCallSnapshotEntity current = const NativeCallSnapshotEntity(
    schemaVersion: 1,
    engineInstanceId: 'engine',
    revision: 1,
    phase: NativeCallPhase.idle,
  );
  final updates = StreamController<NativeCallSnapshotEntity>.broadcast();
  Future<void> dispose() => updates.close();
  @override
  Stream<NativeCallSnapshotEntity> get snapshotStream => updates.stream;
  @override
  Future<ApiResult<NativeCallSnapshotEntity>> getSnapshot() async =>
      ApiSuccessResult(data: current);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'saving a voice session never replaces native JWT with null credentials',
    () async {
      FlutterSecureStorage.setMockInitialValues({});
      SharedPreferences.setMockInitialValues({});
      const channel = MethodChannel('test/native-voice-provisioning');
      Map<dynamic, dynamic>? installed;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'getSessionMetadata') {
              return {
                'sessionRevision': 3,
                'hasSession': true,
                'accountId': 'user-1',
              };
            }
            if (call.method == 'readAccessToken') return 'existing-jwt';
            if (call.method == 'installSession') {
              installed = call.arguments as Map;
              return {'sessionRevision': 4};
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      final storage = VoiceDeviceSessionStorage(
        const FlutterSecureStorage(),
        await SharedPreferences.getInstance(),
        NativeVoiceSessionBridge(channelOverride: channel),
      );
      final session = VoiceDeviceSessionEntity(
        deviceSessionId: 'voice-1',
        controlProof: 'proof-1',
        expiresAtUtc: DateTime.utc(2030),
      );
      await storage.saveSession(session);
      expect(
        installed,
        isNull,
        reason:
            'Persistence alone must not install unauthenticated native credentials',
      );
      await storage.syncNativeSession(session);
      expect(installed?['accountId'], 'user-1');
      expect(installed?['accessToken'], 'existing-jwt');
    },
  );
  group('native-only authenticated provisioning', () {
    late NativeVoiceProvisioner provisioner;
    late VoiceDeviceSessionStorage storage;
    late RegistrationRepository registration;
    late NativeStateRepository native;
    late List<Map> installed;
    late List<String> voiceMethods;
    late int revision;
    const sessionChannel = MethodChannel('test/full-session');
    const voiceChannel = MethodChannel('test/full-voice');
    setUp(() async {
      FlutterSecureStorage.setMockInitialValues({
        AppConstants.accessToken: 'jwt-full',
        AppConstants.refreshToken: 'refresh-full',
      });
      SharedPreferences.setMockInitialValues({
        AppConstants.isAccessTokenSaved: true,
        AppConstants.isRefreshTokenSaved: true,
        AppConstants.customerIdKey: 'user-full',
      });
      installed = [];
      voiceMethods = [];
      revision = 0;
      final preferences = await SharedPreferences.getInstance();
      const secure = FlutterSecureStorage();
      final tokens = TokenService(
        prefs: secure,
        sharedPreferences: preferences,
      );
      final bridge = NativeVoiceSessionBridge(
        channelOverride: sessionChannel,
        voiceChannelOverride: voiceChannel,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(sessionChannel, (call) async {
            switch (call.method) {
              case 'getSessionMetadata':
                return {
                  'sessionRevision': revision,
                  'hasSession': installed.isNotEmpty,
                  'accountId': installed.isEmpty ? null : 'user-full',
                };
              case 'installSession':
                installed.add(Map.from(call.arguments as Map));
                return {'sessionRevision': ++revision};
              case 'clearSession':
                installed.clear();
                return {'sessionRevision': ++revision};
              case 'readSessionTokens':
                return {
                  'accountId': 'user-full',
                  'accessToken': 'jwt-full',
                  'refreshToken': 'refresh-full',
                };
            }
            return null;
          });
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(voiceChannel, (call) async {
            voiceMethods.add(call.method);
            return null;
          });
      storage = VoiceDeviceSessionStorage(secure, preferences, bridge, tokens);
      registration = RegistrationRepository(storage);
      native = NativeStateRepository();
      provisioner = NativeVoiceProvisioner(
        RegisterVoiceDeviceUseCase(registration),
        RevokeVoiceDeviceUseCase(registration),
        tokens,
        storage,
        bridge,
        native,
      );
    });
    tearDown(() async {
      provisioner.dispose();
      await native.dispose();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(sessionChannel, null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(voiceChannel, null);
    });
    test(
      'installs complete credentials and resumes only the native owner',
      () async {
        await provisioner.ensureRegistered();
        expect(installed.single['accountId'], 'user-full');
        expect(installed.single['accessToken'], 'jwt-full');
        expect(installed.single['refreshToken'], 'refresh-full');
        expect(installed.single['voiceDeviceSessionId'], 'voice-full');
        expect(voiceMethods, ['resume']);
      },
    );
    test('defers session rotation until the active call has ended', () async {
      await storage.saveSession(registration.session);
      native.current = const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'engine',
        revision: 2,
        callId: 'call',
        lifecycleId: 'life',
        phase: NativeCallPhase.connected,
      );
      await provisioner.ensureRegistered(
        force: true,
        fcmDeviceTokenId: 'new-fcm',
      );
      expect(registration.registrations, 0);
      native.current = const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'engine',
        revision: 3,
        phase: NativeCallPhase.ended,
      );
      await provisioner.ensureRegistered();
      expect(registration.registrations, 1);
      expect(registration.lastForce, true);
    });
    test(
      'an in-flight registration cannot reinstall native credentials after logout',
      () async {
        registration.registrationStarted = Completer<void>();
        registration.waitForRegistration = Completer<void>();
        final provisioning = provisioner.ensureRegistered();
        await registration.registrationStarted!.future;
        final logout = provisioner.onLogout();
        registration.waitForRegistration!.complete();
        await Future.wait([provisioning, logout]);
        expect(installed, isEmpty);
        expect(await storage.getSession(), isNull);
        expect(voiceMethods, isEmpty);
      },
    );
  });
}
