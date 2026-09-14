import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerWithdrawReviewDetailsCard extends StatelessWidget {
  const InfluencerWithdrawReviewDetailsCard({
    super.key,
    required this.title,
    required this.methodLabel,
    required this.methodValue,
    required this.bankLabel,
    required this.bankValue,
    required this.accountHolderLabel,
    required this.accountHolderValue,
    required this.accountNumberLabel,
    required this.accountNumberValue,
    required this.ibanLabel,
    required this.ibanValue,
  });

  final String title;
  final String methodLabel;
  final String methodValue;
  final String bankLabel;
  final String bankValue;
  final String accountHolderLabel;
  final String accountHolderValue;
  final String accountNumberLabel;
  final String accountNumberValue;
  final String ibanLabel;
  final String ibanValue;

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
                Icons.account_balance_rounded,
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
          _buildDetailRow(
            context,
            label: methodLabel,
            value: methodValue,
            isPrimaryColor: true,
          ),
          _buildDivider(color),
          _buildDetailRow(context, label: bankLabel, value: bankValue),
          _buildDivider(color),
          _buildDetailRow(
            context,
            label: accountHolderLabel,
            value: accountHolderValue,
          ),
          _buildDivider(color),
          _buildDetailRow(
            context,
            label: accountNumberLabel,
            value: accountNumberValue,
          ),
          _buildDivider(color),
          _buildDetailRow(context, label: ibanLabel, value: ibanValue),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isPrimaryColor = false,
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
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: isPrimaryColor ? color.primary : color.onSurface,
              ),
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
