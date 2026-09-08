import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMealSelectionBottomBar extends StatelessWidget {
  const FamilyMealSelectionBottomBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.slotAndDateLabel,
    required this.onContinue,
  });

  final int selectedCount;
  final int totalCount;
  final String slotAndDateLabel;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border(
          top: BorderSide(color: color.outlineVariant),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: Spacing.xs,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.family_meal_selected_counter(selectedCount, totalCount),
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs / 2),
                  Text(
                    slotAndDateLabel,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.md),
            FilledButton(
              onPressed: onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: color.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg,
                  vertical: Spacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
              ),
              child: Text(
                locale.family_meal_continue_review,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
