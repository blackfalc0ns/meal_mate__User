import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_countdown.dart';

void main() {
  Widget buildTestableWidget({
    required DateTime retryAvailableAtUtc,
    required VoidCallback onResend,
    required bool isResending,
    DateTime Function()? now,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: Center(
          child: AuthOtpCountdown(
            retryAvailableAtUtc: retryAvailableAtUtc,
            onResend: onResend,
            isResending: isResending,
            now: now ?? DateTime.now,
          ),
        ),
      ),
    );
  }

  testWidgets('AuthOtpCountdown shows remaining seconds and counts down to 0', (
    tester,
  ) async {
    var currentTime = DateTime.utc(2026, 10, 7, 12, 0, 0);
    final retryAt = currentTime.add(const Duration(seconds: 3));
    var resendCallCount = 0;

    await tester.pumpWidget(
      buildTestableWidget(
        retryAvailableAtUtc: retryAt,
        onResend: () => resendCallCount++,
        isResending: false,
        now: () => currentTime,
      ),
    );
    await tester.pump();

    // Initially countdown should show remaining seconds
    expect(find.textContaining('Resend code in'), findsOneWidget);

    // Tapping while counting down should not trigger onResend
    await tester.tap(find.textContaining('Resend code in'));
    expect(resendCallCount, 0);

    // Advance 4 seconds
    currentTime = currentTime.add(const Duration(seconds: 4));
    await tester.pump(const Duration(seconds: 1));

    // Now it should display Resend code and be tappable
    expect(find.text('Resend code'), findsOneWidget);
    await tester.tap(find.text('Resend code'));
    expect(resendCallCount, 1);
  });

  testWidgets(
    'AuthOtpCountdown does not allow resend while isResending is true',
    (tester) async {
      final past = DateTime.now().toUtc().subtract(const Duration(seconds: 5));
      var resendCallCount = 0;

      await tester.pumpWidget(
        buildTestableWidget(
          retryAvailableAtUtc: past,
          onResend: () => resendCallCount++,
          isResending: true,
        ),
      );
      await tester.pump();

      // When isResending is true, tapping should not call onResend
      await tester.tap(find.byType(AuthOtpCountdown));
      expect(resendCallCount, 0);
    },
  );

  testWidgets(
    'AuthOtpCountdown resets timer when didUpdateWidget receives new deadline',
    (tester) async {
      final past = DateTime.now().toUtc().subtract(const Duration(seconds: 1));
      var resendCallCount = 0;

      await tester.pumpWidget(
        buildTestableWidget(
          retryAvailableAtUtc: past,
          onResend: () => resendCallCount++,
          isResending: false,
        ),
      );
      await tester.pump();
      expect(find.text('Resend code'), findsOneWidget);

      // Update with new future deadline
      final newDeadline = DateTime.now().toUtc().add(
        const Duration(seconds: 10),
      );
      await tester.pumpWidget(
        buildTestableWidget(
          retryAvailableAtUtc: newDeadline,
          onResend: () => resendCallCount++,
          isResending: false,
        ),
      );
      await tester.pump();

      expect(find.textContaining('Resend code in'), findsOneWidget);
      await tester.tap(find.textContaining('Resend code in'));
      expect(resendCallCount, 0);
    },
  );
}
