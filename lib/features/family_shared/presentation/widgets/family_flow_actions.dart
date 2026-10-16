import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyFlowActions extends StatelessWidget {
  const FamilyFlowActions({
    super.key,
    this.showSecondary = true,
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
    this.progress,
    this.progressLabel,
  });

  final bool showSecondary;
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
  final double? progress;
  final String? progressLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isPrimaryEnabled = onPrimaryPressed != null && !isPrimaryLoading;
    final primaryTextColor = isPrimaryEnabled
        ? color.onPrimary
        : color.onSurface.withValues(alpha: 0.38);

    final resolvedPrimaryText = progressLabel == null
        ? (primaryText ?? locale.family_next_payment)
        : '${primaryText ?? locale.family_next_payment}  $progressLabel';
    final Widget resolvedPrimaryIcon =
        primaryIconWidget ??
        (primaryIcon != null
            ? Icon(primaryIcon, color: primaryTextColor, size: Spacing.iconMd)
            : Icon(
                Icons.chevron_right_rounded,
                color: primaryTextColor,
                size: Spacing.iconMd,
              ));

    if (!showSecondary) {
      return _ProgressButton(
        progress: progress,
        enabled: isPrimaryEnabled,
        child: AppButton.filled(
        iconBeforeText: false,
        text: resolvedPrimaryText,
        onPressed: onPrimaryPressed,
        isLoading: isPrimaryLoading,
        height: Spacing.familySetupBottomButtonHeight,
        borderRadius: Spacing.radiusPill,
        textColor: primaryTextColor,
        fontSize: FontSize.size11,
        iconWidget: resolvedPrimaryIcon,
        ),
      );
    }

    final resolvedSecondaryText =
        secondaryText ?? locale.family_previous_program;
    final resolvedSecondaryCallback = secondaryText == null
        ? (onSecondaryPressed ?? () => Navigator.maybePop(context))
        : onSecondaryPressed;

    final isSecondaryEnabled =
        resolvedSecondaryCallback != null && !isSecondaryLoading;
    final secondaryColor = isSecondaryEnabled
        ? color.primary
        : color.onSurface.withValues(alpha: 0.38);

    final Widget? resolvedSecondaryIcon =
        secondaryIconWidget ??
        (secondaryIcon != null
            ? Icon(secondaryIcon, color: secondaryColor, size: Spacing.iconMd)
            : (secondaryText == null
                  ? Icon(
                      Icons.arrow_back_ios_rounded,
                      color: secondaryColor,
                      size: Spacing.iconMd,
                    )
                  : null));

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
            color: secondaryColor,
            textColor: secondaryColor,
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
            onPressed: onPrimaryPressed,
            isLoading: isPrimaryLoading,
            height: Spacing.familySetupBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            textColor: primaryTextColor,
            fontSize: FontSize.size11,
            iconWidget: resolvedPrimaryIcon,
          ),
        ),
      ],
    );
  }
}
