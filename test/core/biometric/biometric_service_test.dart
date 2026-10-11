import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeLocalAuthentication extends Fake implements LocalAuthentication {
  bool stubDeviceSupported = true;
  bool stubCanCheckBiometrics = true;
  List<BiometricType> stubBiometrics = [BiometricType.fingerprint];
  bool stubAuthenticateResult = true;
  PlatformException? stubPlatformException;
  bool stopAuthenticationCalled = false;
  int authenticateCalls = 0;

  @override
  Future<bool> isDeviceSupported() async => stubDeviceSupported;

  @override
  Future<bool> get canCheckBiometrics async => stubCanCheckBiometrics;

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async => stubBiometrics;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    dynamic authMessages,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    authenticateCalls++;
    if (stubPlatformException != null) {
      throw stubPlatformException!;
    }
    return stubAuthenticateResult;
  }

  @override
  Future<bool> stopAuthentication() async {
    stopAuthenticationCalled = true;
    return true;
  }
}

class FakeTokenService extends Fake implements TokenService {
  bool hasCreds = false;
  bool deleteCredsCalled = false;

  @override
  Future<bool> hasBiometricCredentials() async => hasCreds;

  @override
  Future<void> deleteBiometricCredentials() async {
    deleteCredsCalled = true;
    hasCreds = false;
  }
}

void main() {
  late FakeLocalAuthentication fakeLocalAuth;
  late FakeTokenService fakeTokenService;
  late SharedPreferences sharedPreferences;
  late BiometricService biometricService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    fakeLocalAuth = FakeLocalAuthentication();
    fakeTokenService = FakeTokenService();

    biometricService = BiometricService(
      fakeLocalAuth,
      sharedPreferences,
      fakeTokenService,
    );
  });

  group('BiometricService - Capabilities', () {
    test(
      'hardware and enrolled fingerprint yields correct capabilities',
      () async {
        fakeLocalAuth.stubCanCheckBiometrics = true;
        fakeLocalAuth.stubBiometrics = [BiometricType.fingerprint];

        final caps = await biometricService.getCapabilities();

        expect(caps.supportsBiometrics, isTrue);
        expect(caps.hasEnrollment, isTrue);
        expect(caps.presentationType, BiometricTypeEnum.fingerprint);
      },
    );

    test(
      'device PIN support alone without biometrics is not biometric enrollment',
      () async {
        fakeLocalAuth.stubDeviceSupported = true;
        fakeLocalAuth.stubCanCheckBiometrics = false;
        fakeLocalAuth.stubBiometrics = [];

        final caps = await biometricService.getCapabilities();

        expect(caps.supportsBiometrics, isFalse);
        expect(caps.hasEnrollment, isFalse);
        expect(caps.presentationType, BiometricTypeEnum.none);
      },
    );

    test(
      'strong/weak biometrics map to generic, not falling back to fingerprint',
      () async {
        fakeLocalAuth.stubCanCheckBiometrics = true;
        fakeLocalAuth.stubBiometrics = [BiometricType.strong];

        final caps = await biometricService.getCapabilities();

        expect(caps.supportsBiometrics, isTrue);
        expect(caps.hasEnrollment, isTrue);
        expect(caps.presentationType, BiometricTypeEnum.generic);
      },
    );

    test('face biometric maps to face presentation', () async {
      fakeLocalAuth.stubCanCheckBiometrics = true;
      fakeLocalAuth.stubBiometrics = [BiometricType.face];

      final caps = await biometricService.getCapabilities();

      expect(caps.presentationType, BiometricTypeEnum.face);
    });
  });

  group('BiometricService - Authentication & Lifecycle', () {
    test('concurrent authenticate returns busy status', () async {
      fakeLocalAuth.stubCanCheckBiometrics = true;
      fakeLocalAuth.stubBiometrics = [BiometricType.fingerprint];

      // First call in progress
      final future1 = biometricService.authenticate(localizedReason: 'Test');
      final result2 = await biometricService.authenticate(
        localizedReason: 'Test 2',
      );

      expect(result2.status, BiometricAuthStatus.busy);
      final result1 = await future1;
      expect(result1.status, BiometricAuthStatus.success);
    });

    test('maps auth_in_progress native error code to busy status', () async {
      fakeLocalAuth.stubCanCheckBiometrics = true;
      fakeLocalAuth.stubBiometrics = [BiometricType.fingerprint];
      fakeLocalAuth.stubPlatformException = PlatformException(
        code: 'auth_in_progress',
        message: 'Authentication in progress',
      );

      final result = await biometricService.authenticate(
        localizedReason: 'Test',
      );

      expect(result.status, BiometricAuthStatus.busy);
    });

    test(
      'maps native cancellation to canceled status without error message',
      () async {
        fakeLocalAuth.stubCanCheckBiometrics = true;
        fakeLocalAuth.stubBiometrics = [BiometricType.fingerprint];
        fakeLocalAuth.stubPlatformException = PlatformException(
          code: 'UserCanceled',
        );

        final result = await biometricService.authenticate(
          localizedReason: 'Test',
        );

        expect(result.status, BiometricAuthStatus.canceled);
        expect(result.isCanceled, isTrue);
      },
    );

    test(
      'cancelAuthentication stops native prompt and clears authenticating guard',
      () async {
        final stopped = await biometricService.cancelAuthentication();

        expect(stopped, isTrue);
        expect(fakeLocalAuth.stopAuthenticationCalled, isTrue);
      },
    );
  });

  group('BiometricService - canOfferBiometricLogin matrix', () {
    test('enabled=true, creds=true, enrolled=true -> true', () async {
      await sharedPreferences.setBool(AppConstants.biometricEnabled, true);
      fakeTokenService.hasCreds = true;
      fakeLocalAuth.stubCanCheckBiometrics = true;
      fakeLocalAuth.stubBiometrics = [BiometricType.fingerprint];

      expect(await biometricService.canOfferBiometricLogin(), isTrue);
    });

    test('enabled=true, creds=false -> false', () async {
      await sharedPreferences.setBool(AppConstants.biometricEnabled, true);
      fakeTokenService.hasCreds = false;
      fakeLocalAuth.stubCanCheckBiometrics = true;
      fakeLocalAuth.stubBiometrics = [BiometricType.fingerprint];

      expect(await biometricService.canOfferBiometricLogin(), isFalse);
    });

    test('enabled=false, creds=true -> false', () async {
      await sharedPreferences.setBool(AppConstants.biometricEnabled, false);
      fakeTokenService.hasCreds = true;
      fakeLocalAuth.stubCanCheckBiometrics = true;
      fakeLocalAuth.stubBiometrics = [BiometricType.fingerprint];

      expect(await biometricService.canOfferBiometricLogin(), isFalse);
    });

    test('enabled=true, creds=true, enrolled=false -> false', () async {
      await sharedPreferences.setBool(AppConstants.biometricEnabled, true);
      fakeTokenService.hasCreds = true;
      fakeLocalAuth.stubCanCheckBiometrics = true;
      fakeLocalAuth.stubBiometrics = [];

      expect(await biometricService.canOfferBiometricLogin(), isFalse);
    });
  });
}
