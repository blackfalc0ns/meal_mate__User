import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class DietaryPreferencesNotesSection extends StatelessWidget {
  const DietaryPreferencesNotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      constraints: const BoxConstraints(minHeight: Spacing.dietaryCardHeight),
      padding: const EdgeInsets.only(top: Spacing.dietaryNotesHeaderTopInset),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.dietaryCardRadius),
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
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    borderSide: BorderSide(color: color.outlineVariant),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
