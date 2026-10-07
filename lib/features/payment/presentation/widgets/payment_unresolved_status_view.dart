import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class PaymentUnresolvedStatusView extends StatelessWidget {
  const PaymentUnresolvedStatusView({
    super.key,
    required this.isReviewRequired,
    this.attemptHandle,
    this.onCheckStatus,
    this.isCheckingStatus = false,
  });

  final bool isReviewRequired;
  final String? attemptHandle;
  final VoidCallback? onCheckStatus;
  final bool isCheckingStatus;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final title = isReviewRequired
        ? locale.payment_review_title
        : locale.payment_pending_title;
    final message = isReviewRequired
        ? locale.payment_review_message
        : locale.payment_pending_message;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isReviewRequired
                    ? color.error.withValues(alpha: 0.1)
                    : color.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isReviewRequired
                    ? Icons.assignment_late_outlined
                    : Icons.hourglass_top_rounded,
                size: 36,
                color: isReviewRequired ? color.error : color.primary,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurfaceVariant,
              ),
            ),
            if (attemptHandle != null && attemptHandle!.isNotEmpty) ...[
              const SizedBox(height: Spacing.md),
              InkWell(
                onTap: () {
                  unawaited(
                    Clipboard.setData(ClipboardData(text: attemptHandle!)),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        locale.payment_reference_label(attemptHandle!),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(Spacing.sm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(Spacing.sm),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.payment_reference_label(attemptHandle!),
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: color.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: Spacing.xl),
            if (isReviewRequired) ...[
              AppButton.filled(
                text: locale.payment_contact_support_button,
                icon: Icons.support_agent_rounded,
                onPressed: () {
                  unawaited(
                    Navigator.of(context).pushNamed(AppRoutes.profileContactUs),
                  );
                },
              ),
              if (onCheckStatus != null) ...[
                const SizedBox(height: Spacing.sm),
                AppButton.outlined(
                  text: locale.payment_check_status_button,
                  isLoading: isCheckingStatus,
                  onPressed: onCheckStatus,
                ),
              ],
            ] else ...[
              if (onCheckStatus != null)
                AppButton.filled(
                  text: locale.payment_check_status_button,
                  isLoading: isCheckingStatus,
                  icon: Icons.refresh_rounded,
                  onPressed: onCheckStatus,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
