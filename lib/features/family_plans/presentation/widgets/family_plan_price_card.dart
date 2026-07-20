import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_plan_entity.dart';

class FamilyPlanPriceCard extends StatelessWidget {
  const FamilyPlanPriceCard({super.key, required this.plan});

  final FamilyPlanEntity plan;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      constraints: const BoxConstraints(
        minHeight: Spacing.familyPriceMinHeight,
      ),
      padding: const EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.sm,
        Spacing.base,
        Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(color: color.primary),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(Icons.savings_rounded, color: color.primary, size: 13),
              const SizedBox(width: Spacing.xss),
              Text(
                context.localization.family_price_details,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size11,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          for (final row in plan.priceRows) ...[
            _PriceRow(label: row.label, value: row.value),
            const SizedBox(height: Spacing.sm),
          ],
          Divider(color: color.outlineVariant),
          _PriceRow(
            label: plan.totalLabel,
            value: plan.totalPrice,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: isTotal
                ? getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size19,
                  )
                : getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size10,
                  ),
          ),
        ),
        _PriceAmount(value: value, isTotal: isTotal),
      ],
    );
  }
}

class _PriceAmount extends StatelessWidget {
  const _PriceAmount({required this.value, required this.isTotal});

  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final valueStyle = isTotal
        ? getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            color: color.primary,
            fontSize: FontSize.size19,
          )
        : getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            color: color.onSurface,
            fontSize: FontSize.size11,
          );
    final currencyStyle = valueStyle.copyWith(
      fontSize: isTotal ? FontSize.size16 : FontSize.size8,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: value.trim()),
          const TextSpan(text: ' '),
          TextSpan(text: context.localization.currency, style: currencyStyle),
        ],
      ),
      textDirection: TextDirection.ltr,
      style: valueStyle,
    );
  }
}
