import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_card.dart';

class FamilyProgramGrid extends StatelessWidget {
  const FamilyProgramGrid({
    super.key,
    required this.programs,
    required this.selectedIndex,
    required this.onProgramSelected,
  });

  final List<FamilyProgramUiModel> programs;
  final int? selectedIndex;
  final ValueChanged<int> onProgramSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: programs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: Spacing.familyProgramCardHeight,
        crossAxisSpacing: Spacing.familyProgramGridGap,
        mainAxisSpacing: Spacing.familyProgramGridGap,
      ),
      itemBuilder: (context, index) =>
          FamilyProgramCard(
                program: programs[index],
                isSelected: index == selectedIndex,
                onTap: () => onProgramSelected(index),
                borderColor: color.primary,
                semanticPrefix: locale.family_program_choose_title,
              )
              .animate()
              .fadeIn(
                duration: 350.ms,
                delay: (100 + index * 40).ms,
                curve: Curves.easeOut,
              )
              .slideY(
                begin: 0.08,
                end: 0,
                duration: 350.ms,
                delay: (100 + index * 40).ms,
                curve: Curves.easeOutCubic,
              )
              .scaleXY(
                begin: 0.96,
                end: 1.0,
                duration: 350.ms,
                delay: (100 + index * 40).ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}
