import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_summary_card.dart';

Widget _buildTestApp({
  required Widget child,
  Locale locale = const Locale('ar'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('CalendarRating presentation', () {
    testWidgets('shows rating and star when rating is present and count > 0', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const CalendarRating(value: '4.8', ratingCount: 25),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('4.8'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      expect(find.text('لا توجد تقييمات'), findsNothing);
    });

    testWidgets('shows localized no-reviews text without star when rating is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const CalendarRating(value: null, ratingCount: 0),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('لا توجد تقييمات'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsNothing);
    });

    testWidgets('shows localized no-reviews text when ratingCount is 0 even if value is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const CalendarRating(value: '4.5', ratingCount: 0),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('لا توجد تقييمات'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsNothing);
    });

    testWidgets('shows English localized no-reviews text in en locale', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('en'),
          child: const CalendarRating(value: null, ratingCount: 0),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No reviews yet'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsNothing);
    });
  });

  group('CalendarRestaurantTextBlock presentation', () {
    testWidgets('shows rating, star and count when rating and count are valid', (
      tester,
    ) async {
      const restaurant = CalendarRestaurantEntity(
        id: 'r-1',
        name: 'Diet Care',
        category: 'Healthy',
        rating: '4.8',
        ratingCount: 50,
        deliveryDuration: 'Standard',
        deliveryWindow: '12:00 - 13:00',
      );

      await tester.pumpWidget(
        _buildTestApp(
          child: const CalendarRestaurantTextBlock(restaurant: restaurant),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Diet Care'), findsOneWidget);
      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('(50)'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      expect(find.text('لا توجد تقييمات'), findsNothing);
    });

    testWidgets('shows localized no-reviews text without star or fake (1.230) when rating is null', (
      tester,
    ) async {
      const restaurant = CalendarRestaurantEntity(
        id: 'r-1',
        name: 'Diet Care',
        category: 'Healthy',
        rating: null,
        ratingCount: 0,
        deliveryDuration: 'Standard',
        deliveryWindow: '12:00 - 13:00',
      );

      await tester.pumpWidget(
        _buildTestApp(
          child: const CalendarRestaurantTextBlock(restaurant: restaurant),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Diet Care'), findsOneWidget);
      expect(find.text('لا توجد تقييمات'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsNothing);
      expect(find.text('(1.230)'), findsNothing);
      expect(find.text('4.8'), findsNothing);
    });
  });
}
