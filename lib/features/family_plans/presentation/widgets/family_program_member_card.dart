import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';

class FamilyProgramMemberCard extends StatelessWidget {
  const FamilyProgramMemberCard({super.key, required this.member});

  final FamilyProgramSetupMemberFakeData member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final statusColor = member.isInProgress
        ? color.primary
        : color.onSurfaceVariant;

    return Container(width: Spacing.familyProgramMemberCardWidth,
      height: Spacing.familyProgramMemberCardHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(
          color: member.isSelected ? color.primary : color.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(
          Spacing.familyProgramMemberCardRadius,
        ),
      ),
      child: Row(
       
        children: [
          ClipOval(
            child: Image.asset(
              member.imageAsset,
              width: Spacing.familyProgramMemberAvatarSize,
              height: Spacing.familyProgramMemberAvatarSize,
              fit: BoxFit.cover,
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
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Spacing.xs,
                      height: Spacing.xs,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      member.status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
