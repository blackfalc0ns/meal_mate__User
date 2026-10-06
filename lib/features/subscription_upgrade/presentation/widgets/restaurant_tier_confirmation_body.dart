import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_details_section.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_entry_animation.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_payment_selection_section.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_quick_comparison_section.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_submission_overlay.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_submission_section.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_hero_card.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_summary_section.dart';

class RestaurantTierConfirmationBody extends StatelessWidget {
  const RestaurantTierConfirmationBody({
    super.key,
    required this.optionsEntity,
    required this.selectedOption,
    this.programName,
    required this.onPaymentMethodSelected,
    required this.onConfirm,
    required this.onBack,
  });

  final SubscriptionUpgradeOptionsEntity optionsEntity;
  final SubscriptionUpgradeOptionEntity selectedOption;
  final String? programName;
  final ValueChanged<SubscriptionUpgradePaymentMethodEntity>
      onPaymentMethodSelected;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return RestaurantTierEntryAnimation(
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenH,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      const SizedBox(height: Spacing.lg),
                      RestaurantTierEntryAnimation(
                        child: RestaurantTierUpgradeHeroCard(
                          optionsEntity: optionsEntity,
                          selectedOption: selectedOption,
                          programName: programName,
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                      RestaurantTierEntryAnimation(
                        delay: const Duration(milliseconds: 60),
                        child: RestaurantTierQuickComparisonSection(
                          optionsEntity: optionsEntity,
                          selectedOption: selectedOption,
                        ),
                      ),
                      BlocSelector<
                        RestaurantTierUpgradeViewModel,
                        RestaurantTierUpgradeState,
                        SubscriptionUpgradeSummaryEntity?
                      >(
                        selector: (state) => state.upgradeSummary,
                        builder: (context, summary) {
                          if (summary == null) return const SizedBox.shrink();
                          return RestaurantTierEntryAnimation(
                            delay: const Duration(milliseconds: 120),
                            child: Column(
                              children: [
                                const SizedBox(height: Spacing.lg),
                                RestaurantTierUpgradeSummarySection(
                                  summary: summary,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: Spacing.lg),
                      BlocSelector<
                        RestaurantTierUpgradeViewModel,
                        RestaurantTierUpgradeState,
                        SubscriptionUpgradeSummaryEntity?
                      >(
                        selector: (state) => state.upgradeSummary,
                        builder: (context, summary) {
                          return RestaurantTierEntryAnimation(
                            delay: const Duration(milliseconds: 180),
                            child: RestaurantTierDetailsSection(
                              selectedOption: selectedOption,
                              summary: summary,
                            ),
                          );
                        },
                      ),
                      RestaurantTierEntryAnimation(
                        delay: const Duration(milliseconds: 240),
                        child: RestaurantTierPaymentSelectionSection(
                          onPaymentMethodSelected: onPaymentMethodSelected,
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                      RestaurantTierEntryAnimation(
                        delay: const Duration(milliseconds: 300),
                        child: RestaurantTierSubmissionSection(
                          confirmLabel: locale.restaurant_tier_confirm_and_pay,
                          backLabel: locale.restaurant_tier_back_action,
                          onConfirm: onConfirm,
                          onBack: onBack,
                        ),
                      ),
                      SizedBox(
                        height:
                            MediaQuery.paddingOf(context).bottom + Spacing.xl,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            const RestaurantTierSubmissionOverlay(),
          ],
        ),
      ),
    );
  }
}
