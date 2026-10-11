import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_capabilities.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/biometric_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/screens/biometric_setup_screen.dart';

class FakeBiometricServiceForScreen extends Fake implements BiometricService {
  BiometricCapabilities stubCaps = const BiometricCapabilities(
    supportsBiometrics: true,
    hasEnrollment: true,
    presentationType: BiometricTypeEnum.fingerprint,
  );
  bool stubIsEnabled = false;
  bool stubIsDeferred = false;
  BiometricAuthResult stubAuthResult = const BiometricAuthResult.success();
  bool setBiometricDeferredCalled = false;
  bool setBiometricEnabledCalled = false;

  @override
  Future<BiometricCapabilities> getCapabilities() async => stubCaps;

  @override
  bool isBiometricEnabled() => stubIsEnabled;

  @override
  bool isBiometricDeferred() => stubIsDeferred;

  @override
  Future<bool> canOfferBiometricLogin() async => true;

  @override
  Future<void> setBiometricDeferred(bool deferred) async {
    setBiometricDeferredCalled = true;
    stubIsDeferred = deferred;
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    setBiometricEnabledCalled = true;
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
  final getIt = GetIt.instance;
  late FakeBiometricServiceForScreen fakeService;

  setUp(() async {
    await getIt.reset();
    fakeService = FakeBiometricServiceForScreen();
    getIt.registerSingleton<BiometricService>(fakeService);
    getIt.registerFactory<BiometricViewModel>(
      () => BiometricViewModel(fakeService),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      routes: {
        AppRoutes.home: (context) => const Scaffold(body: Text('Home Screen')),
      },
      home: const BiometricSetupScreen(),
    );
  }

  testWidgets(
    'BiometricSetupScreen renders hero, benefits, and action buttons',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.text('Biometric Sign-In'), findsWidgets);
      expect(find.text('Enable Now'), findsOneWidget);
      expect(find.text('Later'), findsOneWidget);
      expect(find.text('Enhanced Security'), findsOneWidget);
      expect(find.text('Instant Access'), findsOneWidget);
    },
  );

  testWidgets('Tapping Later marks deferred and navigates to home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    await tester.tap(find.text('Later'));
    await tester.pumpAndSettle();

    expect(fakeService.setBiometricDeferredCalled, isTrue);
    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets(
    'Tapping Enable Now authenticates and navigates to home on success',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      await tester.tap(find.text('Enable Now'));
      await tester.pumpAndSettle();

      expect(fakeService.setBiometricEnabledCalled, isTrue);
      expect(find.text('Home Screen'), findsOneWidget);
    },
  );
}
