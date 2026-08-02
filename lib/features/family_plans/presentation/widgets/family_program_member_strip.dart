import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_card.dart';

class FamilyProgramMemberStrip extends StatelessWidget {
  const FamilyProgramMemberStrip({super.key, required this.members});

  final List<FamilyProgramSetupMemberFakeData> members;

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
            child: FamilyProgramMemberCard(member: members[index]),
          ),
        ),
      ),
    );
  }
}
