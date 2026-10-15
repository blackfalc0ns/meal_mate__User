import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyReviewActionsBar extends StatelessWidget {
  const FamilyReviewActionsBar({
    super.key,
    required this.memberName,
    this.onEdit,
    this.onConfirm,
    this.isLoading = false,
  });

  final String memberName;
  final VoidCallback? onEdit;
  final VoidCallback? onConfirm;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border(top: BorderSide(color: color.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: Spacing.xs,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppButton.filled(
              text: locale.family_review_confirm_meals_button(memberName),
              onPressed: isLoading ? null : onConfirm,
              isLoading: isLoading,
              color: color.primary,
              fontSize: FontSize.size12,
              borderRadius: Spacing.radiusPill,
              height: Spacing.buttonHeight,
            ),
          ),

          const SizedBox(width: Spacing.sm),

          Expanded(
            flex: 2,
            child: AppButton.outlined(
              text: locale.family_review_edit_meals_button,
              onPressed: isLoading ? null : onEdit,
              color: color.primary,
              textColor: color.primary,
              fontSize: FontSize.size12,
              borderRadius: Spacing.radiusPill,
              height: Spacing.buttonHeight,
            ),
          ),
        ],
      ),
    );
  }
}
