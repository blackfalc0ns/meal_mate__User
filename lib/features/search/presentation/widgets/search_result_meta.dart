import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SearchResultMeta extends StatelessWidget {
  const SearchResultMeta({
    super.key,
    required this.label,
    this.icon,
    this.animationAsset,
  });

  final String label;
  final IconData? icon;
  final String? animationAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size8,
            color: color.onSurface,
          ),
        ),
        const SizedBox(width: Spacing.xs),
        if (animationAsset != null)
          SizedBox.square(
            dimension: Spacing.iconSm - Spacing.xs,
            child: Lottie.asset(
              animationAsset!,
              fit: BoxFit.contain,
              repeat: true,
            ),
          )
        else if (icon != null)
          Icon(icon, size: Spacing.iconSm - Spacing.xs, color: color.primary),
      ],
    );
  }
}
