import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';

class SubscriptionBillingFreezeRulesCard extends StatelessWidget {
  const SubscriptionBillingFreezeRulesCard({
    super.key,
    required this.policy,
  });

  final SubscriptionBillingFreezePolicyEntity? policy;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (policy == null) {
      return const SizedBox.shrink();
    }

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final currentPolicy = policy!;
    final noticeText = isRtl
        ? (currentPolicy.noticeAr.isNotEmpty
            ? currentPolicy.noticeAr
            : currentPolicy.notice)
        : (currentPolicy.notice.isNotEmpty
            ? currentPolicy.notice
            : currentPolicy.noticeAr);
    final messageText = isRtl
        ? (currentPolicy.messageAr.isNotEmpty
            ? currentPolicy.messageAr
            : currentPolicy.message)
        : (currentPolicy.messageEn.isNotEmpty
            ? currentPolicy.messageEn
            : currentPolicy.message);

    final hasNotice = noticeText.trim().isNotEmpty;
    final hasMessage = messageText.trim().isNotEmpty && messageText != noticeText;

    if (!hasNotice && !hasMessage) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.5),
          width: Spacing.border,
        ),
      ),
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Text(
                  locale.billing_freeze_rules_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.primary,
                  ),
                ),
              ),
            ],
          ),
          if (hasMessage) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              messageText.trim(),
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ).copyWith(height: 1.45),
            ),
          ],
          if (hasNotice) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              noticeText.trim(),
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ).copyWith(height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}
