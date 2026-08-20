import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';

class FamilyMembersStrip extends StatelessWidget {
  const FamilyMembersStrip({
    super.key,
    required this.members,
    required this.onAddTap,
  });

  final List<FamilyPlanMemberUiModel> members;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Spacing.familyMembersStripHeight,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: members.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddMemberCard(onTap: onAddTap);
          }
          return _MemberCard(member: members[index - 1]);
        },
      ),
    );
  }
}

class _AddMemberCard extends StatelessWidget {
  const _AddMemberCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;

    return Material(
      color: color.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        side: BorderSide(color: color.primary),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        child: SizedBox(
          width: Spacing.familyMemberCardWidth,
          height: Spacing.familyMembersStripHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_rounded, color: color.primary, size: 28),
                const SizedBox(height: Spacing.sm),
                Text(
                  l10n.family_add_member,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    color: color.primary,
                    fontSize: FontSize.size8,
                  ).copyWith(height: 1.1),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  l10n.family_add_member_subtitle,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    color: color.onSurfaceVariant,
                    fontSize: FontSize.size6,
                  ).copyWith(height: 1.25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member});

  final FamilyPlanMemberUiModel member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: Spacing.familyMemberCardWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(member.imageAsset),
              ),
              if (member.isOwner)
                Positioned(
                  bottom: -5,
                  left: 8,
                  right: 8,
                  child: Container(
                    alignment: Alignment.center,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color.primary,
                      borderRadius: BorderRadius.circular(Spacing.xs),
                    ),
                    child: Text(
                      context.localization.family_owner,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        color: color.onPrimary,
                        fontSize: FontSize.size6,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.xss),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              color: color.onSurface,
              fontSize: FontSize.size8,
            ),
          ),
          const SizedBox(height: 2),
          _MemberDetails(lines: member.detailLines),
          const Spacer(),
          SizedBox(
            height: 16,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color.primaryContainer,
                borderRadius: BorderRadius.circular(Spacing.radiusXs),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member.actionLabel,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      color: color.onPrimaryContainer,
                      fontSize: FontSize.size9,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Icon(
                    Icons.edit_outlined,
                    size: FontSize.size7,
                    color: color.onPrimaryContainer,
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

class _MemberDetails extends StatelessWidget {
  const _MemberDetails({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final icons = [
      Icons.track_changes_rounded,
      Icons.local_fire_department_rounded,
      Icons.restaurant_rounded,
    ];

    return Column(
      children: [
        for (int index = 0; index < lines.length; index++)
          Padding(
            padding: EdgeInsets.only(bottom: index == lines.length - 1 ? 0 : 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  icons[index % icons.length],
                  size: FontSize.size7,
                  color: color.onSurfaceVariant,
                ),
                const SizedBox(width: Spacing.xs),
                Flexible(
                  child: Text(
                    lines[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size7,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
