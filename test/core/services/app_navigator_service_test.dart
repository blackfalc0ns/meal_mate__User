import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';

void main() {
  testWidgets('shows snack bars through the root scaffold messenger key', (
    tester,
  ) async {
    final service = AppNavigatorService();

    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: service.scaffoldMessengerKey,
        home: Scaffold(
          body: TextButton(
            onPressed: () =>
                service.showSnackBar(const SnackBar(content: Text('Saved'))),
            child: const Text('Show'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();

    expect(find.text('Saved'), findsOneWidget);
  });
}
