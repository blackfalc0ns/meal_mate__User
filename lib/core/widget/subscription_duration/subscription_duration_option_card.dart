import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionDurationOptionCard extends StatelessWidget {
  const SubscriptionDurationOptionCard({
    super.key,
    required this.label,
    required this.duration,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String duration;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${locale.subscription_choose_plan_title} $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: Spacing.xxxl - Spacing.xs,
          decoration: BoxDecoration(
            color: isSelected ? color.primary : color.surface,
            border: Border.all(
              color: isSelected ? color.primary : color.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                duration,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: isSelected ? color.onPrimary : color.onSurface,
                ),
              ),
              Text(
                label,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: isSelected ? color.onPrimary : color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
