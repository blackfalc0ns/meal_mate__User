import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_event.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_view_model.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_grid.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_grid_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyProgramSelectionSection extends StatelessWidget {
  const FamilyProgramSelectionSection({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final effectiveProgramIndex = _effectiveProgramIndex();
    final displayedPrograms = state.programs
        .asMap()
        .entries
        .map(
          (entry) => FamilyProgramUiModel(
            title: entry.value.name(locale.localeName),
            description: entry.value.description(locale.localeName),
            imageAsset:
                entry.value.imageUrl != null && entry.value.imageUrl!.isNotEmpty
                ? entry.value.imageUrl!
                : entry.value.fallbackImageAsset,
            isSelected:
                effectiveProgramIndex != null &&
                entry.key == effectiveProgramIndex,
          ),
        )
        .toList();

    return Column(
      children: [
        Text(
          locale.family_program_choose_title,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.familyProgramGridTopGap),
        if (state.isProgramsLoading && displayedPrograms.isEmpty)
          const FamilyProgramGridLoadingSkeleton()
        else if (displayedPrograms.isEmpty)
          EmptyStateWidget(
            title: locale.family_program_choose_title,
            description: locale.family_packages_selection_subtitle,
            icon: Icons.restaurant_menu_rounded,
          )
        else
          FamilyProgramGrid(
            programs: displayedPrograms,
            selectedIndex: effectiveProgramIndex,
            onProgramSelected: (index) {
              context.read<FamilyProgramsViewModel>().doIntent(
                SelectFamilyProgramEvent(index),
              );
            },
          ),
      ],
    );
  }

  int? _effectiveProgramIndex() {
    final selectedProgramId = state.selectedMember?.programId;
    if (selectedProgramId != null && selectedProgramId.isNotEmpty) {
      final found = state.programs.indexWhere(
        (program) => program.programId == selectedProgramId,
      );
      return found != -1 ? found : null;
    }
    return state.selectedProgramIndex;
  }
}
