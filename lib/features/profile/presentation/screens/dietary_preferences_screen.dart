import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/dietary_preferences_allergy_notice.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/dietary_preferences_hero_banner.dart';
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

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
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
              DietaryPreferencesSectionCard(iconColor: color.error,
                title: locale.dietary_preferences_dislikes_title,
                icon: Icons.cancel_rounded,
                options: dislikeOptions,
                selectedOptions: _dislikes,
                onOptionSelected: (value) => _toggleSelection(_dislikes, value),
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
                onActionPressed: () {},
              ),
              const SizedBox(height: Spacing.dietarySectionGap),
              Container(
                constraints: const BoxConstraints(
                  minHeight: Spacing.dietaryCardHeight,
                ),
                padding: const EdgeInsets.only(
                  top: Spacing.dietaryNotesHeaderTopInset,
                ),
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(
                    Spacing.dietaryCardRadius,
                  ),
                  border: Border.all(
                    color: color.outlineVariant,
                    width: Spacing.dietaryCardBorderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.07),
                      blurRadius: Spacing.xs,
                      offset: const Offset(0, Spacing.xs),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.dietaryCardInset,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.description_rounded,
                              color: color.primary,
                              size: Spacing.lg,
                            ),
                            const SizedBox(width: Spacing.xss),
                            Text(
                              locale.dietary_preferences_notes_title,
                              style: getBoldStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size12,
                                color: color.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height:
                          Spacing.dietaryNotesFieldTopInset -
                          Spacing.dietaryNotesHeaderTopInset -
                          Spacing.dietaryIconSize,
                    ),
                    SizedBox(
                      height: Spacing.dietaryNotesFieldHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.dietaryNotesFieldHorizontalInset,
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          textDirection: Directionality.of(context),
                          style: getLightStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size10,
                            color: color.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: locale.dietary_preferences_notes_hint,
                            hintTextDirection: Directionality.of(context),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: Spacing.md,
                            ),
                            filled: true,
                            fillColor: color.surfaceContainerHighest,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Spacing.radiusSm,
                              ),
                              borderSide: BorderSide(
                                color: color.outlineVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.dietarySectionGap),
              const DietaryPreferencesAllergyNotice(),
              const SizedBox(height: Spacing.sm),
              AppButton.filled(
                text: locale.dietary_preferences_save,
                onPressed: () {},
                height: Spacing.dietarySaveButtonHeight,
                borderRadius: Spacing.dietarySaveButtonRadius,
                color: color.primary,
                textColor: color.onPrimary,
                fontSize: FontSize.size12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
