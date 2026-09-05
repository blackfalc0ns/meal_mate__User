import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerWithdrawAmountCard extends StatelessWidget {
  const InfluencerWithdrawAmountCard({
    super.key,
    required this.label,
    required this.amount,
    required this.currency,
  });

  final String label;
  final String amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size13,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Container(
          height: Spacing.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.inputRadius),
            border: Border.all(color: color.outlineVariant),
          ),
          child: Row(
            children: [
              Text(
                amount,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size16,
                  color: color.primary,
                ),
              ),
              const Spacer(),
              Text(
                currency,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
