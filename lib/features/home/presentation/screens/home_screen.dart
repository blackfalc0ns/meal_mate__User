import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_delivery_cards.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_header.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_promotion_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_reminder_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_restaurants_section.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_search_field.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_shortcuts.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_today_meals.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Container(
      color: color.surface,
      child: ListView(
        padding: const EdgeInsets.only(bottom: Spacing.xxxl),
        children: [
          SizedBox(
            height: Spacing.homeTopStackHeight,
            child: Stack(
              children: [
                const HomeHeader(),
                const PositionedDirectional(
                  top: Spacing.homeSubscriptionCardTop,
                  start: Spacing.homeHorizontalPadding,
                  end: Spacing.homeHorizontalPadding,
                  child: HomeSubscriptionCard(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.homeHorizontalPadding,
            ),
            child: Column(
              children: [
                const SizedBox(height: Spacing.base),
                const HomeSearchField(),
                const SizedBox(height: Spacing.base),
                const HomePromotionCard(),
                const SizedBox(height: Spacing.base),
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
    );
  }
}
