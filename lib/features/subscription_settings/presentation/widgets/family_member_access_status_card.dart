import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberAccessStatusCard extends StatelessWidget {
  const FamilyMemberAccessStatusCard({
    super.key,
    required this.memberName,
    required this.isPaused,
    required this.onStatusChanged,
    required this.onDeactivate,
    this.canDeactivate = true,
  });

  final String memberName;
  final bool isPaused;
  final ValueChanged<bool> onStatusChanged;
  final VoidCallback onDeactivate;
  final bool canDeactivate;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isActive = !isPaused;

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
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.border,
              ),
            ),
            child: Column(
              children: [
                // Option 1: Active
                InkWell(
                  onTap: () => onStatusChanged(false),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Spacing.radiusMd),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: Row(
                      children: [
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
                        const SizedBox(width: Spacing.sm),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? color.primary
                                  : color.outlineVariant,
                              width: isActive ? 2.0 : 1.5,
                            ),
                          ),
                          child: isActive
                              ? Center(
                                  child: Container(
                                    width: 10.0,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color.primary,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: color.outlineVariant.withValues(alpha: 0.5),
                  thickness: Spacing.hairline,
                  height: Spacing.zero,
                ),
                // Option 2: Paused
                InkWell(
                  onTap: () => onStatusChanged(true),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(Spacing.radiusMd),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: Row(
                      children: [
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
                        const SizedBox(width: Spacing.sm),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isPaused
                                  ? color.primary
                                  : color.outlineVariant,
                              width: isPaused ? 2.0 : 1.5,
                            ),
                          ),
                          child: isPaused
                              ? Center(
                                  child: Container(
                                    width: 10.0,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color.primary,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (canDeactivate) ...[
            const SizedBox(height: Spacing.md),
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
        ],
      ),
    );
  }
}
