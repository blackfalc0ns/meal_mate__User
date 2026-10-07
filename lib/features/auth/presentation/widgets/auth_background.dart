import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image.asset(
            Assets.bgRegister,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.surface.withValues(alpha: 0.10),
                  color.surface.withValues(alpha: 0.02),
                  color.surface.withValues(alpha: 0.18),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

