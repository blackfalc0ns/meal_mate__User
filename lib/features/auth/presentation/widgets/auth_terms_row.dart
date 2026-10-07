import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AuthTermsRow extends StatelessWidget {
  const AuthTermsRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: color.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.radiusXs),
          ),
        ),
        const SizedBox(width: Spacing.xs),
        Flexible(
          child: Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

