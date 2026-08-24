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
    final statusColor = member.isInProgress
        ? color.onSurfaceVariant
        : color.primary;

    return Semantics(
      button: true,
      selected: member.isSelected,
      label: member.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: Spacing.familyProgramMemberCardWidth,
          height: Spacing.familyProgramMemberCardHeight,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
          decoration: BoxDecoration(
            color: member.isSelected
                ? color.primary.withValues(alpha: 0.08)
                : color.surface,
            border: Border.all(
              color: member.isSelected ? color.primary : color.outlineVariant,
              width: member.isSelected ? 1.5 : 1.0,
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
                          color: color.primary,
                          size: Spacing.familyProgramMemberAvatarSize,
                        ),
                      )
                    : Container(
                        width: Spacing.familyProgramMemberAvatarSize,
                        height: Spacing.familyProgramMemberAvatarSize,
                        color: member.isSelected
                            ? color.primary.withValues(alpha: 0.15)
                            : color.surfaceContainerHighest,
                        child: Icon(
                          Icons.person_rounded,
                          color: color.primary,
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
                        color: member.isSelected
                            ? color.primary
                            : color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!member.isInProgress) ...[
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
    );
  }
}
