import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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
      backgroundColor: color.surface,
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
            horizontal: Spacing.dietaryScreenHorizontalPadding,
            vertical: Spacing.sm,
          ).copyWith(bottom: Spacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DietaryPreferencesHeroBanner(),
              const SizedBox(height: Spacing.dietarySectionGap),
              DietaryPreferencesSectionCard(
                title: locale.dietary_preferences_diet_title,
                icon: Icons.eco_rounded,
                options: dietOptions,
                selectedOptions: _diets,
                onOptionSelected: (value) =>
                    _toggleSelection(_diets, value, single: true),
              ),
              const SizedBox(height: Spacing.dietarySectionGap),
              DietaryPreferencesSectionCard(
                title: locale.dietary_preferences_dislikes_title,
                icon: Icons.cancel_rounded,
                options: dislikeOptions,
                selectedOptions: _dislikes,
                onOptionSelected: (value) => _toggleSelection(_dislikes, value),
              ),
              const SizedBox(height: Spacing.dietarySectionGap),
              DietaryPreferencesSectionCard(
                title: locale.dietary_preferences_allergies_title,
                icon: Icons.verified_user_rounded,
                options: allergyOptions,
                selectedOptions: _allergies,
                onOptionSelected: (value) =>
                    _toggleSelection(_allergies, value),
                actionLabel: locale.dietary_preferences_manage_allergies,
                onActionPressed: () {},
              ),
              const SizedBox(height: Spacing.dietarySectionGap),
              Container(
                padding: const EdgeInsets.all(Spacing.dietaryCardInset),
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(
                    Spacing.dietaryCardRadius,
                  ),
                  border: Border.all(color: color.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          locale.dietary_preferences_notes_title,
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size10,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(width: Spacing.xss),
                        Icon(
                          Icons.description_rounded,
                          color: color.primary,
                          size: Spacing.dietaryIconSize,
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.sm),
                    SizedBox(
                      height: Spacing.dietaryNotesFieldHeight,
                      child: TextFormField(
                        textAlign: TextAlign.end,
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
                            borderSide: BorderSide(color: color.outlineVariant),
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
              SizedBox(
                height: Spacing.dietarySaveButtonHeight,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Spacing.dietarySaveButtonRadius,
                      ),
                    ),
                  ),
                  child: Text(
                    locale.dietary_preferences_save,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size12,
                      color: color.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
