import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/delivery_preference_tile.dart';

class DeliveryPreferencesCard extends StatelessWidget {
  const DeliveryPreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.addressesPreferenceCardHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.addressesCardContentPadding,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.addressesCardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.07),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          DeliveryPreferenceTile(
            icon: Icons.notifications_rounded,
            title: locale.addresses_contact_on_arrival,
            description: locale.addresses_contact_on_arrival_description,
          ),
          Divider(height: Spacing.hairline, color: color.outlineVariant),
          DeliveryPreferenceTile(
            icon: Icons.shopping_bag_rounded,
            title: locale.addresses_leave_at_door,
            description: locale.addresses_leave_at_door_description,
          ),
        ],
      ),
    );
  }
}
