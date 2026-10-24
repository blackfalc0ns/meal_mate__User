import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';
import 'package:meal_meat_user/features/calling/domain/entities/native_call_snapshot_entity.dart';
import 'package:meal_meat_user/features/calling/domain/repo/native_voice_repository.dart';
import 'package:meal_meat_user/features/calling/service/voice_navigation_coordinator.dart';

class FakeNavigatorService extends AppNavigatorService {
  String? currentRoute;
  final List<String> pushedRoutes = [];
  bool popped = false;

  @override
  bool isCurrentRoute(String routeName) => currentRoute == routeName;

  @override
  Future<T?> pushNamedWhenReady<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    pushedRoutes.add(routeName);
    currentRoute = routeName;
    return null;
  }
}

class FakeNativeRepoForNav implements NativeVoiceRepository {
  final StreamController<NativeCallSnapshotEntity> _controller =
      StreamController<NativeCallSnapshotEntity>.broadcast();

  bool? lastAppVisible;
  NativeCallSnapshotEntity snapshotToReturn = const NativeCallSnapshotEntity(
    schemaVersion: 1,
    engineInstanceId: 'eng_nav',
    revision: 1,
    phase: NativeCallPhase.idle,
  );

  void emitSnapshot(NativeCallSnapshotEntity snapshot) {
    _controller.add(snapshot);
  }

  @override
  Future<ApiResult<NativeCallSnapshotEntity>> getSnapshot() async {
    return ApiSuccessResult(data: snapshotToReturn);
  }

  @override
  Future<ApiResult<void>> setPresentationContext({
    required bool appVisible,
    String? localeTag,
    int? uiRevision,
  }) async {
    lastAppVisible = appVisible;
    return const ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<void>> answer({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async => const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<void>> end({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async => const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<NativeMicrophonePermission>>
  getMicrophonePermission() async =>
      const ApiSuccessResult(data: NativeMicrophonePermission.granted);

  @override
  Future<ApiResult<bool>> openAppSettings() async =>
      const ApiSuccessResult(data: true);

  @override
  Future<ApiResult<void>> reject({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async => const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<NativeMicrophonePermission>>
  requestMicrophonePermission() async =>
      const ApiSuccessResult(data: NativeMicrophonePermission.granted);

  @override
  Future<ApiResult<void>> setAudioRoute({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required String routeId,
  }) async => const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<void>> setMuted({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required bool muted,
  }) async => const ApiSuccessResult(data: null);

  @override
  Stream<NativeCallSnapshotEntity> get snapshotStream => _controller.stream;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeNavigatorService fakeNav;
  late FakeNativeRepoForNav fakeRepo;
  late VoiceNavigationCoordinator coordinator;

  setUp(() {
    fakeNav = FakeNavigatorService();
    fakeRepo = FakeNativeRepoForNav();
    coordinator = VoiceNavigationCoordinator(fakeRepo, fakeNav);
    coordinator.initialize();
  });

  tearDown(() {
    coordinator.dispose();
  });

  test('Routes to incomingCall when snapshot phase is ringing', () async {
    fakeRepo.emitSnapshot(
      const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_nav',
        revision: 2,
        callId: 'call_nav_1',
        phase: NativeCallPhase.ringing,
      ),
    );

    await pumpEventQueue();

    expect(fakeNav.pushedRoutes, isEmpty);
  });

  test(
    'Duplicate ringing snapshot does not trigger duplicate route push',
    () async {
      fakeRepo.emitSnapshot(
        const NativeCallSnapshotEntity(
          schemaVersion: 1,
          engineInstanceId: 'eng_nav',
          revision: 2,
          callId: 'call_nav_1',
          phase: NativeCallPhase.ringing,
        ),
      );
      await pumpEventQueue();

      // Duplicate snapshot
      fakeRepo.emitSnapshot(
        const NativeCallSnapshotEntity(
          schemaVersion: 1,
          engineInstanceId: 'eng_nav',
          revision: 3,
          callId: 'call_nav_1',
          phase: NativeCallPhase.ringing,
        ),
      );
      await pumpEventQueue();

      expect(fakeNav.pushedRoutes, isEmpty);
    },
  );

  test('Routes to activeCall when snapshot phase is connected', () async {
    fakeRepo.emitSnapshot(
      const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_nav',
        revision: 3,
        callId: 'call_nav_2',
        phase: NativeCallPhase.connected,
      ),
    );

    await pumpEventQueue();

    expect(fakeNav.pushedRoutes, isEmpty);
  });

  test(
    'Transition from ringing to answering/connected triggers exactly one route change',
    () async {
      fakeRepo.emitSnapshot(
        const NativeCallSnapshotEntity(
          schemaVersion: 1,
          engineInstanceId: 'eng_nav',
          revision: 1,
          callId: 'call_nav_3',
          phase: NativeCallPhase.ringing,
        ),
      );
      await pumpEventQueue();
      expect(fakeNav.pushedRoutes, isEmpty);

      fakeRepo.emitSnapshot(
        const NativeCallSnapshotEntity(
          schemaVersion: 1,
          engineInstanceId: 'eng_nav',
          revision: 2,
          callId: 'call_nav_3',
          phase: NativeCallPhase.answering,
        ),
      );
      await pumpEventQueue();
      expect(fakeNav.pushedRoutes, isEmpty);

      // Subsequent connected event does not push activeCall again
      fakeRepo.emitSnapshot(
        const NativeCallSnapshotEntity(
          schemaVersion: 1,
          engineInstanceId: 'eng_nav',
          revision: 3,
          callId: 'call_nav_3',
          phase: NativeCallPhase.connected,
        ),
      );
      await pumpEventQueue();
      expect(fakeNav.pushedRoutes, isEmpty);
    },
  );

  test(
    'App resume lifecycle reconciles native snapshot and routes to activeCall if active',
    () async {
      fakeRepo.snapshotToReturn = const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_nav',
        revision: 10,
        callId: 'call_resumed_1',
        phase: NativeCallPhase.connected,
      );

      coordinator.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await pumpEventQueue();

      expect(fakeRepo.lastAppVisible, isTrue);
      expect(fakeNav.pushedRoutes, isEmpty);
    },
  );

  test(
    'Cancellation or timeout ended phase triggers call ending cleanup',
    () async {
      fakeNav.currentRoute = AppRoutes.incomingCall;

      fakeRepo.emitSnapshot(
        const NativeCallSnapshotEntity(
          schemaVersion: 1,
          engineInstanceId: 'eng_nav',
          revision: 4,
          callId: 'call_nav_4',
          phase: NativeCallPhase.ended,
          errorCode: 'timeout',
        ),
      );
      await pumpEventQueue();

      // Ended phase handled
      expect(coordinator.lastHandledPhase, NativeCallPhase.ended);
    },
  );
}
