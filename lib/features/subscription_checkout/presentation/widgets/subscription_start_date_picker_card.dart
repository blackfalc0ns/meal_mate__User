import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionStartDatePickerCard extends StatelessWidget {
  const SubscriptionStartDatePickerCard({
    super.key,
    required this.selectedStartDate,
    required this.onPressed,
  });

  final String selectedStartDate;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      button: true,
      label:
          '${locale.subscription_start_date_picker_label}: $selectedStartDate',
      child: Material(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.subscriptionSummaryCardRadius,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            Spacing.subscriptionSummaryCardRadius,
          ),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.subscriptionSummaryCardBorder,
              ),
              borderRadius: BorderRadius.circular(
                Spacing.subscriptionSummaryCardRadius,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: color.primary,
                  size: Spacing.iconMd,
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.subscription_start_date_picker_label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ).copyWith(height: FontSize.size18 / FontSize.size14),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        selectedStartDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size16,
                          color: color.primary,
                        ).copyWith(height: FontSize.size22 / FontSize.size16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Icon(
                  Icons.edit_calendar_rounded,
                  color: color.onSurfaceVariant,
                  size: Spacing.iconMd,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
