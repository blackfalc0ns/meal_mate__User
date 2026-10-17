import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyFlowHomeAction extends StatelessWidget {
  const FamilyFlowHomeAction({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Tooltip(
      message: locale.nav_home,
      child: IconButton(
        key: const ValueKey('family-flow-home-button'),
        icon: Icon(
          Icons.home_rounded,
          color: color.primary,
          size: Spacing.iconMd,
        ),
        onPressed:
            onPressed ??
            () {
              unawaited(
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                  arguments: 0,
                ),
              );
            },
      ),
    );
  }
}
