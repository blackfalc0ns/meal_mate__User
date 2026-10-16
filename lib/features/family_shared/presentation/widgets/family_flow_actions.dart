import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyFlowActions extends StatelessWidget {
  const FamilyFlowActions({
    super.key,
    this.secondaryText,
    this.secondaryIcon,
    this.secondaryIconWidget,
    this.onSecondaryPressed,
    this.isSecondaryLoading = false,
    this.secondaryFlex = 1,
    this.primaryText,
    this.primaryIcon,
    this.primaryIconWidget,
    this.onPrimaryPressed,
    this.isPrimaryLoading = false,
    this.primaryFlex = 1,
    this.gap = Spacing.md,
  });

  final String? secondaryText;
  final IconData? secondaryIcon;
  final Widget? secondaryIconWidget;
  final VoidCallback? onSecondaryPressed;
  final bool isSecondaryLoading;
  final int secondaryFlex;

  final String? primaryText;
  final IconData? primaryIcon;
  final Widget? primaryIconWidget;
  final VoidCallback? onPrimaryPressed;
  final bool isPrimaryLoading;
  final int primaryFlex;

  final double gap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final resolvedSecondaryText =
        secondaryText ?? locale.family_previous_program;
    final resolvedSecondaryCallback = secondaryText == null
        ? (onSecondaryPressed ?? () => Navigator.maybePop(context))
        : onSecondaryPressed;

    final Widget? resolvedSecondaryIcon = secondaryIconWidget ??
        (secondaryIcon != null
            ? Icon(
                secondaryIcon,
                color: color.primary,
                size: Spacing.iconMd,
              )
            : (secondaryText == null
                ? Icon(
                    Icons.arrow_back_ios_rounded,
                    color: color.primary,
                    size: Spacing.iconMd,
                  )
                : null));

    final resolvedPrimaryText = primaryText ?? locale.family_next_payment;
    final Widget resolvedPrimaryIcon = primaryIconWidget ??
        (primaryIcon != null
            ? Icon(
                primaryIcon,
                color: color.onPrimary,
                size: Spacing.iconMd,
              )
            : Icon(
                Icons.chevron_left_rounded,
                color: color.onPrimary,
                size: Spacing.iconMd,
              ));

    return Row(
      children: [
        Expanded(
          flex: secondaryFlex,
          child: AppButton.outlined(
            iconBeforeText: true,
            text: resolvedSecondaryText,
            onPressed: isSecondaryLoading ? null : resolvedSecondaryCallback,
            isLoading: isSecondaryLoading,
            height: Spacing.familySetupBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            color: color.primary,
            textColor: color.primary,
            fontSize: FontSize.size11,
            iconWidget: resolvedSecondaryIcon,
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          flex: primaryFlex,
          child: AppButton.filled(
            iconBeforeText: false,
            text: resolvedPrimaryText,
            onPressed: isPrimaryLoading ? null : onPrimaryPressed,
            isLoading: isPrimaryLoading,
            height: Spacing.familySetupBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            textColor: color.onPrimary,
            fontSize: FontSize.size11,
            iconWidget: resolvedPrimaryIcon,
          ),
        ),
      ],
    );
  }
}
