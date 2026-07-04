import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/app_shell/presentation/widgets/meal_mate_drawer_chrome.dart';
import 'package:meal_meat_user/features/app_shell/presentation/widgets/meal_mate_drawer_menu_panel.dart';
import 'package:meal_meat_user/features/app_shell/presentation/widgets/meal_mate_drawer_profile_header.dart';

class MealMateDrawerMenu extends StatelessWidget {
  const MealMateDrawerMenu({
    super.key,
    required this.animationValue,
    required this.controller,
    required this.userName,
    required this.greeting,
    required this.avatarAsset,
  });

  final double animationValue;
  final ZoomDrawerController controller;
  final String userName;
  final String greeting;
  final String avatarAsset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final size = MediaQuery.sizeOf(context);
    final unitX = size.width / 393;
    final unitY = size.height / 852;
    final profileMoveValue = Curves.easeOutCubic.transform(
      animationValue.clamp(0.0, 1.0),
    );
    final profileTop = ui.lerpDouble(
      34 * unitY,
      102 * unitY,
      profileMoveValue,
    )!;
    final profileRight = ui.lerpDouble(
      76 * unitX,
      36 * unitX,
      profileMoveValue,
    )!;

    return Material(
      color: AppColors.drawerBackground,
      child: Stack(
        children: [
          MealMateDrawerBackground(unitX: unitX, unitY: unitY),
          MealMateDrawerLogoPosition(unitY: unitY),
          MealMateDrawerCloseButton(
            controller: controller,
            unitX: unitX,
            unitY: unitY,
          ),
          Positioned(
            top: profileTop,
            right: profileRight,
            child: MealMateDrawerProfileHeader(
              animationValue: animationValue,
              userName: userName,
              greeting: greeting,
              avatarAsset: avatarAsset,
              planLabel: l10n.drawer_weight_loss_program,
              packageLabel: l10n.drawer_month_package,
            ),
          ),
          MealMateDrawerMenuPanel(l10n: l10n, unitX: unitX, unitY: unitY),
        ],
      ),
    );
  }
}
