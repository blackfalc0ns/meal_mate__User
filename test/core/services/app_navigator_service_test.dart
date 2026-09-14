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

  testWidgets('replaces the navigation stack when the session expires', (
    tester,
  ) async {
    final service = AppNavigatorService();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: service.navigatorKey,
        initialRoute: '/protected',
        routes: {
          '/protected': (_) => const Scaffold(body: Text('Protected')),
          '/details': (_) => const Scaffold(body: Text('Details')),
          '/login': (_) => const Scaffold(body: Text('Login')),
        },
      ),
    );
    service.navigator!.pushNamed('/details');
    await tester.pumpAndSettle();

    await service.replaceAllWithNamedWhenReady('/login');
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(service.navigator!.canPop(), isFalse);
  });
}
