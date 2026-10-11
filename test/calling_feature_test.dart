import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calling/presentation/screens/active_call_screen.dart';
import 'package:meal_meat_user/features/calling/presentation/screens/incoming_call_screen.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_address_card.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_control_button.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_controls.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_end_button.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_avatar_rings.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_role_badge.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_header_brand.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_incoming_actions.dart';

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('ar'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    routes: {AppRoutes.activeCall: (context) => const ActiveCallScreen()},
    home: child,
  );
}

void _setMobileViewSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(390 * 2, 958 * 2);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  group('Calling Feature Widget Tests', () {
    testWidgets(
      'IncomingCallScreen renders all components correctly in Arabic',
      (tester) async {
        _setMobileViewSize(tester);

        await tester.pumpWidget(_buildTestApp(const IncomingCallScreen()));
        await tester.pump();

        expect(find.byType(CallingHeaderBrand), findsOneWidget);
        expect(find.byType(CallingDriverAvatarRings), findsOneWidget);
        expect(find.byType(CallingDriverRoleBadge), findsOneWidget);
        expect(find.byType(CallingIncomingActions), findsOneWidget);

        expect(find.text('محمد علي'), findsOneWidget);
        expect(find.text('مندوب التوصيل'), findsOneWidget);
        expect(find.text('مكالمة واردة من'), findsOneWidget);
        expect(find.text('يتصل بك الآن'), findsOneWidget);
        expect(find.text('قبول'), findsOneWidget);
        expect(find.text('رفض'), findsOneWidget);
      },
    );

    testWidgets(
      'IncomingCallScreen accepting call transitions to ActiveCallScreen',
      (tester) async {
        _setMobileViewSize(tester);

        await tester.pumpWidget(_buildTestApp(const IncomingCallScreen()));
        await tester.pump();

        final acceptButton = find.text('قبول');
        expect(acceptButton, findsOneWidget);

        await tester.tap(acceptButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(ActiveCallScreen), findsOneWidget);
        expect(find.text('مكالمة جارية'), findsOneWidget);
      },
    );

    testWidgets('ActiveCallScreen renders all components correctly', (
      tester,
    ) async {
      _setMobileViewSize(tester);

      await tester.pumpWidget(_buildTestApp(const ActiveCallScreen()));
      await tester.pump();

      expect(find.byType(CallingHeaderBrand), findsOneWidget);
      expect(find.byType(CallingDriverAvatarRings), findsOneWidget);
      expect(find.byType(CallingDriverRoleBadge), findsOneWidget);
      expect(find.byType(CallingActiveAddressCard), findsOneWidget);
      expect(find.byType(CallingActiveControls), findsOneWidget);
      expect(find.byType(CallingActiveEndButton), findsOneWidget);

      expect(find.text('مكالمة جارية'), findsOneWidget);
      expect(find.text('محمد علي'), findsOneWidget);
      expect(find.text('طلب توصيل'), findsOneWidget);
      expect(find.text('كتم الميكروفون'), findsOneWidget);
      expect(find.text('سماعة'), findsOneWidget);
      expect(find.text('إنهاء المكالمة'), findsOneWidget);
    });

    testWidgets('ActiveCallScreen toggles mute and speaker states', (
      tester,
    ) async {
      _setMobileViewSize(tester);

      await tester.pumpWidget(_buildTestApp(const ActiveCallScreen()));
      await tester.pump();

      final muteButton = find.widgetWithText(
        CallingActiveControlButton,
        'كتم الميكروفون',
      );
      final speakerButton = find.widgetWithText(
        CallingActiveControlButton,
        'سماعة',
      );

      expect(muteButton, findsOneWidget);
      expect(speakerButton, findsOneWidget);

      await tester.tap(muteButton);
      await tester.pump();

      await tester.tap(speakerButton);
      await tester.pump();
    });

    testWidgets('ActiveCallScreen end call button pops screen', (tester) async {
      _setMobileViewSize(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  unawaited(
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ActiveCallScreen(),
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ActiveCallScreen), findsOneWidget);

      final endCallButton = find.byType(CallingActiveEndButton);
      expect(endCallButton, findsOneWidget);

      await tester.tap(endCallButton);
      await tester.pumpAndSettle();

      expect(find.byType(ActiveCallScreen), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    });
  });
}
