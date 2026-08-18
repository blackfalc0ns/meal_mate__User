import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_state.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_hero_banner.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_loading_skeleton.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_notes_section.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_option.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_section_card.dart';

class DietaryPreferencesScreen extends StatelessWidget {
  const DietaryPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FoodPreferencesViewModel>(
      create: (_) => getIt<FoodPreferencesViewModel>()
        ..doIntent(const GetFoodPreferencesEvent())
        ..doIntent(const GetFoodPreferencesCatalogEvent()),
      child: BlocListener<FoodPreferencesViewModel, FoodPreferencesState>(
        listenWhen: (previous, current) => previous.action != current.action,
        listener: (context, state) {
          if (state.action.isSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: context.localization.dietary_preferences_update_success,
            );
          }
        },
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Scaffold(
      appBar: CustomAppBar(
        title: locale.profile_dietary_preferences,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: BlocBuilder<FoodPreferencesViewModel, FoodPreferencesState>(
        buildWhen: (previous, current) =>
            previous.preferences != current.preferences ||
            previous.catalog != current.catalog ||
            previous.action != current.action ||
            previous.selection != current.selection,
        builder: (context, state) {
          final preferencesState = state.preferences;
          final catalogState = state.catalog;
          final catalog = catalogState.data;
          final selection = state.selection;

          if ((preferencesState.isLoading && preferencesState.data == null) ||
              (catalogState.isLoading && catalog == null)) {
            return const DietaryPreferencesLoadingSkeleton();
          }

          final failure = preferencesState.failure ?? catalogState.failure;
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

          return SafeArea(
            top: false,
            child: SingleChildScrollView(
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
                      final viewModel = context
                          .read<FoodPreferencesViewModel>();
                      final updated = await navigator.pushNamed(
                        AppRoutes.addAllergy,
                      );
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
                  CustomWarningWidget(
                    icon: Icons.warning_rounded,
                    title: locale.dietary_preferences_allergy_notice_title,
                    message: locale.dietary_preferences_allergy_notice_message,
                    isWarning: true,
                    height: Spacing.dietaryNoticeHeight,
                    backgroundColor: color.secondaryContainer,
                    borderColor: color.outlineVariant,
                    horizontalPadding: Spacing.md,
                    iconSize: Spacing.xl,
                    iconTextSpacing: Spacing.sm,
                    borderRadius: Spacing.dietaryCardRadius,
                    messageFontSize: FontSize.size10,
                  ),
                  const SizedBox(height: Spacing.sm),
                  AppButton.filled(
                    text: locale.dietary_preferences_save,
                    onPressed: () => context
                        .read<FoodPreferencesViewModel>()
                        .doIntent(const SaveFoodPreferencesEvent()),
                    isLoading: state.action.isLoading,
                    height: Spacing.dietarySaveButtonHeight,
                    borderRadius: Spacing.dietarySaveButtonRadius,
                    color: color.primary,
                    textColor: color.onPrimary,
                    fontSize: FontSize.size12,
                  ),
                ],
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
}
