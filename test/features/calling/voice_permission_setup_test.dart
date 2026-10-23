import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calling/domain/entities/native_call_snapshot_entity.dart';
import 'package:meal_meat_user/features/calling/domain/repo/native_voice_repository.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/voice_permission_setup_event.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/voice_permission_setup_view_model.dart';

class FakeVoiceRepoForPermission implements NativeVoiceRepository {
  NativeMicrophonePermission checkResult = NativeMicrophonePermission.notDetermined;
  NativeMicrophonePermission requestResult = NativeMicrophonePermission.granted;
  bool settingsOpened = false;

  @override
  Future<ApiResult<NativeMicrophonePermission>> getMicrophonePermission() async {
    return ApiSuccessResult(data: checkResult);
  }

  @override
  Future<ApiResult<NativeMicrophonePermission>> requestMicrophonePermission() async {
    return ApiSuccessResult(data: requestResult);
  }

  @override
  Future<ApiResult<bool>> openAppSettings() async {
    settingsOpened = true;
    return const ApiSuccessResult(data: true);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeVoiceRepoForPermission repo;
  late VoicePermissionSetupViewModel viewModel;

  setUp(() {
    repo = FakeVoiceRepoForPermission();
    viewModel = VoicePermissionSetupViewModel(repo);
  });

  tearDown(() async {
    await viewModel.close();
  });

  test('CheckPermissionEvent queries repository and updates permission', () async {
    repo.checkResult = NativeMicrophonePermission.denied;

    viewModel.add(const CheckPermissionEvent());
    await pumpEventQueue();

    expect(viewModel.state.permission, NativeMicrophonePermission.denied);
    expect(viewModel.state.isGranted, false);
  });

  test('RequestPermissionEvent requests permission and updates state to granted', () async {
    repo.requestResult = NativeMicrophonePermission.granted;

    viewModel.add(const RequestPermissionEvent());
    await pumpEventQueue();

    expect(viewModel.state.permission, NativeMicrophonePermission.granted);
    expect(viewModel.state.isGranted, true);
  });

  test('DismissPermissionExplainerEvent marks state as deferred', () async {
    viewModel.add(const DismissPermissionExplainerEvent());
    await pumpEventQueue();

    expect(viewModel.state.isDeferred, true);
  });

  test('OpenPermissionSettingsEvent delegates to repository', () async {
    viewModel.add(const OpenPermissionSettingsEvent());
    await pumpEventQueue();

    expect(repo.settingsOpened, true);
  });
}
