import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyProgramSummaryCard extends StatelessWidget {
  const FamilyProgramSummaryCard({super.key, required this.member});

  final FamilyProgramMemberDetailsUiModel member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.familyProgramSummaryHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: const Color(0xffFAFBF9),
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.md),
      ),
      child: Row(
        children: [
          ClipOval(
            child: member.imageAsset.isNotEmpty
                ? Image.asset(
                    member.imageAsset,
                    width: Spacing.familyProgramSummaryAvatarSize,
                    height: Spacing.familyProgramSummaryAvatarSize,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.person_rounded,
                      color: color.primary,
                      size: Spacing.familyProgramSummaryAvatarSize,
                    ),
                  )
                : Container(
                    width: Spacing.familyProgramSummaryAvatarSize,
                    height: Spacing.familyProgramSummaryAvatarSize,
                    color: color.surfaceContainerHighest,
                    child: Icon(
                      Icons.person_rounded,
                      color: color.primary,
                      size: Spacing.iconMd,
                    ),
                  ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
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
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: Spacing.iconSm,
                      color: color.primary,
                    ),
                    const SizedBox(width: Spacing.xss),
                    Flexible(
                      child: Text(
                        member.age,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (member.gender.isNotEmpty) ...[
                      const SizedBox(width: Spacing.md),
                      Container(
                        width: Spacing.xss,
                        height: Spacing.xss,
                        decoration: BoxDecoration(
                          color: color.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      Flexible(
                        child: Text(
                          member.gender,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (member.roleLabel.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xss,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
              child: Text(
                member.roleLabel,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
