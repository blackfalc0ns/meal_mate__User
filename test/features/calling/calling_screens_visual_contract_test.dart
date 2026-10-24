import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calling/domain/entities/call_driver_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/native_call_snapshot_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_status.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/calling_state.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/calling_view_model.dart';
import 'package:meal_meat_user/features/calling/presentation/screens/active_call_screen.dart';
import 'package:meal_meat_user/features/calling/presentation/screens/incoming_call_screen.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_address_card.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_controls.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_avatar_rings.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_role_badge.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_header_brand.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_incoming_actions.dart';

class TestAssetBundle extends CachingAssetBundle {
  static final Uint8List _transparentPng = Uint8List.fromList(<int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);

  @override
  Future<ByteData> load(String key) async {
    try {
      return await rootBundle.load(key);
    } catch (_) {
      return ByteData.view(_transparentPng.buffer);
    }
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    try {
      return await rootBundle.loadString(key, cache: cache);
    } catch (_) {
      return '<svg viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg"><rect width="10" height="10"/></svg>';
    }
  }
}

Widget buildTestableScreen({
  required Widget screen,
  required Locale locale,
  required Size size,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.lightTheme,
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: screen,
        ),
      ),
    ),
  );
}

void main() {
  const androidSize = Size(393, 852);
  const iphoneSize = Size(390, 844);

  const testDriver = CallDriverEntity(
    name: 'Mohamed Ali',
    role: 'Delivery Driver',
    avatarAsset: 'assets/images/profile_avatar.png',
    addressTitle: 'Home Address',
    addressDetails: 'Capital, Rawda, Block 1, St 10, Bldg 5',
  );

  group('IncomingCallScreen Visual & State Contract Tests', () {
    for (final config in [
      (name: 'Android Viewport - Arabic', size: androidSize, locale: const Locale('ar')),
      (name: 'iPhone Viewport - English', size: iphoneSize, locale: const Locale('en')),
    ]) {
      testWidgets('Renders all incoming call inventory fields on ${config.name}', (tester) async {
        tester.view.physicalSize = config.size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final vm = CallingViewModel.preview(driver: testDriver);
        vm.emit(
          const CallingState(
            driver: testDriver,
            status: VoiceCallStatus.ringing,
            nativeSnapshot: NativeCallSnapshotEntity(
              schemaVersion: 1,
              engineInstanceId: 'eng_test',
              revision: 1,
              callId: 'call_snap_1',
              phase: NativeCallPhase.ringing,
              callerDisplay: NativeCallerDisplayEntity(
                callerName: 'Mohamed Ali',
                callerRole: 'مندوب التوصيل',
              ),
            ),
          ),
        );

        await tester.pumpWidget(
          buildTestableScreen(
            screen: IncomingCallScreen(
              driver: testDriver,
              viewModel: vm,
            ),
            locale: config.locale,
            size: config.size,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CallingHeaderBrand), findsOneWidget);
        expect(find.byType(CallingDriverAvatarRings), findsOneWidget);
        expect(find.byType(CallingDriverRoleBadge), findsOneWidget);
        expect(find.byType(CallingIncomingActions), findsOneWidget);

        expect(find.text('Mohamed Ali'), findsOneWidget);
        expect(find.text('مندوب التوصيل'), findsOneWidget);
      });
    }
  });

  group('ActiveCallScreen Visual & State Contract Tests', () {
    for (final config in [
      (name: 'Android Viewport - Arabic', size: androidSize, locale: const Locale('ar')),
      (name: 'iPhone Viewport - English', size: iphoneSize, locale: const Locale('en')),
    ]) {
      testWidgets('Renders all active call inventory with timer 01:23 on ${config.name}', (tester) async {
        tester.view.physicalSize = config.size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final vm = CallingViewModel.preview(driver: testDriver);
        vm.emit(
          const CallingState(
            driver: testDriver,
            status: VoiceCallStatus.active,
            durationSeconds: 83, // 01:23
            nativeSnapshot: NativeCallSnapshotEntity(
              schemaVersion: 1,
              engineInstanceId: 'eng_test',
              revision: 2,
              callId: 'call_snap_1',
              phase: NativeCallPhase.connected,
              elapsedSeconds: 83,
              callerDisplay: NativeCallerDisplayEntity(
                callerName: 'Mohamed Ali',
                callerRole: 'مندوب التوصيل',
                deliveryAddress: 'Capital, Rawda, Block 1, St 10, Bldg 5',
                addressTitle: 'Home Address',
              ),
            ),
          ),
        );

        await tester.pumpWidget(
          buildTestableScreen(
            screen: ActiveCallScreen(
              driver: testDriver,
              viewModel: vm,
            ),
            locale: config.locale,
            size: config.size,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CallingHeaderBrand), findsOneWidget);
        expect(find.text('01:23'), findsOneWidget);
        expect(find.byType(CallingDriverAvatarRings), findsOneWidget);
        expect(find.byType(CallingDriverRoleBadge), findsOneWidget);
        expect(find.byType(CallingActiveAddressCard), findsOneWidget);
        expect(find.byType(CallingActiveControls), findsOneWidget);

        expect(find.text('Mohamed Ali'), findsOneWidget);
        expect(find.text('Home Address'), findsOneWidget);
        expect(find.text('Capital, Rawda, Block 1, St 10, Bldg 5'), findsOneWidget);
      });
    }

    testWidgets('ActiveCallScreen shows mic permission banner when audio permission missing', (tester) async {
      final vm = CallingViewModel.preview(driver: testDriver);
      vm.emit(
        const CallingState(
          driver: testDriver,
          status: VoiceCallStatus.active,
          durationSeconds: 15,
          hasAudioPermissionError: true,
          nativeSnapshot: NativeCallSnapshotEntity(
            schemaVersion: 1,
            engineInstanceId: 'eng_test',
            revision: 3,
            callId: 'call_snap_1',
            phase: NativeCallPhase.connected,
            elapsedSeconds: 15,
            microphonePermission: NativeMicrophonePermission.denied,
          ),
        ),
      );

      await tester.pumpWidget(
        buildTestableScreen(
          screen: ActiveCallScreen(
            driver: testDriver,
            viewModel: vm,
          ),
          locale: const Locale('en'),
          size: iphoneSize,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic_off), findsOneWidget);
      expect(find.text('Tap to grant microphone permission to speak'), findsOneWidget);
    });
  });
}
