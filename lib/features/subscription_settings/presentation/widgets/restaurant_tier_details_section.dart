import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_detail_row.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_section_card.dart';

class RestaurantTierDetailsSection extends StatelessWidget {
  const RestaurantTierDetailsSection({super.key, required this.data});

  final RestaurantTierUpgradeEntity data;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return RestaurantTierSectionCard(
      title: data.detailsTitle,
      icon: Icons.receipt_long_rounded,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: color.outlineVariant),
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
            ),
            child: Column(
              children: [
                for (final row in data.detailsRows)
                  RestaurantTierDetailRow(row: row),
                Divider(color: color.outlineVariant),
                RestaurantTierDetailRow(
                  row: RestaurantTierDetailRowEntity(
                    label: data.totalLabel,
                    value: data.totalValue,
                    isStrong: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.priority_high_rounded,
                color: color.onSurfaceVariant,
                size: Spacing.iconSm,
                semanticLabel: data.applyNote,
              ),
              const SizedBox(width: Spacing.xs),
              Flexible(
                child: Text(
                  data.applyNote,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                  semanticsLabel:
                      locale.subscription_summary_restaurant_tier_label,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
