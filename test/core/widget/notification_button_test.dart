import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';

void main() {
  Widget buildTestWidget({
    required bool hasNotification,
    VoidCallback? onTap,
    Color? iconColor,
    Color? badgeColor,
    Color? badgeBorderColor,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      home: Scaffold(
        body: Center(
          child: NotificationButton(
            hasNotification: hasNotification,
            onTap: onTap,
            iconColor: iconColor,
            badgeColor: badgeColor,
            badgeBorderColor: badgeBorderColor,
          ),
        ),
      ),
    );
  }

  testWidgets('NotificationButton renders and does not show badge when hasNotification is false', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(hasNotification: false));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationButton), findsOneWidget);

    final badgeFinder = find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.shape == BoxShape.circle && decoration.border != null;
      }
      return false;
    });

    expect(badgeFinder, findsNothing);
  });

  testWidgets('NotificationButton renders badge dot when hasNotification is true', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(hasNotification: true));
    await tester.pumpAndSettle();

    final badgeFinder = find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.shape == BoxShape.circle && decoration.border != null;
      }
      return false;
    });

    expect(badgeFinder, findsOneWidget);
  });

  testWidgets('NotificationButton triggers onTap when pressed', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        hasNotification: true,
        onTap: () => pressed = true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NotificationButton));
    await tester.pump();

    expect(pressed, isTrue);
  });
}
