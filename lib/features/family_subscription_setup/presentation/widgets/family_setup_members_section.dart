import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_card.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_add_member_card.dart';

class FamilySetupMembersSection extends StatelessWidget {
  const FamilySetupMembersSection({
    super.key,
    required this.members,
    this.maxMembers = 6,
    this.selectedMemberId,
    required this.onMemberSelected,
    this.onAddMemberTap,
  });

  final List<FamilyMemberEntity> members;
  final int maxMembers;
  final String? selectedMemberId;
  final ValueChanged<FamilyMemberEntity> onMemberSelected;
  final VoidCallback? onAddMemberTap;

  String _resolveAvatar(int gender, int index) {
    if (gender == 2) {
      return index % 2 == 0
          ? AssetsFake.familyMemberSarah
          : AssetsFake.familyMemberMariam;
    }
    return index % 2 == 0
        ? AssetsFake.familyMemberAhmed
        : AssetsFake.familyMemberYousef;
  }

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    final color = context.colorScheme;
    final locale = context.localization;

    final memberUiModels = members.asMap().entries.map((entry) {
      final index = entry.key;
      final member = entry.value;
      final isSelected = selectedMemberId == member.memberId;
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: _resolveAvatar(member.gender, index),
        status: locale.family_member_completed,
        isSelected: isSelected,
        isInProgress: false,
      );
    }).toList();

    final canAddMember = members.length < maxMembers;
    final totalCount = members.length + (canAddMember ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale.family_members_count_label,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xxs,
              ),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
              child: Text(
                locale.family_setup_members_counter(maxMembers, members.length),
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        IconTheme(
          data: IconThemeData(color: color.primary),
          child: SizedBox(
            height: Spacing.familyProgramMemberCardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: totalCount,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: Spacing.familyProgramMemberGap),
              itemBuilder: (context, index) {
                if (index < members.length) {
                  return SizedBox(
                    width: Spacing.familyProgramMemberCardWidth,
                    child: FamilyProgramMemberCard(
                      member: memberUiModels[index],
                      onTap: () => onMemberSelected(members[index]),
                    ),
                  );
                }
                return SizedBox(
                  width: Spacing.familyProgramMemberCardWidth,
                  child: FamilySetupAddMemberCard(
                    isSelected: selectedMemberId == null,
                    onTap: onAddMemberTap,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
