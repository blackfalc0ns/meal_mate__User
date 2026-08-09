import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMembersSearchField extends StatelessWidget {
  const FamilyMembersSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.familyMembersSearchHeight,
      child: TextField(
        textAlign: TextAlign.start,
        style: getRegularStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size11,
          color: color.onSurface,
        ),
        decoration: InputDecoration(
          hintText: locale.family_members_search_hint,
          hintStyle: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurfaceVariant,
          ),
          suffixIcon: Icon(
            Icons.search_rounded,
            size: Spacing.familyMembersSearchIconSize,
            color: color.onSurfaceVariant,
          ),
          filled: true,
          fillColor: color.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              Spacing.familyMembersSearchRadius,
            ),
            borderSide: BorderSide(
              color: color.outlineVariant,
              width: Spacing.border,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              Spacing.familyMembersSearchRadius,
            ),
            borderSide: BorderSide(
              color: color.outlineVariant,
              width: Spacing.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              Spacing.familyMembersSearchRadius,
            ),
            borderSide: BorderSide(color: color.primary, width: Spacing.border),
          ),
        ),
      ),
    );
  }
}
