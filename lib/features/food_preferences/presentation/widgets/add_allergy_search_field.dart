import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddAllergySearchField extends StatelessWidget {
  const AddAllergySearchField({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.addAllergySearchHeight,
      child: TextField(
        onChanged: onChanged,
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
    );
  }
}
