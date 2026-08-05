import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SearchEmptySuggestionChip extends StatelessWidget {
  const SearchEmptySuggestionChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      button: true,
      label: locale.search_empty_suggestions_title,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: Spacing.searchEmptySuggestionHeight,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(color: color.outlineVariant),
            borderRadius: BorderRadius.circular(
              Spacing.searchEmptySuggestionRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: .08),
                blurRadius: Spacing.sm,
                offset: const Offset(0, Spacing.xss),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: Spacing.iconMd, color: color.primary),
              const SizedBox(width: Spacing.sm),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
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
