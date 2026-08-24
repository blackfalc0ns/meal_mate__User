import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_card.dart';

class FamilyProgramMemberStrip extends StatelessWidget {
  const FamilyProgramMemberStrip({
    super.key,
    required this.members,
    this.onSelectMember,
  });

  final List<FamilyProgramMemberUiModel> members;
  final ValueChanged<int>? onSelectMember;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return IconTheme(
      data: IconThemeData(color: color.primary),
      child: SizedBox(
        height: Spacing.familyProgramMemberCardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (_, _) =>
              const SizedBox(width: Spacing.familyProgramMemberGap),
          itemBuilder: (context, index) => SizedBox(
            width: Spacing.familyProgramMemberCardWidth,
            child: FamilyProgramMemberCard(
              member: members[index],
              onTap: () => onSelectMember?.call(index),
            ),
          ),
        ),
      ),
    );
  }
}
