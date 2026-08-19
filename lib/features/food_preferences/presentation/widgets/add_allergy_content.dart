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
  const AddAllergyContent({
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

    final gridOptions = _catalogOptions(
      catalog?.allergens ?? const [],
      locale.localeName,
    );
    final filteredGridOptions = gridOptions
        .where(
          (option) => option.label.contains(selection.allergySearchQuery),
        )
        .toList();
    final selectedLabels = _selectedAllergyLabels(
      catalog?.allergens ?? const [],
      selection.activeAllergies,
      locale.localeName,
    );

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
          AddAllergySummaryCard(
            selectedAllergies: selectedLabels,
          ),
          const SizedBox(height: Spacing.addAllergySectionGap),
          AddAllergySearchField(
            onChanged: (value) => context
                .read<FoodPreferencesViewModel>()
                .doIntent(FoodPreferenceAllergySearchChangedEvent(value)),
          ),
          const SizedBox(height: Spacing.addAllergySectionGap),
          AddAllergyGridSection(
            options: filteredGridOptions,
            selectedCodes: selection.allergies,
          ),
          const SizedBox(height: Spacing.addAllergySectionGap),
          AddAllergySaveSection(
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

  List<String> _selectedAllergyLabels(
    List<FoodPreferenceCatalogItemEntity> items,
    Set<String> selectedAllergies,
    String localeName,
  ) {
    final itemsByCode = {for (final item in items) item.code: item};

    return selectedAllergies
        .map((code) => itemsByCode[code])
        .nonNulls
        .map((item) => localeName == 'ar' ? item.nameAr : item.nameEn)
        .where((label) => label.isNotEmpty)
        .toList();
  }
}
