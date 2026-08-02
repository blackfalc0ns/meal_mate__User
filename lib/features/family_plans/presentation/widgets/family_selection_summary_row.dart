import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_selection_summary_icon.dart';

class FamilySelectionSummaryRow extends StatelessWidget {
  const FamilySelectionSummaryRow({super.key, required this.row});

  final FamilySelectionSummaryRowFakeData row;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        children: [
          FamilySelectionSummaryIconView(icon: row.icon),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              row.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            row.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: row.isPrice
                ? getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  )
                : getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ),
          ),
        ],
      ),
    );
  }
}
