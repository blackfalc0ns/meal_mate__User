import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onCancel,
    required this.showCancel,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onCancel;
  final bool showCancel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: SizedBox(
            height: Spacing.xxxl,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spacing.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: .08),
                    blurRadius: Spacing.xss,
                    offset: const Offset(0, Spacing.xs),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                textAlign: TextAlign.right,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  color: color.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: locale.search_hint,
                  prefixIcon: Icon(Icons.search_rounded, color: color.primary),
                  isDense: true,
                  filled: true,
                  fillColor: color.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Spacing.base,
                    vertical: Spacing.sm,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Spacing.radiusLg),
                    borderSide: BorderSide(color: color.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Spacing.radiusLg),
                    borderSide: BorderSide(color: color.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Spacing.radiusLg),
                    borderSide: BorderSide(color: color.primary),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showCancel) ...[
          const SizedBox(width: Spacing.sm),
          TextButton(
            onPressed: onCancel,
            child: Text(
              locale.search_cancel,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
