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
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/food_preferences/data/mapper/food_preferences_mapper.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_state.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_hero_banner.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_notes_section.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_section_card.dart';

class DietaryPreferencesScreen extends StatefulWidget {
  const DietaryPreferencesScreen({super.key});

  @override
  State<DietaryPreferencesScreen> createState() =>
      _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends State<DietaryPreferencesScreen> {
  final Set<String> _diets = <String>{};
  final Set<String> _dislikes = <String>{};
  final Set<String> _allergies = <String>{};
  bool _hasInitialSelections = false;
  bool _hasAppliedRemotePreferences = false;
  String? _notes;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FoodPreferencesViewModel>(
      create: (_) => getIt<FoodPreferencesViewModel>()
        ..doIntent(const GetFoodPreferencesEvent())
        ..doIntent(const GetFoodPreferencesCatalogEvent()),
      child: BlocListener<FoodPreferencesViewModel, FoodPreferencesState>(
        listenWhen: (previous, current) =>
            previous.preferences.data != current.preferences.data,
        listener: (context, state) {
          final preferences = state.preferences.data;
          if (preferences == null || _hasAppliedRemotePreferences) return;
          _applyPreferences(preferences);
        },
        child: _buildContent(context),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasInitialSelections) return;

    final locale = context.localization;
    _diets.add(locale.dietary_preferences_diet_balanced);
    _hasInitialSelections = true;
  }

  void _applyPreferences(FoodPreferencesEntity preferences) {
    setState(() {
      _diets
        ..clear()
        ..addAll([
          if (preferences.dietaryPattern != null) preferences.dietaryPattern!,
        ]);
      _dislikes
        ..clear()
        ..addAll(preferences.dislikedFoods.map((item) => item.code));
      _allergies
        ..clear()
        ..addAll(preferences.allergies.map((item) => item.code));
      _notes = preferences.notes;
      _hasInitialSelections = true;
      _hasAppliedRemotePreferences = true;
    });
  }

  void _toggleSelection(
    Set<String> values,
    String value, {
    bool single = false,
  }) {
    setState(() {
      if (values.contains(value)) {
        values.remove(value);
      } else {
        if (single) values.clear();
        values.add(value);
      }
    });
  }

  Widget _buildContent(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dietOptions = [
      (
        code: locale.dietary_preferences_diet_balanced,
        label: locale.dietary_preferences_diet_balanced,
      ),
      (
        code: locale.dietary_preferences_diet_vegetarian,
        label: locale.dietary_preferences_diet_vegetarian,
      ),
      (
        code: locale.dietary_preferences_diet_vegan,
        label: locale.dietary_preferences_diet_vegan,
      ),
      (
        code: locale.dietary_preferences_diet_keto,
        label: locale.dietary_preferences_diet_keto,
      ),
      (
        code: locale.dietary_preferences_diet_high_protein,
        label: locale.dietary_preferences_diet_high_protein,
      ),
    ];

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
            previous.action != current.action,
        builder: (context, state) {
          final preferencesState = state.preferences;
          final catalogState = state.catalog;
          final catalog = catalogState.data;

          if ((preferencesState.isLoading && preferencesState.data == null) ||
              (catalogState.isLoading && catalog == null)) {
            return const LoadingWidget.fullScreen();
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
                    selectedOptions: _diets,
                    onOptionSelected: (value) =>
                        _toggleSelection(_diets, value, single: true),
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
                    selectedOptions: _dislikes,
                    onOptionSelected: (value) =>
                        _toggleSelection(_dislikes, value),
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
                    selectedOptions: _allergies,
                    onOptionSelected: (value) =>
                        _toggleSelection(_allergies, value),
                    headerTopInset: Spacing.dietaryAllergiesHeaderTopInset,
                    choicesTopInset: Spacing.dietaryAllergiesChoicesTopInset,
                    choicesSpacing: Spacing.dietaryDietChoicesSpacing,
                    actionLabel: locale.dietary_preferences_manage_allergies,
                    onActionPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.addAllergy),
                  ),
                  const SizedBox(height: Spacing.dietarySectionGap),
                  DietaryPreferencesNotesSection(
                    initialValue: _notes,
                    onChanged: (value) => _notes = value,
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
                    onPressed: () =>
                        context.read<FoodPreferencesViewModel>().doIntent(
                          UpdateFoodPreferencesEvent(
                            _buildPreferencesEntity(catalog),
                          ),
                        ),
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

  FoodPreferencesEntity _buildPreferencesEntity(
    FoodPreferencesCatalogEntity? catalog,
  ) {
    return FoodPreferencesEntity(
      dietaryPattern: _diets.isEmpty ? null : _diets.first,
      allergies: _selectedCatalogItems(
        selectedCodes: _allergies,
        catalogItems: catalog?.allergens ?? const [],
      ),
      dislikedFoods: _selectedCatalogItems(
        selectedCodes: _dislikes,
        catalogItems: catalog?.ingredients ?? const [],
      ),
      notes: _notes,
    );
  }

  List<FoodPreferenceItemEntity> _selectedCatalogItems({
    required Set<String> selectedCodes,
    required List<FoodPreferenceCatalogItemEntity> catalogItems,
  }) {
    final itemsByCode = {for (final item in catalogItems) item.code: item};

    return selectedCodes
        .map((code) => itemsByCode[code])
        .nonNulls
        .map((item) => item.toPreferenceItemEntity())
        .toList();
  }
}
