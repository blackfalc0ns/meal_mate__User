import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CampaignPaymentHeaderCard extends StatelessWidget {
  const CampaignPaymentHeaderCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
  });

  final String title;
  final double? amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Spacing.md),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: Icon(Icons.campaign_rounded, color: color.primary, size: 24),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isNotEmpty ? title : locale.campaign_payment_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  locale.campaign_payment_amount_label,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (amount != null)
            Text(
              '${amount!.toStringAsFixed(3)} $currency',
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.primary,
              ),
            ),
        ],
      ),
    );
  }
}
