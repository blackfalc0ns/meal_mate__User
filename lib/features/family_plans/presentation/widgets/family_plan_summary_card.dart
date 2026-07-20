import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_plan_entity.dart';

class FamilyPlanSummaryCard extends StatelessWidget {
  const FamilyPlanSummaryCard({super.key, required this.stats});

  final List<FamilySummaryStatEntity> stats;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.familySummaryHeight,
      padding: const EdgeInsets.fromLTRB(Spacing.md, 6, Spacing.md, 6),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.groups_rounded, size: 14, color: color.primary),
              const SizedBox(width: Spacing.xss),
              Text(
                context.localization.family_summary_title,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  color: color.onSurface,
                  fontSize: FontSize.size9,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Expanded(
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                for (int index = 0; index < stats.length; index++) ...[
                  Expanded(child: _SummaryStat(stat: stats[index])),
                  if (index != stats.length - 1)
                    Container(
                      width: Spacing.hairline,
                      margin: const EdgeInsets.symmetric(vertical: Spacing.xs),
                      color: color.surfaceContainerHighest,
                    ),
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
    final color = context.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, size: 13, color: color.primary),
            const SizedBox(width: Spacing.xs),
            Flexible(
              child: Text(
                stat.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  color: color.primary,
                  fontSize: stat.iconName == 'delivery'
                      ? FontSize.size6
                      : FontSize.size8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          stat.label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            color: color.onSurfaceVariant,
            fontSize: FontSize.size7,
          ).copyWith(height: 1.15),
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
