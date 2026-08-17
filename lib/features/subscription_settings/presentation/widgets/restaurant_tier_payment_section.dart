import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_payment_method_tile.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_section_card.dart';

class RestaurantTierPaymentSection extends StatelessWidget {
  const RestaurantTierPaymentSection({super.key, required this.data});

  final RestaurantTierUpgradeEntity data;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ColoredBox(
      color: color.surface,
      child: RestaurantTierSectionCard(
        title: data.paymentTitle,
        icon: Icons.credit_card_rounded,
        child: Semantics(
          label: locale.profile_billing,
          child: RestaurantTierPaymentMethodTile(payment: data.paymentMethod),
        ),
      ),
    );
  }
}
