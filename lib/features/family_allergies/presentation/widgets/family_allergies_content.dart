import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_state.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_view_model.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_actions.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_information_note.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergy_selection_section.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_no_allergies_tile.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';

class FamilyAllergiesContent extends StatelessWidget {
  const FamilyAllergiesContent({super.key, required this.state});
  final FamilyAllergiesState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final viewModel = context.read<FamilyAllergiesViewModel>();
    final allergyItems = _filter(
      state.catalog,
      state.allergySearch,
      locale.localeName,
    );
    final ingredientItems = _filter(
      state.ingredients,
      state.ingredientSearch,
      locale.localeName,
    );
    final members = state.members.asMap().entries.map((entry) {
      final member = entry.value;
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: '',
        status: entry.key < state.currentIndex
            ? locale.family_member_completed
            : locale.family_member_in_progress,
        isSelected: entry.key == state.currentIndex,
        isInProgress: entry.key >= state.currentIndex,
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.familySetupHorizontalPadding,
        vertical: Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FamilySetupHeaderBadge(),
          const SizedBox(height: Spacing.md),
          const FamilyProgramStepper(
            currentStep: 2,
            includeFamilyCreationStep: true,
          ),
          const SizedBox(height: Spacing.lg),
          FamilyProgramMemberStrip(members: members),
          const SizedBox(height: Spacing.lg),
          Text(
            locale.family_allergies_food_title,
            textAlign: TextAlign.start,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size17,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            state.currentMember == null
                ? locale.family_allergies_food_subtitle
                : locale.family_allergies_member(
                    state.currentMember!.displayName,
                  ),
            textAlign: TextAlign.start,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.familyAllergiesSectionGap),
          FamilyAllergySelectionSection(
            title: locale.family_allergies_common,
            searchHint: locale.family_allergies_search,
            items: allergyItems,
            selected: state.selectedCodes,
            onSearch: viewModel.changeAllergySearch,
            onToggle: viewModel.toggle,
          ),
          const SizedBox(height: Spacing.familyAllergiesSectionGap),
          FamilyNoAllergiesTile(
            label: locale.family_allergies_none,
            selected: state.selectedCodes.contains('NONE'),
            onTap: () => viewModel.toggle('NONE'),
          ),
          const SizedBox(height: Spacing.familyAllergiesSectionGap),
          FamilyAllergySelectionSection(
            title: locale.family_allergies_rejected,
            searchHint: locale.family_allergies_ingredient_search,
            items: ingredientItems,
            selected: state.rejectedCodes,
            onSearch: viewModel.changeIngredientSearch,
            onToggle: viewModel.toggleRejected,
          ),
          const SizedBox(height: Spacing.familyAllergiesSectionGap),
          FamilyAllergiesInformationNote(
            text: locale.family_allergies_information_note,
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              mapFailureMessage(context, state.errorMessage!),
              textAlign: TextAlign.start,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.error,
              ),
            ),
          ],
          const SizedBox(height: Spacing.md),
          FamilyAllergiesActions(
            nextText: state.currentIndex == state.members.length - 1
                ? locale.family_allergies_next_location
                : locale.family_allergies_save_next_member,
            isLoading: state.isSaving,
            onNext: state.canSave ? viewModel.saveCurrent : null,
            onSkip: () {
              viewModel.toggle('NONE');
              viewModel.saveCurrent();
            },
          ),
          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }

  List<FoodPreferenceCatalogItemEntity> _filter(
    List<FoodPreferenceCatalogItemEntity> items,
    String query,
    String localeName,
  ) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return items;
    return items
        .where(
          (item) => item.name(localeName).toLowerCase().contains(normalized),
        )
        .toList();
  }
}
