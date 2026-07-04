import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealMateDrawerBackground extends StatelessWidget {
  const MealMateDrawerBackground({
    super.key,
    required this.unitX,
    required this.unitY,
  });

  final double unitX;
  final double unitY;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Positioned(
      top: 204 * unitY,
      left: -14 * unitX,
      child: Container(
        width: 218 * unitX,
        height: 493 * unitY,
        decoration: BoxDecoration(
          color: color.onPrimary.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(38),
        ),
      ),
    );
  }
}

class MealMateDrawerLogoPosition extends StatelessWidget {
  const MealMateDrawerLogoPosition({super.key, required this.unitY});

  final double unitY;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 58 * unitY,
      left: 0,
      right: 0,
      child: const Center(child: MealMateDrawerLogo()),
    );
  }
}

class MealMateDrawerLogo extends StatelessWidget {
  const MealMateDrawerLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 61,
      height: 58,
      child: SvgPicture.asset(Assets.logoWhite, fit: BoxFit.contain),
    );
  }
}

class MealMateDrawerCloseButton extends StatelessWidget {
  const MealMateDrawerCloseButton({
    super.key,
    required this.controller,
    required this.unitX,
    required this.unitY,
  });

  final ZoomDrawerController controller;
  final double unitX;
  final double unitY;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Positioned(
      top: 62 * unitY,
      right: 30 * unitX,
      child: IconButton(
        onPressed: () => controller.close?.call(),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 30, height: 30),
        icon: CircleAvatar(
          radius: 15,
          backgroundColor: color.onPrimary,
          child: Icon(Icons.close_rounded, color: color.primary, size: 24),
        ),
      ),
    );
  }
}
