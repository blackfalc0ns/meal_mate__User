import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';

class SubscriptionReferralShareBanner extends StatelessWidget {
  const SubscriptionReferralShareBanner({
    super.key,
    required this.code,
    this.message,
    this.shareUrl,
  });

  final String code;
  final String? message;
  final String? shareUrl;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final shareText = shareUrl ?? code;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.secondaryContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Spacing.avatarSm,
                height: Spacing.avatarSm,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.secondary,
                ),
                child: Icon(
                  Icons.card_giftcard_rounded,
                  size: Spacing.iconSm,
                  color: color.onSecondary,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  locale.subscription_success_referral_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            message ?? locale.subscription_success_referral_subtitle,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Text(
                    code,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              ElevatedButton.icon(
                onPressed: () {
                  unawaited(Clipboard.setData(ClipboardData(text: shareText)));
                  CustomSnackbar.showSuccess(
                    context: context,
                    message: locale.subscription_success_referral_copied,
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: Spacing.iconSm),
                label: Text(
                  locale.subscription_success_share_button,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.primary,
                  foregroundColor: color.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.xs,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
