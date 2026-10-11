import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_quick_access_tile.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_section_header.dart';

class FamilySubscriptionQuickAccessSection extends StatelessWidget {
  const FamilySubscriptionQuickAccessSection({
    super.key,
    this.actions,
    this.onActionTap,
  });

  final List<FamilySubscriptionQuickActionEntity>? actions;
  final ValueChanged<FamilySubscriptionQuickActionEntity>? onActionTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final hasThreeCanonicalActions =
        actions != null &&
        actions!.length == 3 &&
        actions!.any((a) => a.code == 'meals') &&
        actions!.any((a) => a.code == 'subscription') &&
        actions!.any((a) => a.code == 'permissions');

    final effectiveActions = hasThreeCanonicalActions
        ? actions!
        : [
            FamilySubscriptionQuickActionEntity(
              code: 'meals',
              label: locale.family_manage_meals,
              iconAsset: Assets.familyManageMeals,
            ),
            FamilySubscriptionQuickActionEntity(
              code: 'subscription',
              label: locale.family_manage_subscription,
              iconAsset: Assets.familyManageSubscription,
            ),
            FamilySubscriptionQuickActionEntity(
              code: 'permissions',
              label: locale.family_manage_permissions,
              iconAsset: Assets.familyManagePermissions,
            ),
          ];

    return ColoredBox(
      color: color.surface.withValues(alpha: 0),
      child: Column(
        children: [
          FamilySubscriptionSectionHeader(
            title: locale.family_manage_quick_access,
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              for (int i = 0; i < effectiveActions.length; i++) ...[
                if (i > 0) const SizedBox(width: Spacing.sm),
                Expanded(
                  child: FamilySubscriptionQuickAccessTile(
                    action: effectiveActions[i],
                    onTap: onActionTap == null
                        ? null
                        : () => onActionTap!(effectiveActions[i]),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
