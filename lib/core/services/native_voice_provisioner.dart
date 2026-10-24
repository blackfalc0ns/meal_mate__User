import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import '../../features/calling/data/data_source/voice_device_session_storage.dart';
import '../../features/calling/domain/entities/native_call_snapshot_entity.dart';
import '../../features/calling/domain/entities/voice_device_session_entity.dart';
import '../../features/calling/domain/repo/native_voice_repository.dart';
import '../../features/calling/domain/usecase/register_voice_device_usecase.dart';
import '../../features/calling/domain/usecase/revoke_voice_device_usecase.dart';
import '../network/api_results.dart';
import 'native_voice_session_bridge.dart';
import 'token_service.dart';

/// Provisions credentials only. Native code exclusively owns live call state/media.
class NativeVoiceProvisioner with WidgetsBindingObserver {
  NativeVoiceProvisioner(
    this._register,
    this._revoke,
    this._tokens,
    this._storage,
    this._bridge,
    this._native,
  );

  final RegisterVoiceDeviceUseCase _register;
  final RevokeVoiceDeviceUseCase _revoke;
  final TokenService _tokens;
  final VoiceDeviceSessionStorage _storage;
  final NativeVoiceSessionBridge _bridge;
  final NativeVoiceRepository _native;
  bool _initialized = false;
  int _epoch = 0;
  Future<void> _tail = Future<void>.value();
  String? _lastVoipToken;
  bool _pendingForce = false;
  StreamSubscription<NativeCallSnapshotEntity>? _subscription;

  void initialize() {
    if (_initialized) return;
    _initialized = true;
    _bridge.setVoipTokenChangedHandler(() => ensureRegistered(force: true));
    WidgetsBinding.instance.addObserver(this);
    _subscription = _native.snapshotStream.listen((snapshot) {
      if (snapshot.isTerminal && _pendingForce) {
        _pendingForce = false;
        unawaited(ensureRegistered(force: true));
      }
    }, onError: (Object _) {});
    unawaited(ensureRegistered());
  }

  Future<void> ensureRegistered({
    String? fcmDeviceTokenId,
    bool force = false,
  }) {
    final epoch = _epoch;
    final next = _tail.then((_) => _ensure(epoch, fcmDeviceTokenId, force));
    // Keep the serial queue usable after a failed network request.
    _tail = next.catchError((Object error) {
      debugPrint(
        '[NativeVoice] Provisioning failed (${error.runtimeType}); retrying on resume',
      );
    });
    return _tail;
  }

  Future<void> _ensure(int epoch, String? fcmId, bool force) async {
    if (epoch != _epoch) return;
    final userId = await _tokens.getCurrentUserId();
    final token = await _tokens.getToken();
    if (userId == null || token == null) {
      final meta = await _bridge.getSessionMetadata();
      if (meta.hasSession) {
        await _bridge.clearSession(
          expectedRevision: meta.sessionRevision,
          reason: 'unauthenticated',
        );
      }
      await _storage.clearSession();
      return;
    }
    final generation = _tokens.sessionGeneration;
    final metadata = await _bridge.getSessionMetadata();
    if (epoch != _epoch) return;
    if (metadata.accountId != null && metadata.accountId != userId) {
      await _bridge.clearSession(
        expectedRevision: metadata.sessionRevision,
        reason: 'account_changed',
      );
      await _storage.clearSession();
    } else if (metadata.accountId == userId) {
      // A background native request may have rotated the JWT and refresh token.
      final nativeTokens = await _bridge.readSessionTokens(
        metadata.sessionRevision,
      );
      final nativeToken = nativeTokens?['accessToken'] as String?;
      if (nativeTokens?['accountId'] == userId &&
          nativeToken != null &&
          _expiry(nativeToken) > _expiry(token) &&
          epoch == _epoch &&
          generation == _tokens.sessionGeneration) {
        await _tokens.saveAccessToken(nativeToken);
        await _tokens.saveRefreshToken(
          nativeTokens?['refreshToken'] as String?,
        );
      }
    }
    if (fcmId != null) await _storage.saveFcmDeviceTokenId(fcmId);
    final voipChanged = metadata.apnsVoipToken != _lastVoipToken;
    final snapshot = await _native.getSnapshot();
    final live =
        snapshot is ApiSuccessResult<NativeCallSnapshotEntity> &&
        !snapshot.data.isTerminal;
    final shouldRotate = force || voipChanged || _pendingForce;
    if (live) {
      if (shouldRotate) _pendingForce = true;
      final existing = await _storage.getSession();
      if (existing != null &&
          epoch == _epoch &&
          generation == _tokens.sessionGeneration) {
        await _storage.syncNativeSession(
          existing,
          isCurrent: () =>
              epoch == _epoch && generation == _tokens.sessionGeneration,
        );
        if (epoch == _epoch) await _bridge.resume();
      }
      return;
    }
    final result = await _register(
      fcmDeviceTokenId: fcmId,
      apnsVoipToken: metadata.apnsVoipToken,
      force: shouldRotate && !live,
    );
    if (epoch != _epoch ||
        generation != _tokens.sessionGeneration ||
        await _tokens.getCurrentUserId() != userId) {
      return;
    }
    if (result is ApiSuccessResult<VoiceDeviceSessionEntity>) {
      await _storage.syncNativeSession(
        result.data,
        isCurrent: () =>
            epoch == _epoch && generation == _tokens.sessionGeneration,
      );
      if (epoch != _epoch || generation != _tokens.sessionGeneration) return;
      if (!live) {
        _lastVoipToken = metadata.apnsVoipToken;
        _pendingForce = false;
      }
      await _bridge.resume();
    }
  }

  static int _expiry(String jwt) {
    try {
      final payload =
          jsonDecode(
                utf8.decode(
                  base64Url.decode(base64Url.normalize(jwt.split('.')[1])),
                ),
              )
              as Map;
      return (payload['exp'] as num?)?.toInt() ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> handlePush(Map<String, dynamic> data) =>
      _bridge.handlePush(data);

  Future<void> onLogout() async {
    _epoch++;
    _pendingForce = false;
    _lastVoipToken = null;
    final metadata = await _bridge.getSessionMetadata();
    await _bridge.clearSession(
      expectedRevision: metadata.sessionRevision,
      reason: 'logout',
    );
    await _tail;
    await _revoke();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(ensureRegistered());
  }

  void dispose() {
    _epoch++;
    _initialized = false;
    _bridge.setVoipTokenChangedHandler(null);
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
  }
}
