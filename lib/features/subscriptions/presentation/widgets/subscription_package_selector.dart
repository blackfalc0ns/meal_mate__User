import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_package_selector_option.dart';

class SubscriptionPackageSelector extends StatelessWidget {
  const SubscriptionPackageSelector({
    super.key,
    required this.isFamilySelected,
    required this.onChanged,
  });

  final bool isFamilySelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.subscriptionPackageSelectorHeight,
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: SubscriptionPackageSelectorOption(
              icon: Icons.person,
              label: locale.subscription_individual_packages,
              selected: !isFamilySelected,
              onTap: () => onChanged(false),
            ),
          ),
          VerticalDivider(
            color: color.outlineVariant,
            thickness: Spacing.hairline,
            width: Spacing.border,
            indent: Spacing.sm,
            endIndent: Spacing.sm,
          ),
          Expanded(
            child: SubscriptionPackageSelectorOption(
              icon: Icons.groups,
              label: locale.subscription_family_packages,
              selected: isFamilySelected,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}
