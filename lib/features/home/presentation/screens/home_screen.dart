import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_delivery_cards.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_header.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_nutrition_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_promotion_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_reminder_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_restaurants_section.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_shortcuts.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_today_meals.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: color.primaryContainer,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: color.surface,
          child: ListView(
            padding: const EdgeInsets.only(bottom: Spacing.xxxl),
            children: [
              const HomeHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.homeHorizontalPadding,
                ),
                child: Column(
                  children: [
                    HomeNutritionCard(
                      title: locale.home_main_nutrients,
                      calories: locale.home_remaining_calories_value,
                      remainingLabel: locale.home_remaining_calories,
                      goalLabel: locale.home_calories_of_goal,
                      detailsLabel: locale.home_details,
                    ),
                    const SizedBox(height: Spacing.md),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: locale.home_search_hint,
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    HomePromotionCard(buttonLabel: locale.home_subscribe_now),
                    const SizedBox(height: Spacing.md),
                    const HomeShortcuts(),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.lg),
              HomeTodayMeals(title: locale.home_today_meals),
              const SizedBox(height: Spacing.lg),
              HomeRestaurantsSection(title: locale.home_restaurants),
              const SizedBox(height: Spacing.lg),
              HomeDeliveryCards(
                calendarLabel: locale.home_view_calendar,
                nextBoxLabel: locale.home_next_box,
                detailsLabel: locale.home_details,
                deliveryTime: locale.home_delivery_time,
              ),
              const SizedBox(height: Spacing.base),
              HomeReminderCard(
                editLabel: locale.home_edit_meals,
                title: locale.home_next_week_meals,
                reminder: locale.home_reminder,
                subtitle: locale.home_reminder_copy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
