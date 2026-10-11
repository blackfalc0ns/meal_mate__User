import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_state.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_grid_section.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_save_section.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_search_field.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_summary_card.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_option.dart';

class AddAllergyContent extends StatelessWidget {
  const AddAllergyContent({super.key, this.catalog});

  final FoodPreferencesCatalogEntity? catalog;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final allOptions = _catalogOptions(
      catalog?.allergens ?? const [],
      locale.localeName,
    );
    final allergenLabelsByCode = {
      for (final option in allOptions) option.code: option.label,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.addAllergyScreenHorizontalPadding,
        vertical: Spacing.addAllergyContentTopPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            locale.add_allergy_subtitle,
            textAlign: TextAlign.center,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.md),
          BlocSelector<
            FoodPreferencesViewModel,
            FoodPreferencesState,
            Set<String>
          >(
            selector: (state) => state.selection.activeAllergies,
            builder: (context, activeAllergies) {
              final selectedLabels = activeAllergies
                  .map((code) => allergenLabelsByCode[code])
                  .nonNulls
                  .where((label) => label.isNotEmpty)
                  .toList();
              return AddAllergySummaryCard(selectedAllergies: selectedLabels);
            },
          ),
          const SizedBox(height: Spacing.addAllergySectionGap),
          AddAllergySearchField(
            onChanged: (value) => context
                .read<FoodPreferencesViewModel>()
                .doIntent(FoodPreferenceAllergySearchChangedEvent(value)),
          ),
          const SizedBox(height: Spacing.addAllergySectionGap),
          BlocSelector<
            FoodPreferencesViewModel,
            FoodPreferencesState,
            ({String query, Set<String> selectedCodes})
          >(
            selector: (state) => (
              query: state.selection.allergySearchQuery,
              selectedCodes: state.selection.allergies,
            ),
            builder: (context, data) {
              final query = data.query.trim().toLowerCase();
              final filteredGridOptions = query.isEmpty
                  ? allOptions
                  : allOptions
                        .where(
                          (option) =>
                              option.label.toLowerCase().contains(query),
                        )
                        .toList();
              return AddAllergyGridSection(
                options: filteredGridOptions,
                selectedCodes: data.selectedCodes,
              );
            },
          ),
          const SizedBox(height: Spacing.addAllergySectionGap),
          BlocSelector<FoodPreferencesViewModel, FoodPreferencesState, bool>(
            selector: (state) => state.action.isLoading,
            builder: (context, isLoading) =>
                AddAllergySaveSection(isLoading: isLoading),
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
