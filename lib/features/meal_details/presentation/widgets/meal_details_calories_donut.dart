import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealDetailsCaloriesDonut extends StatelessWidget {
  const MealDetailsCaloriesDonut({
    super.key,
    required this.calories,
    required this.label,
    this.progress = 0.48,
    this.size = 82.0,
  });

  final String calories;
  final String label;
  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 7.0,
              backgroundColor: color.outlineVariant.withValues(alpha: 0.35),
              valueColor: AlwaysStoppedAnimation<Color>(color.primary),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                calories,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size18,
                  color: color.onSurface,
                ).copyWith(height: 1.0),
              ),
              const SizedBox(height: 3.0),
              Text(
                label,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.onSurfaceVariant,
                ).copyWith(height: 1.1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
