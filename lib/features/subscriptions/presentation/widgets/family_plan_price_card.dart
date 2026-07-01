import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/family_plan_entity.dart';

class FamilyPlanPriceCard extends StatelessWidget {
  const FamilyPlanPriceCard({super.key, required this.plan});

  final FamilyPlanEntity plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
      padding: const EdgeInsets.fromLTRB(17, 10, 17, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF1B8E2F)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
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
              const Icon(
                Icons.savings_rounded,
                color: Color(0xFF0C6C3F),
                size: 13,
              ),
              const SizedBox(width: 5),
              Text(
                context.localization.family_price_details,
                style: const TextStyle(
                  fontSize: 8.9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final row in plan.priceRows) ...[
            _PriceRow(label: row.label, value: row.value),
            const SizedBox(height: 9),
          ],
          const Divider(color: Color(0xFFEAEBEC)),
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
            style: TextStyle(
              fontSize: isTotal ? 19 : 9.9,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? const Color(0xFF0C6C3F) : Colors.black,
            fontSize: isTotal ? 19 : 10.9,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
