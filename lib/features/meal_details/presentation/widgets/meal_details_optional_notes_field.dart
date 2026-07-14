import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealDetailsOptionalNotesField extends StatelessWidget {
  const MealDetailsOptionalNotesField({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.meal_details_optional_notes_title,
          textAlign: TextAlign.end,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ).copyWith(height: locale.localeName == 'ar' ? 1.45 : 1.2),
        ),
        const SizedBox(height: Spacing.sm),
        TextField(
          minLines: 1,
          maxLines: 2,
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.end,
          style: getRegularStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ).copyWith(height: locale.localeName == 'ar' ? 1.45 : 1.2),
          decoration: InputDecoration(
            hintText: locale.meal_details_optional_notes_hint,
            suffixIcon: Icon(
              Icons.edit_rounded,
              size: Spacing.iconSm,
              color: color.primary,
            ),
            filled: true,
            fillColor: color.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.sm,
            ),
            hintStyle: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size11,
              color: color.onSurfaceVariant,
            ).copyWith(height: locale.localeName == 'ar' ? 1.45 : 1.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
              borderSide: BorderSide(color: color.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
              borderSide: BorderSide(color: color.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
              borderSide: BorderSide(color: color.primary),
            ),
          ),
        ),
      ],
    );
  }
}
