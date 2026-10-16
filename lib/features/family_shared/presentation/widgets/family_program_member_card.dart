import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyProgramMemberCard extends StatelessWidget {
  const FamilyProgramMemberCard({super.key, required this.member, this.onTap});

  final FamilyProgramMemberUiModel member;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final statusColor = member.isExcluded
        ? color.onSurfaceVariant.withValues(alpha: 0.7)
        : member.isInProgress
        ? color.onSurfaceVariant
        : color.primary;

    return Semantics(
      button: true,
      selected: member.isSelected,
      label: member.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: member.isSelected ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: member.isExcluded ? 0.6 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: Spacing.familyProgramMemberCardWidth,
              height: Spacing.familyProgramMemberCardHeight,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
              decoration: BoxDecoration(
                border: Border.all(
                  color: member.isExcluded
                      ? color.outlineVariant.withValues(alpha: 0.5)
                      : member.isSelected
                      ? color.primary
                      : color.outlineVariant,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(
                  Spacing.familyProgramMemberCardRadius,
                ),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: member.imageAsset.isNotEmpty
                        ? Image.asset(
                            member.imageAsset,
                            width: Spacing.familyProgramMemberAvatarSize,
                            height: Spacing.familyProgramMemberAvatarSize,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.person_rounded,
                              color: member.isExcluded
                                  ? color.onSurfaceVariant.withValues(
                                      alpha: 0.7,
                                    )
                                  : color.primary,
                              size: Spacing.familyProgramMemberAvatarSize,
                            ),
                          )
                        : Container(
                            width: Spacing.familyProgramMemberAvatarSize,
                            height: Spacing.familyProgramMemberAvatarSize,
                            color: member.isExcluded
                                ? color.surfaceContainerHighest
                                : member.isSelected
                                ? color.primary.withValues(alpha: 0.15)
                                : color.surfaceContainerHighest,
                            child: Icon(
                              Icons.person_rounded,
                              color: member.isExcluded
                                  ? color.onSurfaceVariant.withValues(
                                      alpha: 0.7,
                                    )
                                  : color.primary,
                              size: Spacing.iconSm,
                            ),
                          ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (member.isExcluded) ...[
                              Icon(
                                Icons.pause_circle_outline_rounded,
                                size: Spacing.iconSm,
                                color: statusColor,
                              ),
                            ] else if (!member.isInProgress) ...[
                              Icon(
                                Icons.check_circle_rounded,
                                size: Spacing.iconSm,
                                color: color.primary,
                              ),
                            ] else ...[
                              Container(
                                width: Spacing.xs,
                                height: Spacing.xs,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                            const SizedBox(width: Spacing.xs),
                            Flexible(
                              child: Text(
                                member.status,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size9,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
