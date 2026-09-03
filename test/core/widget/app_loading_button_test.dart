import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/widget/app_loading_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

void main() {
  testWidgets('AppLoadingButton renders text and triggers onPressed', (
    tester,
  ) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: AppLoadingButton(
              text: 'Save',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(pressed, isTrue);
  });

  testWidgets('AppLoadingButton works with custom controller', (tester) async {
    final controller = RoundedLoadingButtonController();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: AppLoadingButton(
              text: 'Submit',
              controller: controller,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Submit'), findsOneWidget);
  });
}
