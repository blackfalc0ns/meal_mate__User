import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_generator.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';

void main() {
  testWidgets('loading preview route displays the custom progress indicator', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRoutes.loadingPreview,
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
    await tester.pump();

    expect(find.byType(CustomProgressIndicator), findsOneWidget);
  });
}
