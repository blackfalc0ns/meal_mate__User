import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_quick_access_tile.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_section_header.dart';

class FamilySubscriptionQuickAccessSection extends StatelessWidget {
  const FamilySubscriptionQuickAccessSection({
    super.key,
    required this.actions,
    this.onActionTap,
  });

  final List<FamilySubscriptionQuickActionEntity> actions;
  final ValueChanged<FamilySubscriptionQuickActionEntity>? onActionTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ColoredBox(
      color: color.surface.withValues(alpha: 0),
      child: Column(
        children: [
          FamilySubscriptionSectionHeader(
            title: locale.family_manage_quick_access,
          ),
          const SizedBox(height: Spacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final action in actions)
                SizedBox(
                  width: Spacing.familyManageQuickTileWidth,
                  child: FamilySubscriptionQuickAccessTile(
                    action: action,
                    onTap: onActionTap == null
                        ? null
                        : () => onActionTap!(action),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
