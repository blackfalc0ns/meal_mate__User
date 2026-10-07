import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLogo(size: 50),
        const SizedBox(height: Spacing.xl),
        Text(
          title,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size28,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          subtitle,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

