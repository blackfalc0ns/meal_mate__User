import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Single key-value row with optional divider for the subscription summary card.
class SubscriptionSuccessSummaryItemRow extends StatelessWidget {
  const SubscriptionSuccessSummaryItemRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final IconData? icon;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: Spacing.xl,
                  height: Spacing.xl,
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Spacing.xs),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: Spacing.iconSm, color: color.primary),
                ),
                const SizedBox(width: Spacing.xs),
              ],
              Text(
                label,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                value,
                textAlign: TextAlign.end,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: color.outlineVariant,
            height: Spacing.xs,
            thickness: Spacing.hairline,
          ),
      ],
    );
  }
}
