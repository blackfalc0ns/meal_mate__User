import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerWithdrawReviewSummaryCard extends StatelessWidget {
  const InfluencerWithdrawReviewSummaryCard({
    super.key,
    required this.title,
    required this.requestedAmountLabel,
    required this.requestedAmountValue,
    required this.transferFeesLabel,
    required this.transferFeesValue,
    required this.finalAmountLabel,
    required this.finalAmountValue,
  });

  final String title;
  final String requestedAmountLabel;
  final String requestedAmountValue;
  final String transferFeesLabel;
  final String transferFeesValue;
  final String finalAmountLabel;
  final String finalAmountValue;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: color.primary,
                size: Spacing.iconMd,
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          _buildSummaryRow(
            context,
            label: requestedAmountLabel,
            value: requestedAmountValue,
            isPrimaryColor: true,
          ),
          _buildDivider(color),
          _buildSummaryRow(
            context,
            label: transferFeesLabel,
            value: transferFeesValue,
          ),
          _buildDivider(color),
          _buildSummaryRow(
            context,
            label: finalAmountLabel,
            value: finalAmountValue,
            isPrimaryColor: true,
            isProminent: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isPrimaryColor = false,
    bool isProminent = false,
  }) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: isProminent ? FontSize.size12 : FontSize.size11,
                color: isProminent ? color.onSurface : color.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Text(
            value,
            textAlign: TextAlign.end,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: isProminent ? FontSize.size13 : FontSize.size11,
              color: isPrimaryColor ? color.primary : color.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme color) {
    return Divider(
      color: color.outlineVariant.withValues(alpha: 0.5),
      height: Spacing.base,
      thickness: 1.0,
    );
  }
}
