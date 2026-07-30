import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SearchSuggestionsPanel extends StatelessWidget {
  const SearchSuggestionsPanel({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.xss),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(color: color.shadow.withValues(alpha: .08), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < suggestions.length; index++) ...[
            ListTile(
              onTap: () => onSuggestionTap(suggestions[index]),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
              ),
              dense: true,
              leading: Icon(
                Icons.chevron_left_rounded,
                color: color.onSurfaceVariant,
              ),
              trailing: Icon(Icons.search_rounded, color: color.primary),
              title: Text(
                suggestions[index],
                textAlign: TextAlign.right,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  color: color.onSurfaceVariant,
                ),
              ),
            ),
            if (index != suggestions.length - 1)
              Divider(color: color.outlineVariant),
          ],
          const SizedBox(height: Spacing.xs),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: color.primary,
              ),
              label: Text(locale.search_suggestions_all),
            ),
          ),
        ],
      ),
    );
  }
}
