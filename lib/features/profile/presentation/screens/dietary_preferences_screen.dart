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
import 'package:meal_meat_user/features/profile/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_view_model.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/dietary_preferences_hero_banner.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/dietary_preferences_notes_section.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/dietary_preferences_section_card.dart';

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
    return BlocProvider<ProfileViewModel>(
      create: (_) =>
          getIt<ProfileViewModel>()..doIntent(const GetFoodPreferencesEvent()),
      child: BlocListener<ProfileViewModel, ProfileState>(
        listenWhen: (previous, current) =>
            previous.foodPreferences.data != current.foodPreferences.data,
        listener: (context, state) {
          final preferences = state.foodPreferences.data;
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
    _dislikes.add(locale.dietary_preferences_dislike_mushroom);
    _allergies
      ..add(locale.dietary_preferences_allergy_nuts)
      ..add(locale.dietary_preferences_allergy_lactose);
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
        ..addAll(preferences.dislikedFoods.map((item) => item.nameAr));
      _allergies
        ..clear()
        ..addAll(preferences.allergies.map((item) => item.nameAr));
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
      locale.dietary_preferences_diet_balanced,
      locale.dietary_preferences_diet_vegetarian,
      locale.dietary_preferences_diet_vegan,
      locale.dietary_preferences_diet_keto,
      locale.dietary_preferences_diet_high_protein,
    ];
    final dislikeOptions = [
      locale.dietary_preferences_dislike_onion,
      locale.dietary_preferences_dislike_mushroom,
      locale.dietary_preferences_dislike_olives,
      locale.dietary_preferences_dislike_coriander,
    ];
    final allergyOptions = [
      locale.dietary_preferences_allergy_nuts,
      locale.dietary_preferences_allergy_lactose,
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.profile_dietary_preferences,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: BlocBuilder<ProfileViewModel, ProfileState>(
        buildWhen: (previous, current) =>
            previous.foodPreferences != current.foodPreferences ||
            previous.action != current.action,
        builder: (context, state) {
          final preferencesState = state.foodPreferences;

          if (preferencesState.isLoading && preferencesState.data == null) {
            return const LoadingWidget.fullScreen();
          }

          if (preferencesState.failure != null &&
              preferencesState.data == null) {
            return ApiErrorWidget(
              exception: preferencesState.failure!.exception,
              onRetry: () => context.read<ProfileViewModel>().doIntent(
                const GetFoodPreferencesEvent(),
              ),
            );
          }

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
                    onPressed: () => context.read<ProfileViewModel>().doIntent(
                      UpdateFoodPreferencesEvent(
                        _buildPreferencesEntity(locale.localeName),
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

  FoodPreferencesEntity _buildPreferencesEntity(String localeName) {
    return FoodPreferencesEntity(
      dietaryPattern: _diets.isEmpty ? null : _diets.first,
      allergies: _allergies
          .map(
            (name) => FoodPreferenceItemEntity(
              code: _codeFromName(name),
              nameAr: localeName == 'ar' ? name : '',
              nameEn: localeName == 'ar' ? '' : name,
              severity: null,
            ),
          )
          .toList(),
      dislikedFoods: _dislikes
          .map(
            (name) => FoodPreferenceItemEntity(
              code: _codeFromName(name),
              nameAr: localeName == 'ar' ? name : '',
              nameEn: localeName == 'ar' ? '' : name,
              severity: null,
            ),
          )
          .toList(),
      notes: _notes,
    );
  }

  String _codeFromName(String name) {
    return name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }
}
