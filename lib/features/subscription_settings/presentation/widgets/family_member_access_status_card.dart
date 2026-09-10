import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilyMemberAccessStatusCard extends StatelessWidget {
  const FamilyMemberAccessStatusCard({
    super.key,
    required this.memberName,
    required this.currentStatus,
    required this.onStatusChanged,
    required this.onDeactivate,
  });

  final String memberName;
  final FamilyMemberAccessStatus currentStatus;
  final ValueChanged<FamilyMemberAccessStatus> onStatusChanged;
  final VoidCallback onDeactivate;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isActive = currentStatus == FamilyMemberAccessStatus.active;
    final isPaused = currentStatus == FamilyMemberAccessStatus.paused;

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.family_member_access_membership_section,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.family_member_access_membership_subtitle(memberName),
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.md),
          // Option 1: Active
          InkWell(
            onTap: () => onStatusChanged(FamilyMemberAccessStatus.active),
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            child: Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: isActive
                    ? color.primary.withValues(alpha: 0.06)
                    : color.surface,
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                border: Border.all(
                  color: isActive ? color.primary : color.outlineVariant,
                  width: isActive ? Spacing.border : Spacing.hairline,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isActive
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: isActive ? color.primary : color.onSurfaceVariant,
                    size: Spacing.iconMd,
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.family_member_access_status_active,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          locale.family_member_access_active_desc,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          // Option 2: Paused
          InkWell(
            onTap: () => onStatusChanged(FamilyMemberAccessStatus.paused),
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            child: Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: isPaused
                    ? color.primary.withValues(alpha: 0.06)
                    : color.surface,
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                border: Border.all(
                  color: isPaused ? color.primary : color.outlineVariant,
                  width: isPaused ? Spacing.border : Spacing.hairline,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isPaused
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: isPaused ? color.primary : color.onSurfaceVariant,
                    size: Spacing.iconMd,
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.family_member_access_status_paused,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          locale.family_member_access_paused_desc,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          // Deactivate Button
          InkWell(
            onTap: onDeactivate,
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            child: Container(
              width: double.infinity,
              height: Spacing.buttonSmallHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                border: Border.all(color: color.error, width: Spacing.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: color.error,
                    size: Spacing.iconSm,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    locale.family_member_access_deactivate_button,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
