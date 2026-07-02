import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/subscriptions/data/subscriptions_fake_data_source.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/screens/subscription_plan_details_screen.dart';
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
    final plans = _dataSource.getPlans();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomAppBar(
              showBackButton: false,
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
                height: Spacing.subscriptionPlansHeight,
                child: ListView.separated(
                  // padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
                  scrollDirection: Axis.horizontal,
                  itemCount: plans.length,
                  separatorBuilder: (_, _) => const SizedBox(width: Spacing.md),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return _AnimatedPlanDetailsOpener(
                      onOpen: () => setState(() => _selectedPlanIndex = index),
                      child: SubscriptionPlanCard(
                        plan: plan,
                        isSelected: index == _selectedPlanIndex,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: Spacing.base)),
          SliverToBoxAdapter(
            child: SubscriptionInfoNote(
              text: l10n.subscription_note,
              highlightedText: l10n.subscription_discount_20,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: widget.showBottomSpace ? 118 : Spacing.xl),
          ),
        ],
      ),
    );
  }
}

class _AnimatedPlanDetailsOpener extends StatelessWidget {
  const _AnimatedPlanDetailsOpener({required this.child, required this.onOpen});

  final Widget child;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: OpenContainer<void>(
            closedElevation: 0,
            openElevation: 0,
            closedColor: Colors.transparent,
            middleColor: Colors.transparent,
            openColor: context.colorScheme.surface,
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusLg),
            ),
            transitionDuration: const Duration(milliseconds: 700),
            transitionType: ContainerTransitionType.fade,
            tappable: false,
            openBuilder: (context, _) => const SubscriptionPlanDetailsScreen(),
            closedBuilder: (context, openContainer) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(Spacing.radiusLg),
                  onTap: () {
                    onOpen();
                    openContainer();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
