import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_state.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_option_tile.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_summary_card.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_option.dart';

class AddAllergyScreen extends StatelessWidget {
  const AddAllergyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FoodPreferencesViewModel>(
      create: (_) => getIt<FoodPreferencesViewModel>()
        ..doIntent(const GetFoodPreferencesEvent())
        ..doIntent(const GetFoodPreferencesCatalogEvent()),
      child: BlocConsumer<FoodPreferencesViewModel, FoodPreferencesState>(
        listenWhen: (previous, current) => previous.action != current.action,
        listener: (context, state) {
          if (state.action.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message:
                  state.action.errorMessage ?? locale.add_allergy_update_error,
            );
          }

          if (state.action.isSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: locale.add_allergy_update_success,
            );
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final preferencesState = state.preferences;
          final catalogState = state.catalog;
          final catalog = catalogState.data;
          final selection = state.selection;

          return Scaffold(
            appBar: CustomAppBar(
              title: locale.add_allergy_title,
              titleFontSize: FontSize.size15,
              backgroundColor: color.surface,
              showShadow: false,
            ),
            body: SafeArea(
              top: false,
              child: Builder(
                builder: (context) {
                  if ((preferencesState.isLoading &&
                          preferencesState.data == null) ||
                      (catalogState.isLoading && catalog == null)) {
                    return const LoadingWidget.fullScreen();
                  }

                  final failure =
                      preferencesState.failure ?? catalogState.failure;
                  if (failure != null &&
                      (preferencesState.data == null || catalog == null)) {
                    return ApiErrorWidget(
                      exception: failure.exception,
                      onRetry: () {
                        context.read<FoodPreferencesViewModel>()
                          ..doIntent(const GetFoodPreferencesEvent())
                          ..doIntent(const GetFoodPreferencesCatalogEvent());
                      },
                    );
                  }

                  final gridOptions = _catalogOptions(
                    catalog?.allergens ?? const [],
                    locale.localeName,
                  );
                  final filteredGridOptions = gridOptions
                      .where(
                        (option) =>
                            option.label.contains(selection.allergySearchQuery),
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
                        SizedBox(
                          height: Spacing.addAllergySearchHeight,
                          child: TextField(
                            onChanged: (value) => context
                                .read<FoodPreferencesViewModel>()
                                .doIntent(
                                  FoodPreferenceAllergySearchChangedEvent(
                                    value,
                                  ),
                                ),
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintText: locale.add_allergy_search_hint,
                              hintStyle: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size12,
                                color: color.onSurfaceVariant,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  Spacing.addAllergySearchRadius,
                                ),
                                borderSide: BorderSide(
                                  color: color.outlineVariant,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  Spacing.addAllergySearchRadius,
                                ),
                                borderSide: BorderSide(
                                  color: color.outlineVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.addAllergySectionGap),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredGridOptions.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisExtent:
                                    Spacing.addAllergyGridTileHeight,
                                mainAxisSpacing: Spacing.addAllergyGridGap,
                                crossAxisSpacing: Spacing.addAllergyGridGap,
                              ),
                          itemBuilder: (context, index) {
                            final option = filteredGridOptions[index];
                            return AddAllergyOptionTile(
                              label: option.label,
                              isSelected: selection.allergies.contains(
                                option.code,
                              ),
                              onTap: () => context
                                  .read<FoodPreferencesViewModel>()
                                  .doIntent(
                                    ToggleAllergyPreferenceEvent(option.code),
                                  ),
                            );
                          },
                        ),
                        const SizedBox(height: Spacing.addAllergySectionGap),
                        CustomWarningWidget(
                          messageFontSize: FontSize.size10,
                          icon: Icons.warning_rounded,
                          title: locale.add_allergy_note_title,
                          message: locale.add_allergy_note_message,
                          isWarning: true,
                          height: Spacing.addAllergyNoticeHeight,
                          backgroundColor: color.secondaryContainer,
                          borderColor: color.outlineVariant,
                          horizontalPadding: Spacing.sm,
                          iconTextSpacing: Spacing.xs,
                          borderRadius: Spacing.addAllergyNoticeRadius,
                        ),
                        const SizedBox(height: Spacing.md),
                        AppButton.filled(
                          text: locale.add_allergy_save,
                          onPressed: state.action.isLoading
                              ? null
                              : () => context
                                    .read<FoodPreferencesViewModel>()
                                    .doIntent(
                                      const SaveFoodPreferencesAllergiesEvent(),
                                    ),
                          isLoading: state.action.isLoading,
                          height: Spacing.addAllergyButtonHeight,
                          borderRadius: Spacing.addAllergyButtonRadius,
                          textColor: color.onPrimary,
                          fontSize: FontSize.size12,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
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
