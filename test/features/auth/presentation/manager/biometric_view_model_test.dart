import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_capabilities.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/biometric_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/biometric_view_model.dart';

class FakeBiometricServiceForViewModel extends Fake
    implements BiometricService {
  BiometricCapabilities stubCaps = const BiometricCapabilities(
    supportsBiometrics: true,
    hasEnrollment: true,
    presentationType: BiometricTypeEnum.fingerprint,
  );
  bool stubIsEnabled = false;
  bool stubCanOffer = false;
  BiometricAuthResult stubAuthResult = const BiometricAuthResult.success();
  bool disableBiometricCalled = false;
  bool setBiometricEnabledCalled = false;
  bool setBiometricEnabledVal = false;

  @override
  Future<BiometricCapabilities> getCapabilities() async => stubCaps;

  @override
  bool isBiometricEnabled() => stubIsEnabled;

  @override
  Future<bool> canOfferBiometricLogin() async => stubCanOffer;

  @override
  Future<void> disableBiometric() async {
    disableBiometricCalled = true;
    stubIsEnabled = false;
    stubCanOffer = false;
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    setBiometricEnabledCalled = true;
    setBiometricEnabledVal = enabled;
    stubIsEnabled = enabled;
  }

  @override
  Future<BiometricAuthResult> authenticate({
    required String localizedReason,
    bool biometricOnly = false,
  }) async {
    return stubAuthResult;
  }
}

void main() {
  late FakeBiometricServiceForViewModel fakeService;
  late BiometricViewModel viewModel;

  setUp(() {
    fakeService = FakeBiometricServiceForViewModel();
    viewModel = BiometricViewModel(fakeService);
  });

  tearDown(() async {
    await viewModel.close();
  });

  test(
    'InitBiometricEvent updates capabilities and readiness without credentials in state',
    () async {
      fakeService.stubIsEnabled = true;
      fakeService.stubCanOffer = true;

      viewModel.doIntent(const InitBiometricEvent());
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isSupported, isTrue);
      expect(viewModel.state.hasEnrollment, isTrue);
      expect(viewModel.state.biometricType, BiometricTypeEnum.fingerprint);
      expect(viewModel.state.isEnabled, isTrue);
      expect(viewModel.state.canRestoreSession, isTrue);
    },
  );

  test(
    'ToggleBiometricEvent(enable: false) disables biometric and clears session restoration',
    () async {
      viewModel.doIntent(
        const ToggleBiometricEvent(enable: false, localizedReason: 'Reason'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(fakeService.disableBiometricCalled, isTrue);
      expect(viewModel.state.isEnabled, isFalse);
      expect(viewModel.state.canRestoreSession, isFalse);
      expect(viewModel.state.isSuccess, isTrue);
    },
  );

  test(
    'ToggleBiometricEvent(enable: true) authenticates and enables on success',
    () async {
      fakeService.stubAuthResult = const BiometricAuthResult.success();
      fakeService.stubCanOffer = true;

      viewModel.doIntent(
        const ToggleBiometricEvent(
          enable: true,
          localizedReason: 'Enable Biometrics',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(fakeService.setBiometricEnabledCalled, isTrue);
      expect(fakeService.setBiometricEnabledVal, isTrue);
      expect(viewModel.state.isEnabled, isTrue);
      expect(viewModel.state.isSuccess, isTrue);
      expect(viewModel.state.authStatus, BiometricAuthStatus.success);
    },
  );

  test(
    'ToggleBiometricEvent(enable: true) user cancellation does not enable',
    () async {
      fakeService.stubAuthResult = const BiometricAuthResult.canceled();

      viewModel.doIntent(
        const ToggleBiometricEvent(
          enable: true,
          localizedReason: 'Enable Biometrics',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(fakeService.setBiometricEnabledCalled, isFalse);
      expect(viewModel.state.isEnabled, isFalse);
      expect(viewModel.state.isSuccess, isFalse);
      expect(viewModel.state.authStatus, BiometricAuthStatus.canceled);
    },
  );

  test(
    'ViewModel closed during in-flight authenticate does not emit after close',
    () async {
      viewModel.doIntent(
        const ToggleBiometricEvent(
          enable: true,
          localizedReason: 'Enable Biometrics',
        ),
      );
      await viewModel.close();
      // Should not throw emit after close
      expect(viewModel.isClosed, isTrue);
    },
  );
}
