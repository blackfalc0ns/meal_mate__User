import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilySummaryInfoRow extends StatelessWidget {
  const FamilySummaryInfoRow({super.key, required this.row});

  final FamilySelectionSummaryRowData row;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        Divider(height: Spacing.border, color: color.outlineVariant),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
          child: Row(
            children: [
              Icon(
                _icon,
                color: color.primary,
                size: Spacing.iconSm,
                semanticLabel: locale.family_subscription_summary,
              ),
              const SizedBox(width: Spacing.sm),

              Text(
                row.label,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurface,
                ),
              ),

              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  row.value,
                  textAlign: TextAlign.end,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData get _icon {
    return switch (row.icon) {
      FamilySelectionSummaryIcon.balance => Icons.balance_rounded,
      FamilySelectionSummaryIcon.cutlery => Icons.restaurant_rounded,
      FamilySelectionSummaryIcon.calendar => Icons.calendar_month_rounded,
      FamilySelectionSummaryIcon.check => Icons.check_circle_rounded,
      FamilySelectionSummaryIcon.receipt => Icons.receipt_rounded,
    };
  }
}

typedef FamilyPaymentSummaryRow = FamilySummaryInfoRow;
