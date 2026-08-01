import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_cta.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_metrics.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_plan_info.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_progress_ring.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_segment_tab.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_summary_card.dart';

class HomeSubscriptionCard extends StatefulWidget {
  const HomeSubscriptionCard({super.key});

  @override
  State<HomeSubscriptionCard> createState() => _HomeSubscriptionCardState();
}

class _HomeSubscriptionCardState extends State<HomeSubscriptionCard> {
  HomeSubscriptionSegmentTabType _selectedTab =
      HomeSubscriptionSegmentTabType.subscription;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Semantics(
      label: locale.home_subscription_details,
      child: SizedBox(
        width: double.infinity,
        height: Spacing.homeSubscriptionCardHeight,
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: AlignmentDirectional.topStart,
          child: SizedBox(
            width: Spacing.homeSubscriptionCardWidth,
            height: Spacing.homeSubscriptionCardHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(
                        Spacing.homeSubscriptionCardRadius,
                      ),
                      border: Border.all(
                        color: color.outlineVariant,
                        width: Spacing.homeSubscriptionCardBorder,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: Spacing.homeSubscriptionSegmentTop,
                  start: Spacing.homeSubscriptionSegmentStart,
                  end: Spacing.homeSubscriptionSegmentEnd,
                  child: Container(
                    height: Spacing.homeSubscriptionSegmentHeight,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(
                        Spacing.homeSubscriptionSegmentRadius,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: HomeSubscriptionSegmentTab(
                            type: HomeSubscriptionSegmentTabType.subscription,
                            isSelected:
                                _selectedTab ==
                                HomeSubscriptionSegmentTabType.subscription,
                            onTap: () => setState(
                              () => _selectedTab =
                                  HomeSubscriptionSegmentTabType.subscription,
                            ),
                          ),
                        ),
                        Expanded(
                          child: HomeSubscriptionSegmentTab(
                            type: HomeSubscriptionSegmentTabType.nutrition,
                            isSelected:
                                _selectedTab ==
                                HomeSubscriptionSegmentTabType.nutrition,
                            onTap: () => setState(
                              () => _selectedTab =
                                  HomeSubscriptionSegmentTabType.nutrition,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const PositionedDirectional(
                  top: Spacing.homeSubscriptionPlanTop,
                  start: Spacing.homeSubscriptionPlanStart,
                  child: HomeSubscriptionPlanInfo(),
                ),
                const PositionedDirectional(
                  top: Spacing.homeSubscriptionProgressTop,
                  start: Spacing.homeSubscriptionProgressStart,
                  child: HomeSubscriptionProgressRing(),
                ),
                const PositionedDirectional(
                  top: Spacing.homeSubscriptionMetricsTop,
                  start: Spacing.homeSubscriptionMetricsStart,
                  child: HomeSubscriptionMetrics(),
                ),
                const PositionedDirectional(
                  top: Spacing.homeSubscriptionSummaryTop,
                  start: Spacing.homeSubscriptionSummaryStart,
                  child: HomeSubscriptionSummaryCard(),
                ),
                const PositionedDirectional(
                  top: Spacing.homeSubscriptionCtaTop,
                  start: Spacing.homeSubscriptionCtaStart,
                  child: HomeSubscriptionCta(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
