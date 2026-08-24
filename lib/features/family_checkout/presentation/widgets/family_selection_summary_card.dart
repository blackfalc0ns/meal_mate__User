import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_selection_summary_row.dart';

class FamilySelectionSummaryCard extends StatelessWidget {
  const FamilySelectionSummaryCard({super.key, required this.summary});

  final FamilySelectionSummaryData summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: 0.20),
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.md),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                color: color.primary,
                size: Spacing.iconSm,
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  summary.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Divider(color: color.outlineVariant, height: Spacing.border),
          ...summary.rows.map((row) => FamilySelectionSummaryRow(row: row)),
        ],
      ),
    );
  }
}
