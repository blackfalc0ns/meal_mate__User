import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/calling/domain/entities/native_call_snapshot_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_display_entity.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/calling_state.dart';

void main() {
  test('uses push name without call display request', () {
    const state = CallingState(
      nativeSnapshot: NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'engine',
        revision: 1,
        phase: NativeCallPhase.ringing,
        callerDisplay: NativeCallerDisplayEntity(callerName: 'يحيي سواق'),
      ),
      display: VoiceCallDisplayEntity(
        callId: 'call-1',
        driverName: 'اسم مختلف',
      ),
    );
    expect(state.resolvedDriverName('مندوب التوصيل'), 'يحيي سواق');
  });

  test('does not show literal null or use REST display as fallback', () {
    const state = CallingState(
      nativeSnapshot: NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'engine',
        revision: 1,
        phase: NativeCallPhase.ringing,
        callerDisplay: NativeCallerDisplayEntity(callerName: 'null'),
      ),
      display: VoiceCallDisplayEntity(
        callId: 'call-1',
        driverName: 'اسم من API',
      ),
    );
    expect(state.resolvedDriverName('مندوب التوصيل'), 'مندوب التوصيل');
  });
}
