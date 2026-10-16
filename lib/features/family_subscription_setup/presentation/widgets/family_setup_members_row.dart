import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_add_member_card.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_member_card.dart';

class FamilySetupMembersRow extends StatelessWidget {
  const FamilySetupMembersRow({
    super.key,
    required this.members,
    required this.maxMembers,
    this.selectedMemberId,
    this.isAddingNew = true,
    required this.onMemberSelected,
    required this.onAddMemberTap,
  });

  final List<FamilyMemberEntity> members;
  final int maxMembers;
  final String? selectedMemberId;
  final bool isAddingNew;
  final ValueChanged<FamilyMemberEntity> onMemberSelected;
  final VoidCallback onAddMemberTap;

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
    final color = context.colorScheme;
    final locale = context.localization;

    final effectiveMax = math.max(maxMembers, members.length);
    final emptyCount = math.max(0, effectiveMax - members.length);
    final totalCount = members.length + emptyCount;

    final cards = <Widget>[
      for (int i = 0; i < members.length; i++)
        FamilySetupMemberCard(
          name: members[i].displayName,
          imageAsset: _resolveAvatar(members[i].gender, i),
          isSelected: selectedMemberId == members[i].memberId,
          onTap: () => onMemberSelected(members[i]),
        ),
      for (int i = 0; i < emptyCount; i++)
        FamilySetupAddMemberCard(
          label: locale.family_add_member_button,
          isSelected: isAddingNew && i == 0,
          onTap: onAddMemberTap,
        ),
    ];

    if (totalCount <= 4) {
      return IconTheme(
        data: IconThemeData(color: color.primary),
        child: Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: Spacing.xss),
              Expanded(child: cards[i]),
            ],
          ],
        ),
      );
    }

    return IconTheme(
      data: IconThemeData(color: color.primary),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: Spacing.xss),
              SizedBox(width: 84.0, child: cards[i]),
            ],
          ],
        ),
      ),
    );
  }
}
