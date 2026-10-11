import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_generator.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_restaurants_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_meal_selection_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_review_member_meals_args.dart';

void main() {
  test('family calendar route carries the member subscription id', () {
    const settings = RouteSettings(
      name: AppRoutes.familyMemberDailyMeals,
      arguments: 'member-subscription-1',
    );

    final route = RouteGenerator.getRoute(settings);

    expect(route.settings.name, AppRoutes.familyMemberDailyMeals);
    expect(route.settings.arguments, 'member-subscription-1');
  });

  test('family calendar route accepts FamilyMemberCalendarArgs', () {
    const args = FamilyMemberCalendarArgs(
      memberId: 'm-1',
      displayName: 'أحمد',
      subscriptionId: 'sub-1',
    );
    const settings = RouteSettings(
      name: AppRoutes.familyMemberDailyMeals,
      arguments: args,
    );

    final route = RouteGenerator.getRoute(settings);

    expect(route.settings.name, AppRoutes.familyMemberDailyMeals);
    expect(route.settings.arguments, isA<FamilyMemberCalendarArgs>());
  });

  test('family day details route accepts FamilyDayMealsArgs', () {
    final args = FamilyDayMealsArgs(
      subscriptionId: 'sub-1',
      date: DateTime(2026, 9, 8),
      memberName: 'أحمد',
    );
    final settings = RouteSettings(
      name: AppRoutes.familyMemberDayDetails,
      arguments: args,
    );

    final route = RouteGenerator.getRoute(settings);

    expect(route.settings.name, AppRoutes.familyMemberDayDetails);
    expect(route.settings.arguments, isA<FamilyDayMealsArgs>());
  });

  test('family calendar route handles missing subscription context safely', () {
    const settings = RouteSettings(name: AppRoutes.familyMemberDailyMeals);

    final route = RouteGenerator.getRoute(settings);

    expect(route.settings.name, AppRoutes.familyMemberDailyMeals);
    expect(route.settings.arguments, isNull);
  });

  test(
    'family restaurants route accepts FamilyRestaurantsArgs and routes correctly',
    () {
      final args = FamilyRestaurantsArgs(
        subscriptionId: 'sub-1',
        date: DateTime(2026, 9, 8),
        memberName: 'أحمد',
      );
      final settings = RouteSettings(
        name: AppRoutes.familyRestaurants,
        arguments: args,
      );

      final route = RouteGenerator.getRoute(settings);

      expect(route.settings.name, AppRoutes.familyRestaurants);
      expect(route.settings.arguments, isA<FamilyRestaurantsArgs>());
    },
  );

  test(
    'family meal selection route accepts FamilyMealSelectionArgs and routes correctly',
    () {
      final args = FamilyMealSelectionArgs(
        subscriptionId: 'sub-1',
        date: DateTime(2026, 9, 8),
        memberName: 'أحمد',
      );
      final settings = RouteSettings(
        name: AppRoutes.familyMealSelection,
        arguments: args,
      );

      final route = RouteGenerator.getRoute(settings);

      expect(route.settings.name, AppRoutes.familyMealSelection);
      expect(route.settings.arguments, isA<FamilyMealSelectionArgs>());
    },
  );

  test(
    'family review meals route accepts FamilyReviewMemberMealsArgs and routes correctly',
    () {
      final args = FamilyReviewMemberMealsArgs(
        subscriptionId: 'sub-1',
        date: DateTime(2026, 9, 8),
        memberName: 'أحمد',
      );
      final settings = RouteSettings(
        name: AppRoutes.familyReviewMemberMeals,
        arguments: args,
      );

      final route = RouteGenerator.getRoute(settings);

      expect(route.settings.name, AppRoutes.familyReviewMemberMeals);
      expect(route.settings.arguments, isA<FamilyReviewMemberMealsArgs>());
    },
  );
}
