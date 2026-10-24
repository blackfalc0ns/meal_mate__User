import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/routing/app_routes.dart';
import '../../../../core/network/api_results.dart';
import '../../../../core/services/app_navigator_service.dart';
import '../domain/entities/native_call_snapshot_entity.dart';
import '../domain/repo/native_voice_repository.dart';

@lazySingleton
class VoiceNavigationCoordinator with WidgetsBindingObserver {
  final NativeVoiceRepository _repository;
  final AppNavigatorService _navigatorService;

  StreamSubscription<NativeCallSnapshotEntity>? _snapshotSubscription;
  NativeCallPhase _lastPhase = NativeCallPhase.idle;
  String? _lastCallId;
  bool _isInitialized = false;

  VoiceNavigationCoordinator(this._repository, this._navigatorService);

  void initialize() {
    if (_isInitialized) return;
    _isInitialized = true;
    WidgetsBinding.instance.addObserver(this);

    // Initial presentation context
    unawaited(_repository.setPresentationContext(appVisible: true));

    // Listen to snapshot stream
    _snapshotSubscription = _repository.snapshotStream.listen(
      _handleSnapshot,
      onError: (_) {
        // Stream error handling
      },
    );

    // Fetch initial snapshot to reconcile if already in a call on cold start
    unawaited(_reconcileInitialSnapshot());
  }

  NativeCallPhase get lastHandledPhase => _lastPhase;

  Future<void> reconcile([String? launchedCallId]) async {
    final result = await _repository.getSnapshot();
    if (result is ApiSuccessResult<NativeCallSnapshotEntity>) {
      _handleSnapshot(result.data);
    }
  }

  Future<void> _reconcileInitialSnapshot() async {
    await reconcile();
  }

  void _handleSnapshot(NativeCallSnapshotEntity snapshot) {
    final phase = snapshot.phase;
    final callId = snapshot.callId;

    if (phase == _lastPhase && callId == _lastCallId) {
      return;
    }
    _lastPhase = phase;
    _lastCallId = callId;

    switch (phase) {
      case NativeCallPhase.ringing:
        break;
      case NativeCallPhase.answering:
      case NativeCallPhase.connecting:
      case NativeCallPhase.connected:
      case NativeCallPhase.reconnecting:
        break;
      case NativeCallPhase.ended:
      case NativeCallPhase.idle:
        _handleCallEnded();
        break;
      case NativeCallPhase.permissionRequired:
      case NativeCallPhase.ending:
      case NativeCallPhase.unknown:
        break;
    }
  }

  void _handleCallEnded() {
    final nav = _navigatorService.navigator;
    if (nav == null) return;

    if (_navigatorService.isCurrentRoute(AppRoutes.incomingCall) ||
        _navigatorService.isCurrentRoute(AppRoutes.activeCall)) {
      if (nav.canPop()) {
        nav.pop();
      } else {
        unawaited(nav.pushReplacementNamed(AppRoutes.home));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isVisible = state == AppLifecycleState.resumed;
    unawaited(_repository.setPresentationContext(appVisible: isVisible));
    if (isVisible) {
      unawaited(reconcile());
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_snapshotSubscription?.cancel());
    _snapshotSubscription = null;
    _isInitialized = false;
  }
}
