import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_state.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_hero_banner.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_notes_section.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_option.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_save_section.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_section_card.dart';

class DietaryPreferencesContent extends StatelessWidget {
  const DietaryPreferencesContent({
    super.key,
    required this.state,
  });

  final FoodPreferencesState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final catalog = state.catalog.data;
    final selection = state.selection;

    final dietOptions = _catalogOptions(
      catalog?.dietaryPreferences ?? const [],
      locale.localeName,
    );
    final dislikeOptions = _catalogOptions(
      catalog?.ingredients ?? const [],
      locale.localeName,
    );
    final allergyOptions = _catalogOptions(
      catalog?.allergens ?? const [],
      locale.localeName,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.sm,
      ).copyWith(bottom: Spacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DietaryPreferencesHeroBanner(),
          const SizedBox(height: Spacing.dietarySectionGap),
          DietaryPreferencesSectionCard(
            iconColor: color.primary,
            title: locale.dietary_preferences_diet_title,
            icon: Icons.eco_rounded,
            options: dietOptions,
            selectedOptions: selection.dietaryPreferences,
            onOptionSelected: (value) => context
                .read<FoodPreferencesViewModel>()
                .doIntent(ToggleDietaryPreferenceEvent(value)),
            headerTopInset: Spacing.dietaryDietHeaderTopInset,
            choicesTopInset: Spacing.dietaryDietChoicesTopInset,
            choicesSpacing: Spacing.dietaryDietChoicesSpacing,
          ),
          const SizedBox(height: Spacing.dietarySectionGap),
          DietaryPreferencesSectionCard(
            iconColor: color.error,
            title: locale.dietary_preferences_dislikes_title,
            icon: Icons.cancel_rounded,
            options: dislikeOptions,
            selectedOptions: selection.dislikedFoods,
            onOptionSelected: (value) => context
                .read<FoodPreferencesViewModel>()
                .doIntent(ToggleDislikedFoodEvent(value)),
            headerTopInset: Spacing.dietaryDislikesHeaderTopInset,
            choicesTopInset: Spacing.dietaryDislikesChoicesTopInset,
            choicesSpacing: Spacing.dietaryDietChoicesSpacing,
          ),
          const SizedBox(height: Spacing.dietarySectionGap),
          DietaryPreferencesSectionCard(
            iconColor: color.error,
            title: locale.dietary_preferences_allergies_title,
            icon: Icons.verified_user_rounded,
            options: allergyOptions,
            selectedOptions: selection.allergies,
            onOptionSelected: (value) => context
                .read<FoodPreferencesViewModel>()
                .doIntent(ToggleAllergyPreferenceEvent(value)),
            headerTopInset: Spacing.dietaryAllergiesHeaderTopInset,
            choicesTopInset: Spacing.dietaryAllergiesChoicesTopInset,
            choicesSpacing: Spacing.dietaryDietChoicesSpacing,
            actionLabel: locale.dietary_preferences_manage_allergies,
            onActionPressed: () async {
              final navigator = Navigator.of(context);
              final viewModel = context.read<FoodPreferencesViewModel>();
              final updated = await navigator.pushNamed(AppRoutes.addAllergy);
              if (updated == true) {
                viewModel.doIntent(const GetFoodPreferencesEvent());
              }
            },
          ),
          const SizedBox(height: Spacing.dietarySectionGap),
          DietaryPreferencesNotesSection(
            initialValue: selection.notes,
            onChanged: (value) => context
                .read<FoodPreferencesViewModel>()
                .doIntent(FoodPreferenceNotesChangedEvent(value)),
          ),
          const SizedBox(height: Spacing.dietarySectionGap),
          DietaryPreferencesSaveSection(
            isLoading: state.action.isLoading,
          ),
        ],
      ),
    );
  }

  List<DietaryPreferencesOption> _catalogOptions(
    List<FoodPreferenceCatalogItemEntity> items,
    String localeName,
  ) {
    return items
        .map(
          (item) => (
            code: item.code,
            label: localeName == 'ar' ? item.nameAr : item.nameEn,
          ),
        )
        .where((item) => item.code.isNotEmpty && item.label.isNotEmpty)
        .toList();
  }
}
