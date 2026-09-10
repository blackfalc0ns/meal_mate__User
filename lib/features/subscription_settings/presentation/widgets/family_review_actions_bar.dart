import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyReviewActionsBar extends StatelessWidget {
  const FamilyReviewActionsBar({
    super.key,
    required this.memberName,
    required this.onEdit,
    required this.onConfirm,
    this.isLoading = false,
  });

  final String memberName;
  final VoidCallback onEdit;
  final VoidCallback onConfirm;
  final bool isLoading;

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
            OutlinedButton(
              onPressed: isLoading ? null : onEdit,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, Spacing.buttonHeight),
                side: BorderSide(color: color.outline),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg,
                  vertical: Spacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
              ),
              child: Text(
                locale.family_review_edit_meals_button,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: FilledButton(
                onPressed: isLoading ? null : onConfirm,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, Spacing.buttonHeight),
                  backgroundColor: color.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: Spacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: Spacing.iconSm,
                        width: Spacing.iconSm,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color.onPrimary,
                        ),
                      )
                    : Text(
                        locale.family_review_confirm_meals_button(memberName),
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
