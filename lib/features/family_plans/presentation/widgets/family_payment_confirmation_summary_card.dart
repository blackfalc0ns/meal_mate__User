import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_summary_row.dart';

class FamilyPaymentConfirmationSummaryCard extends StatelessWidget {
  const FamilyPaymentConfirmationSummaryCard({
    super.key,
    required this.member,
    required this.summary,
  });

  final FamilyProgramMemberDetailsUiModel member;
  final FamilySelectionSummaryData summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familySetupMemberCardRadius,
        ),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.asset(
                  member.imageAsset,
                  width: Spacing.familyProgramSummaryAvatarSize,
                  height: Spacing.familyProgramSummaryAvatarSize,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: Spacing.md),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group_rounded,
                        color: color.primary,
                        size: Spacing.iconSm,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        locale.family_primary_member,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size9,
                          color: color.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    summary.title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          for (final row in summary.rows) FamilyPaymentSummaryRow(row: row),
        ],
      ),
    );
  }
}
