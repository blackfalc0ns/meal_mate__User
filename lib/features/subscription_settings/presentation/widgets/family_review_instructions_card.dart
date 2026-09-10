import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyReviewInstructionsCard extends StatelessWidget {
  const FamilyReviewInstructionsCard({
    super.key,
    required this.instructions,
    required this.note,
  });

  final List<String> instructions;
  final String note;

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
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.xs,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                locale.family_review_member_instructions_section,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          if (instructions.isNotEmpty)
            Wrap(
              spacing: Spacing.xs,
              runSpacing: Spacing.xs / 2,
              children: instructions.map((instruction) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: Spacing.iconXs * 0.8,
                        color: color.primary,
                      ),
                      const SizedBox(width: Spacing.xs / 2),
                      Text(
                        instruction,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size9,
                          color: color.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: Spacing.xs),
          Text(
            note,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
