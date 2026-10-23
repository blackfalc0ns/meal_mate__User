import 'dart:async';
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

  void emitSnapshot(NativeCallSnapshotEntity snapshot) {
    _controller.add(snapshot);
  }

  @override
  Future<ApiResult<NativeCallSnapshotEntity>> getSnapshot() async {
    return const ApiSuccessResult(
      data: NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_nav',
        revision: 1,
        phase: NativeCallPhase.idle,
      ),
    );
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
  }) async =>
      const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<void>> end({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async =>
      const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<NativeMicrophonePermission>> getMicrophonePermission() async =>
      const ApiSuccessResult(data: NativeMicrophonePermission.granted);

  @override
  Future<ApiResult<bool>> openAppSettings() async =>
      const ApiSuccessResult(data: true);

  @override
  Future<ApiResult<void>> reject({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async =>
      const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<NativeMicrophonePermission>> requestMicrophonePermission() async =>
      const ApiSuccessResult(data: NativeMicrophonePermission.granted);

  @override
  Future<ApiResult<void>> setAudioRoute({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required String routeId,
  }) async =>
      const ApiSuccessResult(data: null);

  @override
  Future<ApiResult<void>> setMuted({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required bool muted,
  }) async =>
      const ApiSuccessResult(data: null);

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

    expect(fakeNav.pushedRoutes, contains(AppRoutes.incomingCall));
    expect(fakeNav.currentRoute, AppRoutes.incomingCall);
  });

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

    expect(fakeNav.pushedRoutes, contains(AppRoutes.activeCall));
    expect(fakeNav.currentRoute, AppRoutes.activeCall);
  });
}
