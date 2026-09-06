import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';

class AddressChooseLocationSearchBar extends StatelessWidget {
  const AddressChooseLocationSearchBar({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onChanged,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AppTextField(
      controller: controller,
      hint: locale.addresses_search_hint,
      hintStyle: getRegularStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size12,
        color: color.onSurfaceVariant.withValues(alpha: 0.7),
      ),
      textStyle: getRegularStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size12,
        color: color.onSurface,
      ),
      prefixIcon: Icon(
        Icons.search_rounded,
        size: Spacing.iconMd,
        color: color.onSurfaceVariant,
      ),
      textInputAction: TextInputAction.search,
      fillColor: color.surface,
      borderColor: color.outlineVariant,
      borderRadius: Spacing.inputRadius,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      onSubmitted: onSubmitted,
      onChanged: onChanged,
    );
  }
}
