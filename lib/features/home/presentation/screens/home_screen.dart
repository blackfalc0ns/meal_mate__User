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
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: Spacing.homeTopStackHeight,
              child: Stack(
                children: [
                  const HomeHeader(),
                  const PositionedDirectional(
                    top: Spacing.homeSubscriptionCardTop,
                    start: Spacing.screenH,
                    end: Spacing.screenH,
                    child: HomeSubscriptionCard(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
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
          ),
          SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),
          SliverToBoxAdapter(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: HomeTodayMeals(title: locale.home_today_meals),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: Spacing.sm)),
          SliverToBoxAdapter(
            child: HomeRestaurantsSection(title: locale.home_restaurants),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),
          SliverToBoxAdapter(
            child: HomeDeliveryCards(
              calendarLabel: locale.home_view_calendar,
              nextBoxLabel: locale.home_next_box,
              detailsLabel: locale.home_details,
              deliveryTime: locale.home_delivery_time,
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: Spacing.base)),
          SliverToBoxAdapter(
            child: HomeReminderCard(
              editLabel: locale.home_edit_meals,
              title: locale.home_next_week_meals,
              reminder: locale.home_reminder,
              subtitle: locale.home_reminder_copy,
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: Spacing.xxxl)),
        ],
      ),
    );
  }
}
