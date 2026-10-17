import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_price_row.dart';

class FamilyPaymentPriceDetailsCard extends StatelessWidget {
  const FamilyPaymentPriceDetailsCard({super.key, required this.details});

  final FamilyPaymentPriceDetailsUiModel details;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familySetupMemberCardRadius,
        ),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ColoredBox(
              color: color.surface,
              child: Text(
                locale.family_price_details,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          for (final row in details.rows) ...[
            FamilyPaymentPriceRow(row: row),
            const SizedBox(height: Spacing.xs),
          ],
          const SizedBox(height: Spacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
            decoration: BoxDecoration(
              color: color.surfaceContainerHighest.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
              border: Border.all(color: color.primary.withValues(alpha: 0.35)),
            ),
            child: Column(
              children: [
                Text(
                  details.totalLabel,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  details.totalValue,
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
      ),
    );
  }
}
