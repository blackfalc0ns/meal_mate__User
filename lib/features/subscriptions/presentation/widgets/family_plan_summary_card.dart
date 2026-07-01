import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/family_plan_entity.dart';

class FamilyPlanSummaryCard extends StatelessWidget {
  const FamilyPlanSummaryCard({super.key, required this.stats});

  final List<FamilySummaryStatEntity> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFECEEED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Icon(Icons.groups_rounded, size: 12),
              const SizedBox(width: 5),
              Text(
                context.localization.family_summary_title,
                style: const TextStyle(
                  fontSize: 9.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                for (int index = 0; index < stats.length; index++) ...[
                  Expanded(child: _SummaryStat(stat: stats[index])),
                  if (index != stats.length - 1)
                    Container(width: 1, color: const Color(0xFFF7F8F7)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.stat});

  final FamilySummaryStatEntity stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, size: 10, color: const Color(0xFF09763B)),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                stat.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF09763B),
                  fontSize: 8.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          stat.label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF5A5C62),
            fontSize: 7.4,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  IconData get _icon {
    switch (stat.iconName) {
      case 'fire':
        return Icons.local_fire_department_rounded;
      case 'meals':
        return Icons.restaurant_rounded;
      case 'delivery':
        return Icons.local_shipping_outlined;
      default:
        return Icons.groups_rounded;
    }
  }
}
