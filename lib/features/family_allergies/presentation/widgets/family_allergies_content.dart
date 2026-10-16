import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/failure_mapper.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_state.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_event.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_view_model.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_actions.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_information_note.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergy_selection_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_header.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_member_strip.dart';

class FamilyAllergiesContent extends StatelessWidget {
  const FamilyAllergiesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyAllergiesViewModel, FamilyAllergiesState>(
      buildWhen: (previous, current) =>
          previous.members != current.members ||
          previous.currentIndex != current.currentIndex ||
          previous.catalog != current.catalog ||
          previous.ingredients != current.ingredients ||
          previous.selectedCodes != current.selectedCodes ||
          previous.rejectedCodes != current.rejectedCodes ||
          previous.allergySearch != current.allergySearch ||
          previous.ingredientSearch != current.ingredientSearch ||
          previous.isSaving != current.isSaving ||
          previous.saveFailure != current.saveFailure ||
          previous.errorMessage != current.errorMessage ||
          previous.completed != current.completed,
      builder: _buildContent,
    );
  }

  Widget _buildContent(BuildContext context, FamilyAllergiesState state) {
    final color = context.colorScheme;
    final locale = context.localization;
    final viewModel = context.read<FamilyAllergiesViewModel>();
    final isInFamilyFlow = FamilyFlowScope.isActive(context);
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
    final totalCount = state.members.length;
    final completedCount = state.members
        .where(
          (m) =>
              m.allergiesCompleted ||
              m.hasNoAllergies ||
              m.allergies.isNotEmpty,
        )
        .length;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;
    final allCompleted = totalCount > 0 && completedCount == totalCount;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isInFamilyFlow) const FamilyAllergiesHeader(),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.familySetupHorizontalPadding,
              ),
              child: FamilyAllergiesMemberStrip(),
            ),
            const SizedBox(height: Spacing.md),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.familySetupHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      locale.family_allergies_food_title,
                      textAlign: TextAlign.start,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      locale.family_allergies_food_subtitle,
                      textAlign: TextAlign.start,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    FamilyAllergySelectionSection(
                      title: locale.family_allergies_common,
                      searchHint: locale.family_allergies_search,
                      items: allergyItems,
                      selected: state.selectedCodes,
                      onSearch: (value) =>
                          viewModel.doIntent(ChangeAllergySearchEvent(value)),
                      onToggle: (code) =>
                          viewModel.doIntent(ToggleFamilyAllergyEvent(code)),
                    ),
                    const SizedBox(height: Spacing.familyAllergiesSectionGap),
                    FamilyAllergySelectionSection(
                      title: locale.family_allergies_rejected,
                      searchHint: locale.family_allergies_ingredient_search,
                      items: ingredientItems,
                      selected: state.rejectedCodes,
                      onSearch: (value) =>
                          viewModel.doIntent(ChangeIngredientSearchEvent(value)),
                      onToggle: (code) =>
                          viewModel.doIntent(ToggleRejectedIngredientEvent(code)),
                    ),
                    const SizedBox(height: Spacing.familyAllergiesSectionGap),
                    FamilyAllergiesInformationNote(
                      text: locale.family_allergies_information_note,
                    ),
                    if (state.saveFailure != null) ...[
                      const SizedBox(height: Spacing.sm),
                      InlineApiErrorWidget(
                        failure: state.saveFailure!,
                        onRetry: viewModel.saveCurrent,
                      ),
                    ] else if (state.errorMessage != null) ...[
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: Spacing.familySetupHorizontalPadding,
                end: Spacing.familySetupHorizontalPadding,
                top: Spacing.sm,
                bottom: Spacing.md,
              ),
              child: FamilyAllergiesActions(
                nextText: locale.family_next_package_days,
                isLoading: false,
                progress: progress,
                progressLabel: totalCount > 1 && !allCompleted
                    ? '($completedCount/$totalCount)'
                    : null,
                onNext: state.isSaving || !allCompleted
                    ? null
                    : () => viewModel.doIntent(
                        const SaveCurrentFamilyAllergiesEvent(),
                      ),
              ),
            ),
          ],
        ),
        if (state.isSaving)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: color.scrim.withValues(alpha: 0.32),
                child: const Center(child: CustomProgressIndicator()),
              ),
            ),
          ),
      ],
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
