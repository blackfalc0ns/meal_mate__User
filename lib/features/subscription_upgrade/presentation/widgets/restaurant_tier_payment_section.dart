import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_payment_method_tile.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_section_card.dart';

class RestaurantTierPaymentSection extends StatelessWidget {
  const RestaurantTierPaymentSection({
    super.key,
    required this.title,
    required this.paymentMethods,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodSelected,
  });

  final String title;
  final List<SubscriptionUpgradePaymentMethodEntity> paymentMethods;
  final SubscriptionUpgradePaymentMethodEntity? selectedPaymentMethod;
  final ValueChanged<SubscriptionUpgradePaymentMethodEntity>
  onPaymentMethodSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ColoredBox(
      color: color.surface,
      child: RestaurantTierSectionCard(
        title: title,
        icon: Icons.credit_card_rounded,
        child: Semantics(
          label: locale.profile_billing,
          child: Column(
            children: [
              for (var index = 0; index < paymentMethods.length; index++) ...[
                RestaurantTierPaymentMethodTile(
                  paymentMethod: paymentMethods[index],
                  isSelected:
                      selectedPaymentMethod?.id == paymentMethods[index].id,
                  onTap: () => onPaymentMethodSelected(paymentMethods[index]),
                ),
                if (index < paymentMethods.length - 1)
                  const SizedBox(height: Spacing.sm),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
