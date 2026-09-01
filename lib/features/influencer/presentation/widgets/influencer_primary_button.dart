import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerPrimaryButton extends StatelessWidget {
  const InfluencerPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: Spacing.buttonSmallHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? color.primary : color.surface,
          foregroundColor: filled ? color.onPrimary : color.primary,
          side: BorderSide(color: color.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: filled ? color.onPrimary : color.primary,
          ),
        ),
      ),
    );
  }
}
