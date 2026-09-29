import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_option.dart';

class DietaryPreferencesOptionsBottomSheet extends StatefulWidget {
  const DietaryPreferencesOptionsBottomSheet({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
  });

  final List<DietaryPreferencesOption> options;
  final Set<String> selectedOptions;
  final ValueChanged<String> onOptionSelected;

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
    final maxListHeight = MediaQuery.sizeOf(context).height * 0.45;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxListHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
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
    );
  }

  void _toggleOption(String code) {
    widget.onOptionSelected(code);

    setState(() {
      if (code == FoodPreferenceItemEntity.noneCode) {
        _selectedOptions
          ..clear()
          ..add(FoodPreferenceItemEntity.noneCode);
        return;
      }

      _selectedOptions.remove(FoodPreferenceItemEntity.noneCode);

      if (_selectedOptions.contains(code)) {
        _selectedOptions.remove(code);
      } else {
        _selectedOptions.add(code);
      }

      if (_selectedOptions.isEmpty) {
        _selectedOptions.add(FoodPreferenceItemEntity.noneCode);
      }
    });
  }
}
