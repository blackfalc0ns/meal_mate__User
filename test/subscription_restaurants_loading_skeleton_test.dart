import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurant_card_skeleton.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurants_loading_skeleton.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

void main() {
  Widget buildTestableWidget({required Widget child, Size? size}) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: size?.width ?? 390,
            height: size?.height ?? 844,
            child: child,
          ),
        ),
      ),
    );
  }

  group('SubscriptionRestaurantsLoadingSkeleton Tests', () {
    testWidgets('renders all skeleton cards without overflow', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          child: const SingleChildScrollView(
            child: SubscriptionRestaurantsLoadingSkeleton(
              itemCount: 6,
              crossAxisCount: 3,
              childAspectRatio: 0.76,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(SubscriptionRestaurantCardSkeleton), findsNWidgets(6));
      expect(find.byType(ShimmerWidget), findsNWidgets(6));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders properly on small/compact viewport without overflow',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          size: const Size(320, 600),
          child: const SingleChildScrollView(
            child: SubscriptionRestaurantsLoadingSkeleton(
              itemCount: 3,
              crossAxisCount: 3,
              childAspectRatio: 0.76,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SubscriptionRestaurantCardSkeleton), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  });
}
