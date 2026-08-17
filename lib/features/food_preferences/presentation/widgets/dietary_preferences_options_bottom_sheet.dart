import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_option.dart';

class DietaryPreferencesOptionsBottomSheet extends StatefulWidget {
  const DietaryPreferencesOptionsBottomSheet({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
    required this.singleSelection,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final List<DietaryPreferencesOption> options;
  final Set<String> selectedOptions;
  final ValueChanged<String> onOptionSelected;
  final bool singleSelection;

  @override
  State<DietaryPreferencesOptionsBottomSheet> createState() =>
      _DietaryPreferencesOptionsBottomSheetState();
}

class _DietaryPreferencesOptionsBottomSheetState
    extends State<DietaryPreferencesOptionsBottomSheet> {
  late final Set<String> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = Set<String>.of(widget.selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = MaterialLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Spacing.lg),
            Container(
              width: Spacing.searchFilterSheetHandleWidth,
              height: Spacing.searchFilterSheetHandleHeight,
              decoration: BoxDecoration(
                color: color.outlineVariant,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: Spacing.iconMd,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.options.length,
                separatorBuilder: (_, _) => Divider(
                  height: Spacing.border,
                  thickness: Spacing.border,
                  color: color.outlineVariant,
                ),
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final isSelected = _selectedOptions.contains(option.code);

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size16,
                        color: color.onSurface,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: color.primary,
                            size: Spacing.iconMd,
                          )
                        : null,
                    onTap: () => _toggleOption(option.code),
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close_rounded,
                color: color.primary,
                size: Spacing.iconMd,
              ),
              tooltip: locale.closeButtonTooltip,
            ),
            const SizedBox(height: Spacing.sm),
          ],
        ),
      ),
    );
  }

  void _toggleOption(String code) {
    widget.onOptionSelected(code);

    if (widget.singleSelection) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      if (_selectedOptions.contains(code)) {
        _selectedOptions.remove(code);
      } else {
        _selectedOptions.add(code);
      }
    });
  }
}
