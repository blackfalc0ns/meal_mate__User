import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class SubscriptionProgramAddressRequiredSheet extends StatelessWidget {
  const SubscriptionProgramAddressRequiredSheet({
    super.key,
    required this.onAddAddress,
    this.onDismiss,
  });

  final VoidCallback onAddAddress;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.primary.withValues(alpha: 0.08),
                  border: Border.all(
                    color: color.primary.withValues(alpha: 0.14),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.primary,
                        color.primary.withValues(alpha: 0.82),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.primary.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.location_on_rounded,
                    color: color.onPrimary,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              locale.subscription_program_address_required_title,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              locale.subscription_program_address_required_description,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurfaceVariant,
              ).copyWith(height: 1.45),
            ),
            const SizedBox(height: Spacing.xl),
            AppButton.filled(
              text: locale.subscription_program_address_required_action,
              onPressed: onAddAddress,
              height: Spacing.buttonSmallHeight,
              borderRadius: Spacing.radiusPill,
              color: color.primary,
              textColor: color.onPrimary,
              fontSize: FontSize.size13,
            ),
            if (onDismiss != null) ...[
              const SizedBox(height: Spacing.sm),
              AppButton.outlined(
                text: locale.skip,
                onPressed: onDismiss,
                height: Spacing.buttonSmallHeight,
                borderRadius: Spacing.radiusPill,
                color: color.outlineVariant,
                textColor: color.onSurfaceVariant,
                fontSize: FontSize.size13,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
