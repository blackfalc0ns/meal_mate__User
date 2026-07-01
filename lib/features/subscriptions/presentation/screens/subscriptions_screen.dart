import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/subscriptions/data/subscriptions_fake_data_source.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_info_note.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_plan_card.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscriptions_hero_card.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscriptions_section_title.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key, this.showBottomSpace = false});

  final bool showBottomSpace;

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  static const _dataSource = SubscriptionsFakeDataSource();
  int _selectedPlanIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final plans = _dataSource.getPlans(l10n);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: l10n.subscription_screen_title,
              actions: [NotificationButton(onTap: () {})],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              child: SubscriptionsHeroCard(
                title: l10n.subscription_hero_title,
                subtitle: l10n.subscription_hero_subtitle,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SubscriptionsSectionTitle(
              title: l10n.subscription_choose_plan_title,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              child: SizedBox(
                height: 284,
                child: ListView.separated(
                
                // padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
                  scrollDirection: Axis.horizontal,
                  itemCount: plans.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return SubscriptionPlanCard(
                      plan: plan,
                      isSelected: index == _selectedPlanIndex,
                      onTap: () => setState(() => _selectedPlanIndex = index),
                    );
                  },
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: SubscriptionInfoNote(
              text: l10n.subscription_note,
              highlightedText: l10n.subscription_discount_20,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: widget.showBottomSpace ? 118 : 28),
          ),
        ],
      ),
    );
  }
}
