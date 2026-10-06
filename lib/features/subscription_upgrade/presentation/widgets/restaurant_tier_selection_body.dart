import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_current_subscription_card.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_entry_animation.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_options_section.dart';

class RestaurantTierSelectionBody extends StatelessWidget {
  const RestaurantTierSelectionBody({
    super.key,
    required this.optionsEntity,
    this.bundleName,
    required this.onOptionSelected,
  });

  final SubscriptionUpgradeOptionsEntity optionsEntity;
  final String? bundleName;
  final ValueChanged<SubscriptionUpgradeOptionEntity> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return RestaurantTierEntryAnimation(
      child: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  RestaurantTierEntryAnimation(
                    child: RestaurantTierCurrentSubscriptionCard(
                      optionsEntity: optionsEntity,
                      bundleName: bundleName,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  RestaurantTierEntryAnimation(
                    delay: const Duration(milliseconds: 100),
                    child: RestaurantTierOptionsSection(
                      onOptionSelected: onOptionSelected,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.paddingOf(context).bottom + Spacing.xxxl,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
